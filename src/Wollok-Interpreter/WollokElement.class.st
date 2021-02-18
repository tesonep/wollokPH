Class {
	#name : #WollokElement,
	#superclass : #Object,
	#instVars : [
		'ast',
		'package'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #'instance creation' }
WollokElement class >> fromAST: aWollokASTNode inPackage: aWollokPackage [ 
	
	^ self basicNew 
		initializeFromAST: aWollokASTNode inPackage: aWollokPackage;
		yourself
]

{ #category : #accessing }
WollokElement >> ast [
	^ ast
]

{ #category : #accessing }
WollokElement >> ast: anObject [
	ast := anObject
]

{ #category : #accessing }
WollokElement >> fullyQualifiedName [
	^ self package fullyQualifiedName copyWithSegment: self name
]

{ #category : #initialization }
WollokElement >> initializeFromAST: aWollokASTNode inPackage: aWollokPackage [
	
	self ast: aWollokASTNode.
	self package: aWollokPackage.
	self initialize.
	
]

{ #category : #accessing }
WollokElement >> package [
	^ package
]

{ #category : #accessing }
WollokElement >> package: anObject [
	package := anObject
]
