Class {
	#name : #WollokObject,
	#superclass : #Object,
	#instVars : [
		'wollokClass',
		'instanceVariables'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokObject >> asBoolean [
	
	self assert: ((instanceVariables at: 1) isKindOf: Boolean).
	^ instanceVariables at: 1
]

{ #category : #converting }
WollokObject >> asNumber [
	
	self assert: (instanceVariables at: 1) isNumber.
	^ instanceVariables at: 1
]

{ #category : #accessing }
WollokObject >> assignedValue [
	
	^ self
]

{ #category : #accessing }
WollokObject >> instanceVariables: aCollection [ 
	instanceVariables := aCollection
]

{ #category : #resolving }
WollokObject >> resolve: aString [ 
	
	^ wollokClass resolve: aString inInstance: self.
]

{ #category : #accessing }
WollokObject >> wollokClass [
	
	^ wollokClass
]

{ #category : #accessing }
WollokObject >> wollokClass: aWollokAnonymousClass [ 
	wollokClass := aWollokAnonymousClass
]
