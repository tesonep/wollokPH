Class {
	#name : #WollokContext,
	#superclass : #Object,
	#instVars : [
		'sender',
		'receiver',
		'selector',
		'method',
		'arguments',
		'hasReturned',
		'returnValue'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokContext >> arguments: value [ 

	| keys |
	keys := method parameters collect: [ :e | e parameter value ].
	arguments := Dictionary newFromKeys: keys andValues: value
]

{ #category : #testing }
WollokContext >> hasReturned [
	
	^ hasReturned 
]

{ #category : #accessing }
WollokContext >> initialize [

	super initialize.

	hasReturned := false.
	arguments := Dictionary new.
]

{ #category : #accessing }
WollokContext >> method [
	^ method
]

{ #category : #accessing }
WollokContext >> method: aWollokMethod [ 

	method := aWollokMethod
	
]

{ #category : #accessing }
WollokContext >> receiver [
	^ receiver
]

{ #category : #accessing }
WollokContext >> receiver: anObject [ 
	receiver := anObject
]

{ #category : #resolving }
WollokContext >> resolve: aString [ 
	
	arguments at: aString ifPresent: [ :aValue | ^ aValue ].	
	^ receiver resolve: aString
]

{ #category : #accessing }
WollokContext >> returnValue: aWollokObject [ 
	
	returnValue := aWollokObject 
]

{ #category : #accessing }
WollokContext >> selector: aString [ 
	selector := aString
]

{ #category : #accessing }
WollokContext >> sender: anUndefinedObject [ 
	sender := anUndefinedObject
]
