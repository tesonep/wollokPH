Class {
	#name : #WollokPackage,
	#superclass : #Object,
	#instVars : [
		'name',
		'parent',
		'children',
		'fileNode',
		'imports',
		'main',
		'suites',
		'defaultSuite'
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

{ #category : #children }
WollokPackage >> add: anElement [

	^ self at: anElement name put: anElement
]

{ #category : #children }
WollokPackage >> addSuite: aWollokTestSuite [ 

	self add: aWollokTestSuite.
	suites add: aWollokTestSuite.
	aWollokTestSuite parent: self
]

{ #category : #children }
WollokPackage >> at: aString [ 
	
	^ children at: aString
]

{ #category : #children }
WollokPackage >> at: aString ifAbsent: aBlockClosure [ 
	
	^ children at: aString ifAbsent: aBlockClosure
]

{ #category : #children }
WollokPackage >> at: aString ifAbsentPut: aBlockClosure [ 
	
	^ children at: aString ifAbsentPut: [ | aNewValue | 
			aNewValue := aBlockClosure value.
			aNewValue parent: self.
			aNewValue]
]

{ #category : #accessing }
WollokPackage >> at: aString put: aValue [ 
	
	aValue parent: self.
	^ children at: aString put: aValue
]

{ #category : #accessing }
WollokPackage >> children [
	^ children
]

{ #category : #accessing }
WollokPackage >> defaultSuite [
	
	^ defaultSuite ifNil: [ 
		defaultSuite := WollokTestSuite new 
			name: 'defaultTestSuite';
			yourself.
		self at: defaultSuite name put: defaultSuite  ]
]

{ #category : #resolving }
WollokPackage >> doResolve: qualifiedName [ 
	
	| currentElement |
	
	currentElement := children at: qualifiedName segments first 
		ifAbsent: [ 
			parent ifNil: [ ^ nil ].
			^ parent doResolve: qualifiedName ].
	
	^ qualifiedName segments size = 1 
		ifTrue: [ currentElement ]
		ifFalse: [ currentElement doResolve: qualifiedName copyWithoutFirst ]
]

{ #category : #accessing }
WollokPackage >> fileNode [

	^ fileNode
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
	^ imports
]

{ #category : #accessing }
WollokPackage >> imports: anObject [
	imports := anObject
]

{ #category : #initialization }
WollokPackage >> initialize [

	super initialize.
	
	children := Dictionary new.
	suites := OrderedCollection new.
]

{ #category : #'state initialization' }
WollokPackage >> initializeStateUsing: anInterpreter [ 
	
	anInterpreter pushInitializationContextFor: self.
	children do: [ :aChild | aChild initializeStateUsing: anInterpreter ].
	anInterpreter popContext
]

{ #category : #accessing }
WollokPackage >> main [
	
	^ main
]

{ #category : #accessing }
WollokPackage >> main: anObject [
	
	main := anObject
]

{ #category : #accessing }
WollokPackage >> name [
	^ name
]

{ #category : #accessing }
WollokPackage >> name: aString [ 
	
	name := aString
]

{ #category : #accessing }
WollokPackage >> package [

	^ self
	
]

{ #category : #accessing }
WollokPackage >> parent: aPackage [ 

	parent := aPackage 
]

{ #category : #state }
WollokPackage >> resetState [
	
	children do: [ :e | e resetState ]
]

{ #category : #resolving }
WollokPackage >> resolve: aStringOrQualifiedName [ 
	
	| qualifiedName |
	
	qualifiedName := aStringOrQualifiedName asWollokQualifiedName.
	
	(self doResolve: qualifiedName) ifNotNil: [ :aValue | ^ aValue ].
	
	self imports do: [ :anImport |
		(self doResolve: anImport , qualifiedName) ifNotNil: [:aValue | ^aValue]].
	
	self error: 'Could not resolve ' , qualifiedName printString
]

{ #category : #initialization }
WollokPackage >> resolveBindingsUsing: aWollokInterpreter [

	aWollokInterpreter pushInitializationContextFor: self.

	children do: [ :aChildren | 
		aChildren resolveBindingsUsing: aWollokInterpreter ].
	
	aWollokInterpreter popContext.
]

{ #category : #accessing }
WollokPackage >> suites [
	
	^ suites 
]
