Class {
	#name : #WollokClass,
	#superclass : #WollokRuntimeElement,
	#instVars : [
		'name',
		'superclass',
		'methods',
		'variables',
		'nativeObject',
		'constructors'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #'default configuration' }
WollokClass class >> defaultSuperclassName [
	
	^ 'wollok.lang.Object'
]

{ #category : #'private - intance creation' }
WollokClass >> activateConstructorOn: anObject withArguments: arguments onInterpreter: anInterpreter [
	
	| matchingConstructor |	
	matchingConstructor := self
		lookupConstructorWithArguments: arguments positionalArguments size
		onInterpreter: anInterpreter.
	matchingConstructor ifNotNil: [ 
		anInterpreter
			activateMethod: matchingConstructor
			withReceiver: anObject
			withArguments: arguments positionalArguments ]
]

{ #category : #constructors }
WollokClass >> addConstructor: aWollokConstructorNode [ 

	aWollokConstructorNode methodClass: self.
	self constructors add: aWollokConstructorNode
]

{ #category : #methods }
WollokClass >> addMethod: aWollokMethod [

	aWollokMethod methodClass: self.
	self methods add: aWollokMethod
]

{ #category : #members }
WollokClass >> addVariable: aWollokVariableDeclarationNode [ 

	variables add: aWollokVariableDeclarationNode
]

{ #category : #accessing }
WollokClass >> allVariables [
	
	| inherited |
	
	inherited := superclass ifNil: [ #() ] ifNotNil: [ superclass allVariables ].
	^ inherited , variables
]

{ #category : #'instance creation' }
WollokClass >> basicInstantiate: aWollokInterpreter [

	^ WollokObject new 
		wollokClass: self;
		instanceVariables: (Array new: self allVariables size);
		yourself.
		

]

{ #category : #accessing }
WollokClass >> constructors [
	
	^ constructors
]

{ #category : #'private - instance creation' }
WollokClass >> initialize: allVariables into: anInstance fromNamedArguments: arguments [ 

	allVariables withIndexDo: [ :aVariable :anIndex | 
		arguments namedArguments at: aVariable variable name value 
			ifPresent: [:aValue | anInstance instanceVariables at: anIndex put: aValue ]].

]

{ #category : #initialization }
WollokClass >> initializeFromAST: aWollokASTNode [
	
	self initializeFromAST: aWollokASTNode withName: aWollokASTNode name value value
]

{ #category : #initialization }
WollokClass >> initializeFromAST: aWollokASTNode withName: aName [
	
	super initializeFromAST: aWollokASTNode.

	name := aName.
	methods := OrderedCollection new.
	variables := OrderedCollection new.
	constructors := OrderedCollection new.

	aWollokASTNode variables do: [ :e | self addVariable: e ].	
	aWollokASTNode methods do: [ :e | self addMethod: (WollokMethod fromAST: e) ].
	aWollokASTNode constructors do: [ :e | self addConstructor: (WollokConstructor fromAST: e) ].
]

{ #category : #initialization }
WollokClass >> initializeStateUsing: anInterpreter [ 

	"Nothing to initialize"
]

{ #category : #'instance creation' }
WollokClass >> instantiateUsing: aWollokInterpreter [ 

	^ self instantiateUsing: aWollokInterpreter with: WollokConstructorArguments empty
]

{ #category : #'instance creation' }
WollokClass >> instantiateUsing: aWollokInterpreter with: parameters [

	| anInstance |

	anInstance := self basicInstantiate: aWollokInterpreter.
		
	self 
		runConstructorOn: anInstance 
		arguments: parameters
		allVariables: self allVariables
		interpreter: aWollokInterpreter.
	
	^ anInstance
]

{ #category : #'private - lookup' }
WollokClass >> isMethod: aMethod forArguments: numberOfArguments [ 

	^ aMethod hasNumberOfArguments: numberOfArguments
]

{ #category : #properties }
WollokClass >> isProperty: aString [ 
	
	^ variables detect: [ :aVar | aVar variable name value = aString ]
			ifFound: [ :aVar | aVar property isNotNil ]
			ifNone: [ 
				self superclass
					ifNil: [ ^ false ]
					ifNotNil: [ :aSuperclass | aSuperclass isProperty: aString ]]
]

{ #category : #methods }
WollokClass >> lookupConstructorWithArguments: numberOfArguments onInterpreter: anInterpreter [

	self constructors
		detect: [ :constructor | constructor hasNumberOfArguments: numberOfArguments ]
		ifFound: [ :constructor | ^ constructor ].
	
	self superclass constructors
		detect: [ :constructor | constructor hasNumberOfArguments: numberOfArguments ]
		ifFound: [ :constructor | ^ constructor ].
	
	(self constructors notEmpty or: [ self superclass constructors notEmpty ]) ifTrue: [
		anInterpreter throwExceptionWithMessage: 'No matching constructor' ].
	
	^ nil
]

{ #category : #'native objects' }
WollokClass >> lookupNativeObjectForMethod: aString [ 

	^ self methods 
		detect: [ :aMethod | aMethod name value = aString ]
		ifFound: [ nativeObject ]
		ifNone: [ superclass ifNil: [ nil ] ifNotNil: [ superclass lookupNativeObjectForMethod: aString ] ]


]

{ #category : #methods }
WollokClass >> lookupSelector: aString usingArguments: numberOfArguments [

	methods
		detect: [ :aMethod |
			aMethod name = aString 
			and: [ self isMethod: aMethod forArguments: numberOfArguments ] ]
		ifFound: [ :aMethod | ^ aMethod ].
			
	^ self superclass
		ifNil: [ nil ]
		ifNotNil: [ :aSuperclass | 
			aSuperclass lookupSelector: aString usingArguments: numberOfArguments]
]

{ #category : #accessing }
WollokClass >> methods [
	
	^ methods
]

{ #category : #accessing }
WollokClass >> name [
	
	^ name
]

{ #category : #accessing }
WollokClass >> name: aValue [
	
	name := aValue
]

{ #category : #accessing }
WollokClass >> nativeObject [
	^ nativeObject
]

{ #category : #accessing }
WollokClass >> nativeObject: anObject [
	nativeObject := anObject
]

{ #category : #printing }
WollokClass >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	aStream print: self fullyQualifiedName asString.
	aStream nextPut: $).
]

{ #category : #state }
WollokClass >> resetState [

	
]

{ #category : #resolving }
WollokClass >> resolve: aString inInstance: aWollokObject [ 
	
	| anIndex |
	anIndex := self allVariables 	
		detectIndex: [ :aVariable | aVariable variable name value = aString ]
		ifNone: [ ^ self resolve: aString ].
		
	^ aWollokObject instanceVariables at: anIndex.
	
	
]

{ #category : #resolving }
WollokClass >> resolve: aName inInstance: anInstance andPut: aValue inInterpreter: anInterpreter [
	
	| allVariables variable |
	allVariables := self allVariables.
	variable := allVariables 
		detect: [ :aVariable | aVariable variable name value = aName ]
		ifNone: [ self notYetImplemented ].

	"Fixtures can modify the const variables"
	(variable constToken isNotNil and: [
		anInterpreter currentContext isFixture not
			and: [ anInterpreter currentContext method isConstructor not ]]) ifTrue: [  
		anInterpreter throwExceptionWithMessage: 'Invalid Assignment in const variable' ].

	anInstance instanceVariables at: (allVariables indexOf: variable) put: aValue.
	^ aValue
]

{ #category : #initialization }
WollokClass >> resolveBindingsUsing: aWollokInterpreter [ 
	
	| superclassName |
	
	nativeObject := aWollokInterpreter lookupNativeObjectFor: self.
	
	self fullyQualifiedName = 'wollok.lang.Object' asWollokQualifiedName 
		ifTrue: [ ^ self ].
	
	superclassName := self superclassName
			ifNil: [ 'wollok.lang.Object' ] 
			ifNotNil: [ :aFQN | aFQN asWollokQualifiedName ].
		
	superclass := aWollokInterpreter resolve: superclassName
]

{ #category : #'private - intance creation' }
WollokClass >> runConstructorOn: anInstance arguments: arguments allVariables: allVariables interpreter: anInterpreter [

	anInterpreter pushInitializationContextFor: anInstance.

	self initialize: allVariables into: anInstance fromNamedArguments: arguments.

	allVariables withIndexDo: [ :aVariable :anIndex | 
		(anInstance instanceVariables at: anIndex) 
			ifNil: [ 
				anInstance instanceVariables at: anIndex put: (
					aVariable right 
						ifNil: [ anInterpreter nullObject ] 
						ifNotNil:[ :anExpression | anExpression acceptVisitor: anInterpreter ])  ]].

	anInterpreter sendMessage: 'initialize' to: anInstance  withArguments: #().

	self
		activateConstructorOn: anInstance
		withArguments: arguments
		onInterpreter: anInterpreter.
	
	anInterpreter popContext.
]

{ #category : #accessing }
WollokClass >> superclass [
	^ superclass
]

{ #category : #accessing }
WollokClass >> superclass: aWollokClass [ 

	superclass := aWollokClass
]

{ #category : #accessing }
WollokClass >> superclassName [
	
	^ ast superclass
]
