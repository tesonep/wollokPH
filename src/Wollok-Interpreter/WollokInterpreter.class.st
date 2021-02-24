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

{ #category : #primitives }
WollokInterpreter >> activatePrimitiveMethod [
	
	| context nativeObject |
	context := self currentContext.

	context method native 
		ifNil: [self error: 'The current method is not a native one'].
	
	nativeObject := context receiver wollokClass lookupNativeObjectForMethod: context method name value.
	
	nativeObject ifNil: [ self error: 'Could not find the native object for corresponding native method' ].
	
	nativeObject activateNativeContext: context.
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

{ #category : #'anonymous classes' }
WollokInterpreter >> createAnonymousClasssForObjectLiteral: aWollokObjectLiteralNode [ 

	| superclassName superclass |
	
	superclassName := aWollokObjectLiteralNode superclass ifNil: [WollokClass defaultSuperclassName].

	superclass := self currentContext resolve: superclassName.

	^ WollokClass new 
		name: '_AnonymousClass';
		ast: aWollokObjectLiteralNode;
		parent: self currentContext;
		superclass: superclass;
		yourself
]

{ #category : #'context creation' }
WollokInterpreter >> currentContext [

	contextStack ifEmpty: [ ^ nil ].

	^ contextStack top
]

{ #category : #accessing }
WollokInterpreter >> falseObject [
	
	| booleanClass |
	
	^ falseObject ifNil: [ 
			booleanClass := self currentContext resolve: 'wollok.lang.Boolean'.
		  falseObject := WollokObject new 
				wollokClass: booleanClass;
				instanceVariables: {false};
				yourself ]
]

{ #category : #initialization }
WollokInterpreter >> initialize [

	super initialize.
	contextStack := Stack new
]

{ #category : #interpreting }
WollokInterpreter >> interpretProgram: aWollokFileNode [ 

	| lastValue |
	
	rootPackage := WollokLoader new
		interpreter: self;
		rootFile: aWollokFileNode;
		load.

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

{ #category : #interpreting }
WollokInterpreter >> interpretSuite: aWollokTestSuite storingResultsIn: aWollokTestResult [ 

	aWollokTestSuite tests do: [ :aTest |
		aWollokTestSuite fixture ifNotNil: [:aFixture | self interpretFixture: aFixture ].
		self interpretTest: aTest storingResultsIn: aWollokTestResult.
		self resetInterpreterState ]
]

{ #category : #interpreting }
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

{ #category : #interpreting }
WollokInterpreter >> interpretTests: aWollokFileNode [ 

	| lastValue wollokTestResult |
	
	rootPackage := WollokLoader new
		interpreter: self;
		rootFile: aWollokFileNode;
		load.

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

{ #category : #'visiting - literals' }
WollokInterpreter >> newWollokNumberWith: aNumber [ 

	| numberClass |

	numberClass := self currentContext resolve: 'wollok.lang.Number'.

	^ WollokObject new 
		wollokClass: numberClass;
		instanceVariables: {aNumber};
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
WollokInterpreter >> pushContext: aCreationContext [
 
	contextStack push: aCreationContext
]

{ #category : #'context creation' }
WollokInterpreter >> pushContextForSelector: aSelector receiver: aReceiver method: aMethod withArguments: aCollection [ 
	
	| context |
	
	context := WollokContext new
		sender: self currentContext;
		method: aMethod;
		receiver: aReceiver;
		selector: aSelector;
		arguments: aCollection;
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

	| aMethod context |
	aMethod := aReceiver wollokClass lookupSelector: aSelector.
	
	aMethod ifNil: [ self error: 'MNU' ].
	
	context := self pushContextForSelector: aSelector 
			receiver: aReceiver
			method: aMethod
			withArguments: arguments.
	
	
	aMethod native ifNil: [ 		
		aMethod expressionReturns 
			ifNotNil: [ context returnValue: (aMethod expression acceptVisitor: self)]
			ifNil:[ 
				aMethod expression expressions do: [ :aStatement | 
					context hasReturned ifFalse: [ aStatement acceptVisitor: self ]]]]
		ifNotNil: [ self activatePrimitiveMethod ].
			
	self popContext.
	
	^ context returnValue.
]

{ #category : #accessing }
WollokInterpreter >> trueObject [
	
	| booleanClass |
	
	^ trueObject ifNil: [ 
			booleanClass := self currentContext resolve: 'wollok.lang.Boolean'.
		  trueObject := WollokObject new 
				wollokClass: booleanClass;
				instanceVariables: {true};
				yourself ]
]

{ #category : #visiting }
WollokInterpreter >> visitBinaryOperation: aWollokBinaryOperationNode [ 

	| left right |

	left := aWollokBinaryOperationNode leftOperand acceptVisitor: self.
	right := aWollokBinaryOperationNode rightOperand acceptVisitor: self.	
	
	^ self 
		sendMessage: aWollokBinaryOperationNode operation value
		to: left 
		withArguments: { right }
]

{ #category : #'visiting - literals' }
WollokInterpreter >> visitBooleanLiteral: aWollokBooleanLiteralNode [ 

	^ (aWollokBooleanLiteralNode value value = 'true') 
		ifTrue: [ self trueObject ]
		ifFalse: [ self falseObject ]
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
WollokInterpreter >> visitIfExpression: aWollokIfExpressionNode [ 

	| conditionResult |
	conditionResult := aWollokIfExpressionNode condition acceptVisitor: self.

	^ conditionResult asBoolean
		ifTrue: [ aWollokIfExpressionNode then acceptVisitor: self ]
		ifFalse: [ aWollokIfExpressionNode else 
			ifNotNil: [ :elseExpression | elseExpression acceptVisitor: self ] ]
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

	^ self newWollokNumberWith: aNumber
]

{ #category : #'visiting - literals' }
WollokInterpreter >> visitObjectLiteral: aWollokObjectLiteralNode [

	| anAnonymousClass |
	anAnonymousClass := self createAnonymousClasssForObjectLiteral: aWollokObjectLiteralNode.
	^ anAnonymousClass instantiateUsing: self.

]

{ #category : #visiting }
WollokInterpreter >> visitParenthesizedExpression: aWollokParenthesizedExpressionNode [ 
	
	^ aWollokParenthesizedExpressionNode expression acceptVisitor: self
]

{ #category : #visiting }
WollokInterpreter >> visitSelf: aWollokSelfNode [ 
	
	^ self currentContext receiver
]

{ #category : #'visiting - literals' }
WollokInterpreter >> visitStringLiteral: aWollokStringLiteralNode [ 

	| stringClass |

	stringClass := self currentContext resolve: 'wollok.lang.String'.

	^ WollokObject new 
		wollokClass: stringClass;
		instanceVariables: {aWollokStringLiteralNode value value copyWithout: $"};
		yourself	
]

{ #category : #visiting }
WollokInterpreter >> visitUnaryOperation: aWollokUnaryOperationNode [ 

	| operator |
	operator := aWollokUnaryOperationNode operation value.
	
	operator = '!' ifFalse: [ self halt ].

	^ self 
		sendMessage: 'negate' 
		to: (aWollokUnaryOperationNode rightOperand acceptVisitor: self) 
		withArguments: #().
]

{ #category : #visiting }
WollokInterpreter >> visitVariable: aWollokVariableNode [ 

	^ (self currentContext resolve: aWollokVariableNode name value) assignedValue
]

{ #category : #accessing }
WollokInterpreter >> voidObject [
	
	^ voidObject ifNil: [ voidObject := (self rootPackage resolve: 'wollok.lang.void') assignedValue ]

]
