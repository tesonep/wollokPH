Class {
	#name : #WollokClass,
	#superclass : #WollokRuntimeElement,
	#instVars : [
		'name',
		'superclass',
		'methods',
		'variables'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #'default configuration' }
WollokClass class >> defaultSuperclassName [
	
	^ 'wollok.lang.Object'
]

{ #category : #methods }
WollokClass >> addMethod: aWollokMethodDeclarationNode [ 

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
	
	aWollokASTNode members do: [ :e | self addMethod: e ].
]

{ #category : #initialization }
WollokClass >> initializeStateUsing: aWollokInterpreter [ 
	
	"Nothing to initialize here"
]

{ #category : #'instance creation' }
WollokClass >> instantiateUsing: aWollokInterpreter [ 

	^ WollokObject new 
		wollokClass: self;
		instanceVariables: #();
		yourself
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
