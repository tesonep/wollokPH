Class {
	#name : #WollokQualifiedNameNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'identifiers',
		'periodTokens'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokQualifiedNameNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitQualifiedName: self
]

{ #category : #generated }
WollokQualifiedNameNode >> compositeTokenVariables [
	^ #(#identifiers #periodTokens)
]

{ #category : #generated }
WollokQualifiedNameNode >> identifiers [
	^ identifiers
]

{ #category : #generated }
WollokQualifiedNameNode >> identifiers: anOrderedCollection [
	identifiers := anOrderedCollection
]

{ #category : #'generated-initialize-release' }
WollokQualifiedNameNode >> initialize [
	super initialize.
	identifiers := OrderedCollection new: 2.
	periodTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokQualifiedNameNode >> periodTokens [
	^ periodTokens
]

{ #category : #generated }
WollokQualifiedNameNode >> periodTokens: anOrderedCollection [
	periodTokens := anOrderedCollection
]
