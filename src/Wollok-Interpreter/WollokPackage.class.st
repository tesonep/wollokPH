Class {
	#name : #WollokPackage,
	#superclass : #Object,
	#instVars : [
		'name',
		'parent',
		'children',
		'fileNode'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #'instance creation' }
WollokPackage class >> named: aString parent: aPackage [
 
	^ self new 
		name: aString;
		parent: aPackage;
		yourself
]

{ #category : #accessing }
WollokPackage >> at: aString [ 
	
	^ children at: aString
]

{ #category : #accessing }
WollokPackage >> at: aString ifAbsent: aBlockClosure [ 
	
	^ children at: aString ifAbsent: aBlockClosure
]

{ #category : #accessing }
WollokPackage >> at: aString put: aValue [ 
	
	^ children at: aString put: aValue
]

{ #category : #accessing }
WollokPackage >> defaultImports [
	self shouldBeImplemented.
]

{ #category : #accessing }
WollokPackage >> ensurePackage: aString [ 
	
	^ children at: aString ifAbsentPut: [ self class named: aString parent: self ]
]

{ #category : #accessing }
WollokPackage >> fileNode: aWollokFileNode [ 
	
	fileNode:= aWollokFileNode 
]

{ #category : #accessing }
WollokPackage >> fullyQualifiedName [
	
	"If I have nil parent I'm root, so empty FQN"
	parent 
		ifNil: [ ^ WollokQualifiedName empty ].
	
	^ parent fullyQualifiedName copyWithSegment: name
]

{ #category : #accessing }
WollokPackage >> imports [
	
	^ self defaultImports , fileNode imports
]

{ #category : #initialization }
WollokPackage >> initialize [

	super initialize.
	children := Dictionary new
]

{ #category : #initialization }
WollokPackage >> initializeStateUsing: aWollokInterpreter [

	aWollokInterpreter pushCreationContext: self.
	children do: [ :aChildren | aChildren initializeStateUsing: aWollokInterpreter ].
	aWollokInterpreter popCreationContext.
]

{ #category : #accessing }
WollokPackage >> name: aString [ 
	
	name := aString
]

{ #category : #accessing }
WollokPackage >> parent: aPackage [ 

	parent := aPackage 
]

{ #category : #resolving }
WollokPackage >> resolve: aStringOrQualifiedName [ 
	
	| qualifiedName currentElement |
	
	qualifiedName := aStringOrQualifiedName asWollokQualifiedName.
	
	currentElement := children at: qualifiedName segments first 
		ifAbsent: [ ^ parent resolve: qualifiedName ].
	
	^ qualifiedName segments size = 1 
		ifTrue: [ currentElement ]
		ifFalse: [ currentElement resolve: qualifiedName copyWithoutFirst ]
]

{ #category : #loading }
WollokPackage >> visitClass: aWollokClassNode [ 

	| anObject |
	anObject := WollokClass fromAST: aWollokClassNode inPackage: self.
	self at: anObject name put: anObject
]

{ #category : #loading }
WollokPackage >> visitNamedObject: aWollokNamedObjectNode [ 

	| anObject |
	anObject := WollokNamedObject fromAST: aWollokNamedObjectNode inPackage: self.
	self at: anObject name put: anObject
]

{ #category : #loading }
WollokPackage >> visitVariableDeclaration: aWollokVariableDeclarationNode [ 

	| aVariable |
	aVariable := WollokPackageVariable fromAST: aWollokVariableDeclarationNode inPackage: self.
	self at: aVariable name put: aVariable	
]
