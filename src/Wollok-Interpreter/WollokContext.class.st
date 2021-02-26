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
		'returnValue',
		'variables'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokContext >> arguments [
	^ arguments
]

{ #category : #accessing }
WollokContext >> arguments: value [ 

	arguments := value
]

{ #category : #accessing }
WollokContext >> beReturned [
	
	hasReturned := true
]

{ #category : #variables }
WollokContext >> declareVariable: aString withValue: aWollokObject [ 

	variables at: aString put: aWollokObject 
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
	variables := Dictionary new.
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
WollokContext >> package [
	
	^ self receiver package
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
	variables at: aString ifPresent: [ :aValue | ^ aValue ].	

	^ receiver resolve: aString
]

{ #category : #resolving }
WollokContext >> resolve: aName andPut: aValue [ 
	
	(arguments includesKey: aName) 
		ifTrue: [ ^ arguments at: aName put: aValue ].

	(variables includesKey: aName) 
		ifTrue: [ ^ variables at: aName put: aValue ].
		
	^ receiver resolve: aName andPut: aValue 
]

{ #category : #accessing }
WollokContext >> returnValue [
	^ returnValue
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
