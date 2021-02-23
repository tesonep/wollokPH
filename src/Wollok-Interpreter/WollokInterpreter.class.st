Class {
	#name : #WollokInterpreter,
	#superclass : #Object,
	#instVars : [
		'rootPackage',
		'contextStack',
		'trueObject',
		'voidObject'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #primitives }
WollokInterpreter >> activatePrimitiveMethod [
	self shouldBeImplemented.
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
	
	context := self pushContextForSelector: aSelector 
			receiver: aReceiver
			method: aMethod
			withArguments: arguments.
	
	
	aMethod native ifNil: [ 		
		aMethod expressionReturns 
			ifNotNil: [ :anExpression | context returnValue: (anExpression acceptVisitor: self)]
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
			booleanClass := self currentContext resolve: 'wollok.lang.Number'.
		  trueObject := WollokObject new 
				wollokClass: booleanClass;
				instanceVariables: {true};
				yourself ]
]

{ #category : #'visiting - literals' }
WollokInterpreter >> visitBooleanLiteral: aWollokBooleanLiteralNode [ 

	^ (aWollokBooleanLiteralNode value value = 'true') 
		ifTrue: [ self trueObject ]
		ifFalse: [ self falseObject ]
]

{ #category : #visiting }
WollokInterpreter >> visitMemberFeatureCall: aFeatureCallNode [ 

	| receiver arguments |
	
	receiver := aFeatureCallNode receiver acceptVisitor: self.
	arguments := aFeatureCallNode arguments collect: [:anArgument | anArgument acceptVisitor: self].
	
	^ self sendMessage: aFeatureCallNode feature value to: receiver withArguments: arguments
]

{ #category : #'visiting - literals' }
WollokInterpreter >> visitNumberLiteral: aWollokNumberLiteralNode [ 

	| aNumber numberClass |

	aNumber := Number readFrom: aWollokNumberLiteralNode value value.
	numberClass := self currentContext resolve: 'wollok.lang.Number'.

	^ WollokObject new 
		wollokClass: numberClass;
		instanceVariables: {aNumber};
		yourself
]

{ #category : #'visiting - literals' }
WollokInterpreter >> visitObjectLiteral: aWollokObjectLiteralNode [

	| anAnonymousClass |
	anAnonymousClass := self createAnonymousClasssForObjectLiteral: aWollokObjectLiteralNode.
	^ anAnonymousClass instantiateUsing: self.

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
WollokInterpreter >> visitVariable: aWollokVariableNode [ 

	^ (self currentContext resolve: aWollokVariableNode name value) assignedValue
]

{ #category : #accessing }
WollokInterpreter >> voidObject [
	
	^ voidObject ifNil: [ voidObject := self rootPackage resolve: 'wollok.lang.void' ]

]
