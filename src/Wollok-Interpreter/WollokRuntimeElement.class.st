Class {
	#name : #WollokRuntimeElement,
	#superclass : #Object,
	#instVars : [
		'ast',
		'parent'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #'instance creation' }
WollokRuntimeElement class >> fromAST: aWollokASTNode [
	
	^ self basicNew 
		initializeFromAST: aWollokASTNode;
		yourself
]

{ #category : #accessing }
WollokRuntimeElement >> ast [
	^ ast
]

{ #category : #accessing }
WollokRuntimeElement >> ast: anObject [
	ast := anObject
]

{ #category : #accessing }
WollokRuntimeElement >> fullyQualifiedName [

	^ self package fullyQualifiedName copyWithSegment: self name
]

{ #category : #initialization }
WollokRuntimeElement >> initializeFromAST: aWollokASTNode [
	
	self ast: aWollokASTNode.
	self initialize.
	
]

{ #category : #testing }
WollokRuntimeElement >> isConstructor [
	
	^ false
]

{ #category : #accessing }
WollokRuntimeElement >> package [
	
	self parent
		ifNil: [ ^ WollokPackage named: #_UndefinedPackage parent: nil ].
	^ self parent package
]

{ #category : #accessing }
WollokRuntimeElement >> parent [
	^ parent
]

{ #category : #accessing }
WollokRuntimeElement >> parent: anObject [
1haltIf: [ (self isKindOf: WollokClass) and: [ (anObject isKindOf: WollokPackage) not ] ].
	parent := anObject
]

{ #category : #resolving }
WollokRuntimeElement >> resolve: aName [ 
	
	^ self parent resolve: aName
]

{ #category : #accessing }
WollokRuntimeElement >> source [
	
	^ ast source
]

{ #category : #accessing }
WollokRuntimeElement >> sourceInterval [
	
	^ ast sourceInterval
]
