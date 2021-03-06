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
WollokObject >> = anotherObject [ 
	
	anotherObject species = self species
		ifFalse: [ ^ false ].
	anotherObject wollokClass = self wollokClass
			ifFalse: [ ^ false ].
	^ instanceVariables = anotherObject instanceVariables
]

{ #category : #accessing }
WollokObject >> asBoolean [
	
	self assert: ((instanceVariables at: 1) isKindOf: Boolean).
	^ instanceVariables at: 1
]

{ #category : #converting }
WollokObject >> asCollection [
	
	^ instanceVariables at: 1 
]

{ #category : #converting }
WollokObject >> asDate [

	^ Date
		newDay: (self instanceVariables at: 1) asNumber asInteger
		month: (self instanceVariables at: 2) asNumber asInteger
		year: (self instanceVariables at: 3) asNumber asInteger
]

{ #category : #converting }
WollokObject >> asInterval [
	
	^ (instanceVariables at: 1) asNumber asInteger
		to: (instanceVariables at: 2) asNumber asInteger
		by: (instanceVariables at: 3) asNumber asInteger
]

{ #category : #converting }
WollokObject >> asNumber [
	
	self assert: (instanceVariables size = 1).
	self assert: (instanceVariables at: 1) isNumber.
	
	^ instanceVariables at: 1
]

{ #category : #converting }
WollokObject >> asPharoString [
	
	^ instanceVariables at: 1
]

{ #category : #accessing }
WollokObject >> assignedValue [
	
	^ self
]

{ #category : #accessing }
WollokObject >> box: aValue [
	
	self instanceVariables at: 1 put: aValue.
	^ self
]

{ #category : #accessing }
WollokObject >> hash [

	^ instanceVariables hash
]

{ #category : #accessing }
WollokObject >> instanceVariables [
	^ instanceVariables
]

{ #category : #accessing }
WollokObject >> instanceVariables: aCollection [ 
	instanceVariables := aCollection
]

{ #category : #accessing }
WollokObject >> package [
	
	^ self wollokClass package
]

{ #category : #resolving }
WollokObject >> resolve: aString [ 
	
	^ wollokClass resolve: aString inInstance: self.
]

{ #category : #resolving }
WollokObject >> resolve: aName andPut: aValue inInterpreter: anInterpreter [ 

	^ wollokClass resolve: aName inInstance: self andPut: aValue inInterpreter: anInterpreter
]

{ #category : #accessing }
WollokObject >> selfReceiver [
	
	^ self
]

{ #category : #accessing }
WollokObject >> unbox [
	
	^ self instanceVariables at: 1
]

{ #category : #accessing }
WollokObject >> wollokClass [
	
	^ wollokClass
]

{ #category : #accessing }
WollokObject >> wollokClass: aWollokAnonymousClass [ 
	wollokClass := aWollokAnonymousClass
]

{ #category : #accessing }
WollokObject >> wollokIdentity [
	
	^ self identityHash
]
