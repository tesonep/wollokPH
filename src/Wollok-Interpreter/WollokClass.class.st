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
	aWollokASTNode members do: [ :e | self addMethod: e ].
]

{ #category : #initialization }
WollokClass >> initializeStateUsing: aWollokInterpreter [ 
	
	| superclassName |
	
	nativeObject := aWollokInterpreter lookupNativeObjectFor: self.
	
	superclassName := ast superclass 
		ifNil: [ 'wollok.lang.Object' ] 
		ifNotNil: [ :aFQN | (aFQN identifiers collect: [ :e | e value ]) joinUsing: '.' ].
		
	superclass := aWollokInterpreter resolve: superclassName
]

{ #category : #'instance creation' }
WollokClass >> instantiateUsing: aWollokInterpreter [ 

	^ WollokObject new 
		wollokClass: self;
		instanceVariables: #();
		yourself
]

{ #category : #'native objects' }
WollokClass >> lookupNativeObjectForMethod: aString [ 

	^ self methods 
		detect: [ :aMethod | aMethod name value = aString ]
		ifFound: [ nativeObject ]
		ifNone: [ superclass ifNil: [ nil ] ifNotNil: [ superclass lookupNativeObjectForMethod: aString ] ]


]

{ #category : #methods }
WollokClass >> lookupSelector: aString [

	^ methods
		detect: [ :aMethod | aMethod name value = aString ]
		ifNone: [ self superclass
				ifNil: [ ^ nil ]
				ifNotNil: [ :aSuperclass | aSuperclass lookupSelector: aString ] ]
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
	
	^ self resolve: aString
]

{ #category : #accessing }
WollokClass >> superclass [
	^ superclass
]

{ #category : #accessing }
WollokClass >> superclass: aWollokClass [ 
	
	superclass := aWollokClass
]
