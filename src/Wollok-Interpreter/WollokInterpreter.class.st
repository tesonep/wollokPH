Class {
	#name : #WollokInterpreter,
	#superclass : #Object,
	#instVars : [
		'rootPackage',
		'contextStack',
		'trueObject',
		'voidObject',
		'nullObject',
		'falseObject'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #'sending messages' }
WollokInterpreter >> accessProperty: aPropertyName receiver: aWollokObject arguments: arguments [ 

	"If it has an argument is a setter if not a getter"

	^ arguments size = 1 
			ifTrue: [ 	aWollokObject resolve: aPropertyName andPut: arguments first.
								aWollokObject ]
			ifFalse: [ aWollokObject resolve: aPropertyName ]
]

{ #category : #'native objects' }
WollokInterpreter >> activatePrimitiveMethod [
	
	| context nativeObject |
	context := self currentContext.

	context method native 
		ifNil: [self error: 'The current method is not a native one'].
	
	nativeObject := context receiver wollokClass lookupNativeObjectForMethod: context method name value.
	
	nativeObject ifNil: [ self error: 'Could not find the native object for ' , context receiver wollokClass fullyQualifiedName asString ].
	
	nativeObject activateNativeContext: context.
]

{ #category : #'visiting - literals' }
WollokInterpreter >> asWollokBoolean: aBoolean [

	^ aBoolean
		ifTrue: [ self trueObject ]
		ifFalse: [ self falseObject ]
]

{ #category : #'visiting - literals' }
WollokInterpreter >> asWollokList: elements [

	| listClass |
	
	listClass := self currentContext resolve: 'wollok.lang.List'.

	^ WollokInmediate new 
		wollokClass: listClass;
		instanceVariables: {elements};
		yourself	
]

{ #category : #'visiting - literals' }
WollokInterpreter >> asWollokNumber: aNumber [ 

	| numberClass |

	numberClass := self currentContext resolve: 'wollok.lang.Number'.

	^ WollokInmediate new 
		wollokClass: numberClass;
		instanceVariables: {aNumber};
		yourself
]

{ #category : #'visiting - literals' }
WollokInterpreter >> asWollokString: aString [

	| stringClass |

	stringClass := self currentContext resolve: 'wollok.lang.String'.

	^ WollokInmediate new 
		wollokClass: stringClass;
		instanceVariables: {aString};
		yourself	


]

{ #category : #'anonymous classes' }
WollokInterpreter >> createAnonymousClassForObjectLiteral: aWollokObjectLiteralNode [ 

	| superclassName superclass |
	
	superclassName := aWollokObjectLiteralNode superclass ifNil: [WollokClass defaultSuperclassName].

	superclass := self currentContext resolve: superclassName.

	^ WollokClass new 
		initializeFromAST: aWollokObjectLiteralNode withName: '_AnonymousClass';
		parent: self currentContext;
		superclass: superclass;
		resolveBindingsUsing: self;
		initializeStateUsing: self;
		yourself
]

{ #category : #'anonymous classes' }
WollokInterpreter >> createAnonymousClasssForNamedObjectLiteral: aWollokObjectLiteralNode [ 

	| superclassName superclass |
	
	superclassName := aWollokObjectLiteralNode superclass ifNil: [WollokClass defaultSuperclassName].

	superclass := self currentContext resolve: superclassName.

	^ WollokClass new 
		initializeFromAST: aWollokObjectLiteralNode withName: '_' , aWollokObjectLiteralNode name value , 'Class';
		parent: self currentContext;
		superclass: superclass;
		yourself
]

{ #category : #'context creation' }
WollokInterpreter >> currentContext [

	contextStack ifEmpty: [ ^ nil ].

	^ contextStack top
]

{ #category : #'private - variadic arguments' }
WollokInterpreter >> distributeArguments: initialArguments intoParameters: parameters [ 
	| remainingArguments arguments |

	arguments := Dictionary new.
	remainingArguments := initialArguments copy.

	parameters do: [ :aParameter |
		aParameter isVarArg 
			ifNil: [ 
				remainingArguments size < 1 
					ifTrue:[self throwExceptionWithMessage: 'Not enough arguments'].

				arguments at: aParameter parameter value put: remainingArguments first.
				remainingArguments := remainingArguments allButFirst ] 
			ifNotNil: [ 
				"Variable parameter consume all remaining arguments"
				arguments at: aParameter parameter value put: (self asWollokList: remainingArguments).
				remainingArguments := #()]].
		
	remainingArguments size = 0 ifFalse: [ self throwExceptionWithMessage: 'Too many arguments' ].
		
	^ arguments
]

{ #category : #accessing }
WollokInterpreter >> falseObject [
	
	| booleanClass |
	
	^ falseObject ifNil: [ 
			booleanClass := self currentContext resolve: 'wollok.lang.Boolean'.
		  falseObject := WollokInmediate new 
				wollokClass: booleanClass;
				instanceVariables: {false};
				yourself ]
]

{ #category : #'private - visiting' }
WollokInterpreter >> handleDoubleAnd: aNode [ 
	
	"This special case implements the short-circuit in the and operation"
	| left |

	left := aNode leftOperand acceptVisitor: self.

	^ self asWollokBoolean: (left asBoolean and: [ (aNode rightOperand acceptVisitor: self) asBoolean ])
]

{ #category : #'private - visiting' }
WollokInterpreter >> handleDoubleOr: aNode [ 

	"This special case implements the short-circuit in the or operation"
	| left |
	
	left := aNode leftOperand acceptVisitor: self.

	^ self asWollokBoolean: (left asBoolean or: [ (aNode rightOperand acceptVisitor: self) asBoolean ])
]

{ #category : #initialization }
WollokInterpreter >> initialize [

	super initialize.
	contextStack := Stack new
]

{ #category : #'api - interpreting' }
WollokInterpreter >> interpretProgram: aWollokFileNode [ 

	| lastValue |
	
	rootPackage := WollokLoader new
		interpreter: self;
		rootFile: aWollokFileNode;
		load.

	rootPackage resolveBindingsUsing: self.
	rootPackage initializeStateUsing: self.

	self pushContext: (WollokContext new
		sender: self currentContext;
		receiver: rootPackage main;
		selector: rootPackage main name;
		yourself).

	lastValue := self currentContext resolve: 'wollok.lang.void'.

	rootPackage main ast elements do: [ :e | lastValue := e acceptVisitor: self ].

	self popContext.
	
	^ lastValue
]

{ #category : #'api - interpreting' }
WollokInterpreter >> interpretSuite: aWollokTestSuite storingResultsIn: aWollokTestResult [ 

	aWollokTestSuite tests do: [ :aTest |
		aWollokTestSuite fixture ifNotNil: [:aFixture | self interpretFixture: aFixture ].
		self interpretTest: aTest storingResultsIn: aWollokTestResult.
		self resetInterpreterState ]
]

{ #category : #'api - interpreting' }
WollokInterpreter >> interpretTest: aWollokTestCase storingResultsIn: aWollokTestResult [ 

	self pushContext: (WollokContext new
			sender: self currentContext;
			receiver: aWollokTestCase;
			selector: aWollokTestCase name;
			yourself).

	aWollokTestCase ast elements do: [ :e | e acceptVisitor: self ].
	
	self popContext.
	
	aWollokTestResult recordSuccessful: aWollokTestCase.
]

{ #category : #'api - interpreting' }
WollokInterpreter >> interpretTests: aWollokFileNode [ 

	| wollokTestResult |
	
	rootPackage := WollokLoader new
		interpreter: self;
		rootFile: aWollokFileNode;
		load.

	rootPackage resolveBindingsUsing: self.
	rootPackage initializeStateUsing: self.

	wollokTestResult := WollokTestResult new.

	rootPackage suites do: [ :aSuite | self interpretSuite: aSuite storingResultsIn: wollokTestResult ].

	^ wollokTestResult
]

{ #category : #'native objects' }
WollokInterpreter >> lookupNativeObjectFor: aWollokClass [

	| nativeObjectClass |
	nativeObjectClass := WollokNativeObject allSubclasses
		detect: [ :aClass | 
			aClass wollokClassName asWollokQualifiedName = aWollokClass fullyQualifiedName ]
		ifNone: [ ^ nil ].
		
	^ nativeObjectClass basicNew
		interpreter: self;
		yourself
		
]

{ #category : #accessing }
WollokInterpreter >> nullObject [
	
	"In the default implementation there is no class for null.... aggghghghg"
	| objectClass |
	
	^ nullObject ifNil: [ 
			objectClass := self currentContext resolve: 'wollok.lang.Object'.
		  nullObject := WollokObject new 
				wollokClass: objectClass;
				instanceVariables: #();
				yourself ]
]

{ #category : #'context creation' }
WollokInterpreter >> popContext [
	
	contextStack pop
]

{ #category : #'context creation' }
WollokInterpreter >> popContextUntil: aWollokContext [ 
	
	[ self currentContext = aWollokContext ]
		whileFalse: [ self popContext ].
]

{ #category : #'context creation' }
WollokInterpreter >> pushContext: aCreationContext [
 
	contextStack push: aCreationContext
]

{ #category : #'context creation' }
WollokInterpreter >> pushContextForSelector: aSelector receiver: aReceiver method: aMethod withArguments: aCollection [ 
	
	| context arguments |
	
	arguments := self distributeArguments: aCollection intoParameters: aMethod parameters.
	
	context := WollokContext new
		sender: self currentContext;
		method: aMethod;
		receiver: aReceiver;
		selector: aSelector;
		arguments: arguments;
		returnValue: self voidObject;
		yourself.
		
	self pushContext: context.
	
	^ context

]

{ #category : #'context creation' }
WollokInterpreter >> pushInitializationContextFor: aWollokElement [
	
	self pushContext:
			(WollokContext new
				sender: self currentContext;
				receiver: aWollokElement;
				selector: #__init__;
				yourself)
]

{ #category : #state }
WollokInterpreter >> resetInterpreterState [

	rootPackage 
		resetState;	
		initializeStateUsing: self
]

{ #category : #resolving }
WollokInterpreter >> resolve: aString [ 
	
	self currentContext ifNil: [ ^ rootPackage resolve: aString ].
	^ self currentContext resolve: aString
]

{ #category : #accessing }
WollokInterpreter >> rootPackage [

	^ rootPackage

]

{ #category : #accessing }
WollokInterpreter >> rootPaths [
	
	^ { self class libraryRootDirectory asAbsolute asPath }
]

{ #category : #'sending messages' }
WollokInterpreter >> sendMessage: aSelector to: aReceiver withArguments: arguments [ 

	| aMethod context argumentsToUse selectorToUse |
	
	(aReceiver wollokClass isProperty: aSelector)
		ifTrue: [ ^ self accessProperty: aSelector receiver: aReceiver arguments: arguments ].
	
	aMethod := aReceiver wollokClass 
		lookupSelector: aSelector 
		usingArguments: arguments size.
	
	argumentsToUse := arguments.
	selectorToUse := aSelector.
	
	aMethod ifNil: [ "Handles MNU"
		aMethod := aReceiver wollokClass
			lookupSelector: 'messageNotUnderstood'
			usingArguments: 2.
			
		selectorToUse := 'messageNotUnderstood'.
		argumentsToUse := { self asWollokString: aSelector. self asWollokList: arguments }].
	
	context := self pushContextForSelector: selectorToUse 
			receiver: aReceiver
			method: aMethod
			withArguments: argumentsToUse.
	
	
	aMethod native ifNil: [ 		
		aMethod expressionReturns 
			ifNotNil: [ context returnValue: (aMethod expression acceptVisitor: self)]
			ifNil:[ aMethod expression acceptVisitor: self]]
		ifNotNil: [ self activatePrimitiveMethod ].
			
	self popContext.
	
	^ context returnValue.
]

{ #category : #exceptions }
WollokInterpreter >> throwException: aWollokObject [ 

	"We add another inst. var. only accessible to the interpreter and native code with the contexts"
	aWollokObject instanceVariables: (aWollokObject instanceVariables copyWith: self currentContext copyToTop).
	
	WollokError new
		messageText: (aWollokObject instanceVariables at: 1) asString;
		wollokException: aWollokObject;
		signal.
]

{ #category : #exceptions }
WollokInterpreter >> throwExceptionWithMessage: aString [ 
	
	self throwExceptionWithMessage: aString exceptionClassName: 'wollok.lang.Exception'
]

{ #category : #signalling }
WollokInterpreter >> throwExceptionWithMessage: aWollokString exceptionClassName: aString [
	
	| exceptionClass anException |
	
	exceptionClass := self currentContext resolve: aString.

	anException := WollokObject new 
		wollokClass: exceptionClass;
		instanceVariables: {aWollokString. nullObject };
		yourself.
		
	self throwException: anException
]

{ #category : #accessing }
WollokInterpreter >> trueObject [
	
	| booleanClass |
	
	^ trueObject ifNil: [ 
			booleanClass := self currentContext resolve: 'wollok.lang.Boolean'.
		  trueObject := WollokInmediate new 
				wollokClass: booleanClass;
				instanceVariables: {true};
				yourself ]
]

{ #category : #visiting }
WollokInterpreter >> visitAssignment: aNode [ 
	
	| value |
	
	value := aNode value acceptVisitor: self.
	
	self currentContext resolve: aNode variable name value andPut: value.
	^ value
]

{ #category : #visiting }
WollokInterpreter >> visitBinaryOperation: aNode [ 

	| left right operator |

	operator := aNode operation value.
	
	operator asSymbol = #&& ifTrue: [ ^ self handleDoubleAnd: aNode ].
	operator asSymbol = #|| ifTrue: [ ^ self handleDoubleOr: aNode ].

	left := aNode leftOperand acceptVisitor: self.
	right := aNode rightOperand acceptVisitor: self.	
	
	^ self 
		sendMessage: operator
		to: left 
		withArguments: { right }
]

{ #category : #visiting }
WollokInterpreter >> visitBlockExpression: aNode [ 

	| lastExpression |
	lastExpression := self voidObject.

	aNode expressions do: [ :aStatement | 
					self currentContext hasReturned 
						ifFalse: [ lastExpression := aStatement acceptVisitor: self ]].
					
	^ lastExpression
]

{ #category : #'visiting - literals' }
WollokInterpreter >> visitBooleanLiteral: aWollokBooleanLiteralNode [ 

	^ self asWollokBoolean: (aWollokBooleanLiteralNode value value = 'true') 

]

{ #category : #visiting }
WollokInterpreter >> visitCatch: aWollokCatchNode [ 

	^ aWollokCatchNode expression acceptVisitor: self
]

{ #category : #visiting }
WollokInterpreter >> visitClosure: aWollokClosureNode [ 

	^ WollokClosure new 
			wollokClass: (self currentContext resolve: 'wollok.lang.Closure');
			homeContext: self currentContext;
			ast: aWollokClosureNode;
			instanceVariables: #();
			yourself
			
		
]

{ #category : #visiting }
WollokInterpreter >> visitConstructorCall: aWollokConstructorCallNode [ 

	| aClass arguments |
	aClass := self resolve: aWollokConstructorCallNode classRef asWollokQualifiedName.

	arguments := aWollokConstructorCallNode argumentList 
		ifNil: [Dictionary new] 
		ifNotNil: [ 
			WollokConstructorArgumentVisitor 
				extractArguments: aWollokConstructorCallNode argumentList
				using: self  ].

	^ aClass instantiateUsing: self with: arguments
]

{ #category : #visiting }
WollokInterpreter >> visitIfExpression: aWollokIfExpressionNode [ 

	| conditionResult |
	conditionResult := aWollokIfExpressionNode condition acceptVisitor: self.

	^ conditionResult asBoolean
		ifTrue: [ aWollokIfExpressionNode then acceptVisitor: self ]
		ifFalse: [ aWollokIfExpressionNode else 
			ifNotNil: [ :elseExpression | elseExpression acceptVisitor: self ] ]
]

{ #category : #'visiting - literals' }
WollokInterpreter >> visitListLiteral: aNode [ 

	| elements |
	
	elements := aNode elements collect: [ :e | e acceptVisitor: self ].
	^ self asWollokList: elements
]

{ #category : #visiting }
WollokInterpreter >> visitMemberFeatureCall: aFeatureCallNode [ 

	| receiver arguments |
	
	receiver := aFeatureCallNode receiver acceptVisitor: self.
	arguments := aFeatureCallNode arguments collect: [:anArgument | anArgument acceptVisitor: self].
	
	^ self sendMessage: aFeatureCallNode feature value to: receiver withArguments: arguments
]

{ #category : #visiting }
WollokInterpreter >> visitNullLiteral: aWollokNullLiteralNode [ 

	^ self nullObject
]

{ #category : #'visiting - literals' }
WollokInterpreter >> visitNumberLiteral: aWollokNumberLiteralNode [ 

	| aNumber |

	aNumber := Number readFrom: aWollokNumberLiteralNode value value.

	^ self asWollokNumber: aNumber
]

{ #category : #'visiting - literals' }
WollokInterpreter >> visitObjectLiteral: aWollokObjectLiteralNode [

	| anAnonymousClass |
	anAnonymousClass := self createAnonymousClassForObjectLiteral: aWollokObjectLiteralNode.
	^ anAnonymousClass instantiateUsing: self.

]

{ #category : #visiting }
WollokInterpreter >> visitParenthesizedExpression: aWollokParenthesizedExpressionNode [ 
	
	^ aWollokParenthesizedExpressionNode expression acceptVisitor: self
]

{ #category : #visiting }
WollokInterpreter >> visitReturnExpression: aNode [ 
	
	self currentContext 
		returnValue: (aNode expression acceptVisitor: self).
		
	self currentContext beReturned.
	
	^ self currentContext returnValue
]

{ #category : #visiting }
WollokInterpreter >> visitSelf: aWollokSelfNode [ 
	
	^ self currentContext receiver
]

{ #category : #'visiting - literals' }
WollokInterpreter >> visitStringLiteral: aWollokStringLiteralNode [ 

	^ self asWollokString: (aWollokStringLiteralNode value value copyWithout: $").


]

{ #category : #visiting }
WollokInterpreter >> visitThrow: aNode [

	| aWollokException |
	aWollokException := aNode exception acceptVisitor: self.
	self throwException: aWollokException
]

{ #category : #visiting }
WollokInterpreter >> visitTry: aWollokTryNode [
	| aClosure tryContext |

	tryContext := self currentContext.

	[ [ aClosure := aWollokTryNode expression acceptVisitor: self.
	self sendMessage: 'apply' to: aClosure withArguments: {} ]
		on: WollokError
		do: [ :e | 
			| aWollokException catchClosure |
			aWollokException := e wollokException.

			self popContextUntil: tryContext.
			
			(aWollokTryNode catchBlocks size > 1) ifTrue: [self notYetImplemented].

			catchClosure := aWollokTryNode catchBlocks first
				acceptVisitor: self.

			catchClosure
				argumentAt: aWollokTryNode catchBlocks first exceptionVarName name value
				put: aWollokException.

			self sendMessage: 'apply' to: catchClosure withArguments: {} ] ]
		ensure: [ 
			self popContextUntil: tryContext.
			aWollokTryNode alwaysExpression ifNotNil: [ self notYetImplemented  ] ]
]

{ #category : #visiting }
WollokInterpreter >> visitUnaryOperation: aWollokUnaryOperationNode [ 

	| operator selector |
	
	operator := aWollokUnaryOperationNode operation value.
	
	selector := (Dictionary newFromPairs: {	
		'!'. 'negate'.
		'not'. 'negate'.
		'-'. 'invert' }) at: operator.

	^ self 
		sendMessage: selector
		to: (aWollokUnaryOperationNode rightOperand acceptVisitor: self) 
		withArguments: #().
]

{ #category : #visiting }
WollokInterpreter >> visitVariable: aWollokVariableNode [ 

	^ (self currentContext resolve: aWollokVariableNode name value) assignedValue
]

{ #category : #visiting }
WollokInterpreter >> visitVariableDeclaration: aNode [ 

	| aValue |
	aValue := aNode right acceptVisitor: self.

	self currentContext 
		declareVariable: aNode variable name value
		withValue: aValue.
		
	^ aValue
]

{ #category : #accessing }
WollokInterpreter >> voidObject [
	
	^ voidObject ifNil: [ voidObject := (self rootPackage resolve: 'wollok.lang.void') assignedValue ]

]
