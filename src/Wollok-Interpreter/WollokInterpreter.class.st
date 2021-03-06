Class {
	#name : #WollokInterpreter,
	#superclass : #Object,
	#instVars : [
		'rootPackage',
		'contextStack',
		'trueObject',
		'voidObject',
		'nullObject',
		'falseObject',
		'numberClass',
		'booleanClass',
		'stringClass'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #'sending messages' }
WollokInterpreter >> accessProperty: aPropertyName receiver: aWollokObject arguments: arguments [
	"If it has an argument is a setter if not a getter"

	^ arguments size = 1
		ifTrue: [ aWollokObject
				resolve: aPropertyName
				andPut: arguments first
				inInterpreter: self.
			aWollokObject ]
		ifFalse: [ aWollokObject resolve: aPropertyName ]
]

{ #category : #'sending messages' }
WollokInterpreter >> activateMethod: methodToActivate withReceiver: aReceiver withArguments: argumentsToUse [
	| context |
	
	context := self
		pushContextForSelector: nil
		receiver: aReceiver
		method: methodToActivate
		methodClass: nil
		withArguments: argumentsToUse.
	
	methodToActivate interpretOn: self.

	self popContext.
	^ context
]

{ #category : #'native objects' }
WollokInterpreter >> activatePrimitiveMethod [
	
	| context nativeObject |
	context := self currentContext.

	context method native 
		ifNil: [self error: 'The current method is not a native one'].
	
	nativeObject := context receiver wollokClass lookupNativeObjectForMethod: context method name.
	
	nativeObject ifNil: [ self error: 'Could not find the native object for ' , context receiver wollokClass fullyQualifiedName asString ].
	
	nativeObject activateNativeContext: context.
]

{ #category : #'native objects' }
WollokInterpreter >> applyClosure: aWollokClosure withArguments: aCollection [

	| arguments |
	arguments := self
		distributeArguments: aCollection
		intoParameters: aWollokClosure ast parameters.
	
	aWollokClosure arguments addAll: arguments.
	^ aWollokClosure ast expression acceptVisitor: self
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

	^ WollokInmediate new 
		wollokClass: self numberClass;
		instanceVariables: {aNumber asScaledDecimal round: 5};
		yourself
]

{ #category : #'visiting - literals' }
WollokInterpreter >> asWollokSet: elements [

	| setClass |
	
	setClass := self currentContext resolve: 'wollok.lang.Set'.

	^ WollokInmediate new 
		wollokClass: setClass;
		instanceVariables: {elements asSet};
		yourself	
]

{ #category : #'visiting - literals' }
WollokInterpreter >> asWollokString: aString [

	^ WollokInmediate new 
		wollokClass: self stringClass;
		instanceVariables: {aString};
		yourself	


]

{ #category : #accessing }
WollokInterpreter >> booleanClass [

	^ booleanClass ifNil: [booleanClass := self currentContext resolve: 'wollok.lang.Boolean']

]

{ #category : #accessing }
WollokInterpreter >> contextStack [
	^ contextStack
]

{ #category : #'anonymous classes' }
WollokInterpreter >> createAnonymousClassForObjectLiteral: aWollokObjectLiteralNode [ 

	| superclassName superclass |
	
	superclassName := aWollokObjectLiteralNode superclass ifNil: [WollokClass defaultSuperclassName].

	superclass := self currentContext resolve: superclassName.

	^ WollokClass new 
		initializeFromAST: aWollokObjectLiteralNode withName: '_AnonymousClass';
		parent: self currentContext package;
		superclass: superclass;
		resolveBindingsUsing: self;
		initializeStateUsing: self;
		yourself
]

{ #category : #'anonymous classes' }
WollokInterpreter >> createAnonymousClasssForNamedObjectLiteral: aWollokObjectLiteralNode [ 

	| superclassName superclass aClass nativeObject |
	
	superclassName := aWollokObjectLiteralNode superclass ifNil: [WollokClass defaultSuperclassName].

	superclass := self currentContext resolve: superclassName.

	aClass := WollokClass new 
		initializeFromAST: aWollokObjectLiteralNode withName: '_' , aWollokObjectLiteralNode name value , 'Class';
		parent: self currentContext package;
		superclass: superclass;
		yourself.

	nativeObject := self lookupNativeObjectFor: aClass.
	aClass nativeObject: nativeObject.	

	^ aClass.
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

{ #category : #visiting }
WollokInterpreter >> executeConstructorNode: aConstructorNode inClass: aClass [

	| arguments |

	arguments := WollokConstructorArguments 
								extractArguments: aConstructorNode argumentList
								using: self.

	^ aClass instantiateUsing: self with: arguments
]

{ #category : #accessing }
WollokInterpreter >> falseObject [
	
	^ falseObject ifNil: [ 
		  falseObject := WollokInmediate new 
				wollokClass: self booleanClass;
				instanceVariables: {false};
				yourself ]
]

{ #category : #visiting }
WollokInterpreter >> handleCatchException: aPharoException forTryNode: aWollokTryNode [

	| catchBlockStream currentCatchBlock wollokException |
	aWollokTryNode catchBlocks size = 0 ifTrue: [ ^ self ].
	wollokException := aPharoException wollokException.
	
	catchBlockStream := aWollokTryNode catchBlocks readStream.
	currentCatchBlock := catchBlockStream next.
	[ currentCatchBlock isNil
		or: [currentCatchBlock exceptionType isNil
		or: [ (self resolve: currentCatchBlock exceptionType) 
			= wollokException wollokClass ]] ] whileFalse: [ 
		currentCatchBlock := catchBlockStream next ].

	"If no catch block matched, rethrow"
	currentCatchBlock ifNil: [ aPharoException pass ].

	self currentContext
		declareVariable: currentCatchBlock exceptionVarName name value
		withValue: wollokException.

	^ self visitMaybeClosureAsBlock: currentCatchBlock expression
]

{ #category : #'private - visiting' }
WollokInterpreter >> handleDoubleAnd: aNode [ 
	
	"This special case implements the short-circuit in the and operation"
	| left |
	
	left := aNode leftOperand acceptVisitor: self.

	left wollokClass = self booleanClass
		ifFalse: [self throwExceptionWithMessage: 'Receiver of || should be Boolean' ].	

	^ self asWollokBoolean: (left asBoolean and: [ | right |
		right := aNode rightOperand acceptVisitor: self.
		
		right wollokClass = self booleanClass
			ifFalse: [self throwExceptionWithMessage: 'Argument of || should be Boolean' ].	
		
		right asBoolean ])
]

{ #category : #'private - visiting' }
WollokInterpreter >> handleDoubleOr: aNode [ 

	"This special case implements the short-circuit in the or operation"
	| left |
	
	left := aNode leftOperand acceptVisitor: self.

	left wollokClass = self booleanClass
		ifFalse: [self throwExceptionWithMessage: 'Receiver of || should be Boolean' ].	

	^ self asWollokBoolean: (left asBoolean or: [ | right |
		right := aNode rightOperand acceptVisitor: self.
		
		right wollokClass = self booleanClass
			ifFalse: [self throwExceptionWithMessage: 'Argument of || should be Boolean' ].	
		
		right asBoolean ])
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
		self interpretTest: aTest storingResultsIn: aWollokTestResult.
		self resetInterpreterState ]
]

{ #category : #'api - interpreting' }
WollokInterpreter >> interpretTest: aWollokTestCase storingResultsIn: aWollokTestResult [ 

	self
		activateMethod: aWollokTestCase
		withReceiver: (aWollokTestCase suite instantiateUsing: self)
		withArguments: #().

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

{ #category : #accessing }
WollokInterpreter >> numberClass [

	^ numberClass ifNil: [numberClass := self currentContext resolve: 'wollok.lang.Number']

]

{ #category : #'context creation' }
WollokInterpreter >> popContext [
	
	contextStack pop
]

{ #category : #'context creation' }
WollokInterpreter >> popContextUntil: aWollokContext [ 
	
	self assert: (contextStack includes: aWollokContext).
	
	[ self currentContext = aWollokContext ]
		whileFalse: [ self popContext ].
]

{ #category : #'context creation' }
WollokInterpreter >> pushContext: aCreationContext [
 
	contextStack push: aCreationContext
]

{ #category : #'context creation' }
WollokInterpreter >> pushContextForSelector: aSelector receiver: aReceiver method: aMethod methodClass: aMethodClass withArguments: aCollection [ 
	
	| context arguments |
	
	arguments := self distributeArguments: aCollection intoParameters: aMethod parameters.
	
	context := WollokContext new
		sender: self currentContext;
		method: aMethod;
		receiver: aReceiver;
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
WollokInterpreter >> rootPackage: aWollokPackage [ 
	rootPackage := aWollokPackage
]

{ #category : #accessing }
WollokInterpreter >> rootPaths [
	
	^ { self class libraryRootDirectory asAbsolute asPath }
]

{ #category : #'sending messages' }
WollokInterpreter >> sendMessage: aSelector to: aReceiver withArguments: arguments [ 

	^ self sendMessage: aSelector to: aReceiver withArguments: arguments isSuperSend: false
]

{ #category : #'sending messages' }
WollokInterpreter >> sendMessage: aSelector to: aReceiver withArguments: arguments isSuperSend: aBoolean [
	| context argumentsToUse lookupClass methodToActivate |

	"Handles MNU"
	(aReceiver wollokClass isProperty: aSelector)
		ifTrue: [ ^ self
				accessProperty: aSelector
				receiver: aReceiver
				arguments: arguments ].

	lookupClass := aBoolean
		ifTrue: [ self currentContext method methodClass superclass ]
		ifFalse: [ aReceiver wollokClass ].

	methodToActivate := lookupClass
		lookupSelector: aSelector
		usingArguments: arguments size.

	argumentsToUse := arguments.
	methodToActivate ifNil: [
		methodToActivate := aReceiver wollokClass
			lookupSelector: 'messageNotUnderstood'
			usingArguments: 2.
		argumentsToUse := {(self asWollokString: aSelector).
		(self asWollokList: arguments)} ].

	context := self
		activateMethod: methodToActivate
		withReceiver: aReceiver
		withArguments: argumentsToUse.
	
	^ context returnValue
]

{ #category : #accessing }
WollokInterpreter >> stringClass [
	
	^ stringClass ifNil: [ stringClass := self resolve: 'wollok.lang.String' ]
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
WollokInterpreter >> throwExceptionWithMessage: aString exceptionClassName: wollokClassName [
	
	| exceptionClass anException |
	
	exceptionClass := self currentContext resolve: wollokClassName.

	anException := WollokObject new 
		wollokClass: exceptionClass;
		instanceVariables: {self asWollokString: aString. nullObject };
		yourself.
		
	self throwException: anException
]

{ #category : #accessing }
WollokInterpreter >> trueObject [
	
	^ trueObject ifNil: [ 
		  trueObject := WollokInmediate new 
				wollokClass: self booleanClass;
				instanceVariables: {true};
				yourself ]
]

{ #category : #visiting }
WollokInterpreter >> visitAssignment: aNode [
	| value |
	value := aNode value acceptVisitor: self.

	{ '+=' -> '+'.
		'-=' -> '-'.
		'%=' -> '%'.
		'/=' -> '/'.
		'*=' -> '*' } asDictionary 
		at: aNode operation value ifPresent: [ :anEffectSelector | 
			value := self sendMessage: anEffectSelector to: (self currentContext resolve: aNode variable name value) withArguments: { value } ].
	
	self currentContext
		resolve: aNode variable name value
		andPut: value
		inInterpreter: self.
	
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
	^ self
		executeConstructorNode: aWollokConstructorCallNode
		inClass: (self resolve: aWollokConstructorCallNode classRef asWollokQualifiedName)
]

{ #category : #visiting }
WollokInterpreter >> visitIfExpression: aWollokIfExpressionNode [ 

	| conditionResult |
	conditionResult := aWollokIfExpressionNode condition acceptVisitor: self.

	^ conditionResult = self trueObject
		ifTrue: [ self visitMaybeClosureAsBlock: aWollokIfExpressionNode then ]
		ifFalse: [ aWollokIfExpressionNode else 
			ifNotNil: [ :elseExpression | self visitMaybeClosureAsBlock: elseExpression ] ]
]

{ #category : #'visiting - literals' }
WollokInterpreter >> visitListLiteral: aNode [ 

	| elements |
	
	elements := aNode elements collect: [ :e | e acceptVisitor: self ].
	^ self asWollokList: elements
]

{ #category : #visiting }
WollokInterpreter >> visitMaybeClosureAsBlock: aNode [
	
	(aNode isKindOf: WollokClosureNode)
		ifTrue:[ ^ self visitBlockExpression: aNode expression].
		
	^ aNode acceptVisitor: self
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

	| anAnonymousClass arguments |
	anAnonymousClass := self createAnonymousClassForObjectLiteral: aWollokObjectLiteralNode.
	arguments := WollokConstructorArguments 
			extractArguments: aWollokObjectLiteralNode superclassParameters
			using: self.
	^ anAnonymousClass instantiateUsing: self with: arguments
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
	
	^ self currentContext selfReceiver
]

{ #category : #'visiting - literals' }
WollokInterpreter >> visitSetLiteral: aNode [ 

	| elements |
	
	elements := aNode elements collect: [ :e | e acceptVisitor: self ] as:Set.
	^ self asWollokSet: elements
]

{ #category : #'visiting - literals' }
WollokInterpreter >> visitStringLiteral: aWollokStringLiteralNode [ 

	^ self asWollokString: (aWollokStringLiteralNode value value copyWithout: $").


]

{ #category : #visiting }
WollokInterpreter >> visitSuperInvocation: aWollokSuperInvocationNode [ 
	
	| receiver arguments |
	
	receiver := self currentContext receiver.
	arguments := aWollokSuperInvocationNode arguments collect: [:anArgument | anArgument acceptVisitor: self].

	^ self
		sendMessage: aWollokSuperInvocationNode methodNode name value
		to: receiver
		withArguments: arguments
		isSuperSend: true
]

{ #category : #visiting }
WollokInterpreter >> visitThrow: aNode [

	| aWollokException |
	aWollokException := aNode exception acceptVisitor: self.
	self throwException: aWollokException
]

{ #category : #visiting }
WollokInterpreter >> visitTry: aWollokTryNode [
	| tryContext result |
	tryContext := self currentContext.
	[[ result := self visitMaybeClosureAsBlock: aWollokTryNode expression ]
		on: WollokError
		do: [ :e |
			self popContextUntil: tryContext.
			result := self
				handleCatchException: e
				forTryNode: aWollokTryNode ]]
			ensure: [
				aWollokTryNode alwaysExpression ifNotNil: [
					self visitMaybeClosureAsBlock: aWollokTryNode alwaysExpression ] ].
		 ^ result
]

{ #category : #visiting }
WollokInterpreter >> visitUnaryOperation: aWollokUnaryOperationNode [ 

	| operator selector |
	
	operator := aWollokUnaryOperationNode operation value.
	
	selector := (Dictionary newFromPairs: {	
		'!'. 'negate'.
		'not'. 'negate'.
		'-'. 'invert'.
		'+'. 'plus' }) at: operator.

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
	aValue := aNode right 
		ifNil: [ self nullObject ]
		ifNotNil: [ :rightSide | rightSide acceptVisitor: self].

	self currentContext 
		declareVariable: aNode variable name value
		withValue: aValue.
		
	^ aValue
]

{ #category : #accessing }
WollokInterpreter >> voidObject [
	
	^ voidObject ifNil: [ voidObject := (self rootPackage resolve: 'wollok.lang.void') assignedValue ]

]
