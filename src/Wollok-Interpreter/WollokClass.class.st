Class {
	#name : #WollokClass,
	#superclass : #WollokRuntimeElement,
	#instVars : [
		'name',
		'superclass',
		'methods',
		'variables',
		'nativeObject'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #'default configuration' }
WollokClass class >> defaultSuperclassName [
	
	^ 'wollok.lang.Object'
]

{ #category : #methods }
WollokClass >> addMethod: aWollokMethodDeclarationNode [ 

	self haltIf: [ (aWollokMethodDeclarationNode isKindOf: WollokMethodDeclarationNode) not ].
	self methods add: aWollokMethodDeclarationNode
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

{ #category : #initialization }
WollokClass >> initializeFromAST: aWollokASTNode [
	
	self initializeFromAST: aWollokASTNode withName: aWollokASTNode name value
]

{ #category : #initialization }
WollokClass >> initializeFromAST: aWollokASTNode withName: aName [
	
	super initializeFromAST: aWollokASTNode.

	name := aName.
	methods := OrderedCollection new.
	variables := OrderedCollection new.

	aWollokASTNode variables do: [ :e | self addVariable: e ].	
	aWollokASTNode methods do: [ :e | self addMethod: e ].
]

{ #category : #initialization }
WollokClass >> initializeStateUsing: anInterpreter [ 

	"Nothing to initialize"
]

{ #category : #'instance creation' }
WollokClass >> instantiateUsing: aWollokInterpreter [ 

	^ self instantiateUsing: aWollokInterpreter with: Dictionary new
]

{ #category : #'instance creation' }
WollokClass >> instantiateUsing: aWollokInterpreter with: parameters [

	| anInstance allVariables |

	allVariables := self allVariables.

	anInstance := WollokObject new 
		wollokClass: self;
		instanceVariables: (Array new: allVariables size);
		yourself.
		
	self 
		runConstructorOn: anInstance 
		parameters: parameters
		allVariables: allVariables
		interpreter: aWollokInterpreter.
	
	^ anInstance
]

{ #category : #'private - lookup' }
WollokClass >> isMethod: aMethod forArguments: numberOfArguments [ 

	| mandatoryArguments varArgArguments |
	
	"If we have the exact number of argument nothing more is required"
	aMethod parameters size = numberOfArguments
		ifTrue: [ ^ true ].
		
	mandatoryArguments := aMethod parameters count: [ :e | e isVarArg isNil ].
	varArgArguments := aMethod parameters count: [ :e | e isVarArg isNotNil ].

	"If we have exactly the mandatory arguments it can go"	
	numberOfArguments = mandatoryArguments ifTrue: [ ^ true ].
	
	"If we have less than the mandatory arguments this is not the method"
	numberOfArguments < mandatoryArguments ifTrue: [ ^ false ].
	
	varArgArguments > 1 
		ifTrue: [ self error: 'I cannot handle more than one variadic arg' ].
	
	"If we have more than the mandatory arguments we should have a var arg"
	
	(numberOfArguments > mandatoryArguments and: [varArgArguments = 1]) 
		ifTrue: [ ^ true ].	
	
	^ false
]

{ #category : #properties }
WollokClass >> isProperty: aString [ 
	
	^ variables detect: [ :aVar | aVar variable name value = aString ]
			ifFound: [ :aVar | aVar property isNotNil ]
			ifNone: [ false ]
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

	^ methods
		detect: [ :aMethod | 
			aMethod name value = aString 
				and: [ self isMethod: aMethod forArguments: numberOfArguments ] ]
		ifNone: [ self superclass
				ifNil: [ ^ nil ]
				ifNotNil: [ :aSuperclass | 
					aSuperclass lookupSelector: aString usingArguments: numberOfArguments] ]
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

{ #category : #resolving }
WollokClass >> resolve: aString inInstance: aWollokObject [ 
	
	| anIndex |
	anIndex := self allVariables 	
		detectIndex: [ :aVariable | aVariable variable name value = aString ]
		ifNone: [ ^ self resolve: aString ].
		
	^ aWollokObject instanceVariables at: anIndex.
	
	
]

{ #category : #resolving }
WollokClass >> resolve: aName inInstance: anInstance andPut: aValue [ 
	
	| index |
	
	index := self allVariables 
		detectIndex: [ :aVariable | aVariable variable name value = aName ]
		ifNone: [ self notYetImplemented ].
	
	anInstance instanceVariables at: index put: aValue.
	^ aValue
]

{ #category : #initialization }
WollokClass >> resolveBindingsUsing: aWollokInterpreter [ 
	
	| superclassName |
	
	nativeObject := aWollokInterpreter lookupNativeObjectFor: self.
	
	self fullyQualifiedName = 'wollok.lang.Object' asWollokQualifiedName 
		ifTrue: [ ^ self ].
	
	superclassName := ast superclass 
			ifNil: [ 'wollok.lang.Object' ] 
			ifNotNil: [ :aFQN | aFQN asWollokQualifiedName ].
		
	superclass := aWollokInterpreter resolve: superclassName
]

{ #category : #'private - intance creation' }
WollokClass >> runConstructorOn: anInstance parameters: parameters allVariables: allVariables interpreter: anInterpreter [

	anInterpreter pushInitializationContextFor: self.

	allVariables withIndexDo: [ :aVariable :anIndex | 
		parameters at: aVariable variable name value 
			ifPresent: [:aValue | anInstance instanceVariables at: anIndex put: aValue ]].

	allVariables withIndexDo: [ :aVariable :anIndex | 
		(anInstance instanceVariables at: anIndex) 
			ifNil: [ 
				anInstance instanceVariables at: anIndex put: (
					aVariable right 
						ifNil: [ anInterpreter nullObject ] 
						ifNotNil:[ :anExpression | anExpression acceptVisitor: anInterpreter ])  ]].

	anInterpreter sendMessage: 'initialize' to: anInstance  withArguments: #().
	
	anInterpreter popContext
]

{ #category : #accessing }
WollokClass >> superclass [
	^ superclass
]

{ #category : #accessing }
WollokClass >> superclass: aWollokClass [ 
	
	superclass := aWollokClass
]
