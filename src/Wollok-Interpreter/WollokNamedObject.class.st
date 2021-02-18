Class {
	#name : #WollokNamedObject,
	#superclass : #WollokElement,
	#instVars : [
		'object'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #initialization }
WollokNamedObject >> initializeStateUsing: aWollokInterpreter [ 
	
	object := (aWollokInterpreter createAnonymousClasssForNamedObjectLiteral: ast) 
		instantiateUsing: aWollokInterpreter.
	
]

{ #category : #accessing }
WollokNamedObject >> name [
	
	^ self ast name value
]
