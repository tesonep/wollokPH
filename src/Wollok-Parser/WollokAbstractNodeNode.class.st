Class {
	#name : #WollokAbstractNodeNode,
	#superclass : #SmaCCParseNode,
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokAbstractNodeNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitAbstractNode: self
]
