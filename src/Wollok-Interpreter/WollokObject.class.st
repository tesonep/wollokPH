Class {
	#name : #WollokObject,
	#superclass : #Object,
	#instVars : [
		'wollokClass'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokObject >> wollokClass [
	
	^ wollokClass
]

{ #category : #accessing }
WollokObject >> wollokClass: aWollokAnonymousClass [ 
	wollokClass := aWollokAnonymousClass
]
