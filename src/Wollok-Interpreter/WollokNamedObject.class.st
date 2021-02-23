Class {
	#name : #WollokNamedObject,
	#superclass : #WollokRuntimeElement,
	#instVars : [
		'object'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokNamedObject >> assignedValue [
	
	^ object
]

{ #category : #initialization }
WollokNamedObject >> initializeStateUsing: aWollokInterpreter [ 
	
	object := (aWollokInterpreter createAnonymousClasssForNamedObjectLiteral: ast) 
		instantiateUsing: aWollokInterpreter.
	
]

{ #category : #accessing }
WollokNamedObject >> name [
	
	^ self ast name value
]
