Class {
	#name : #WollokNamedObject,
	#superclass : #WollokRuntimeElement,
	#instVars : [
		'object',
		'wollokClass'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokNamedObject >> assignedValue [
	
	^ object
]

{ #category : #initialization }
WollokNamedObject >> initializeStateUsing: anInterpreter [ 
	
	object := wollokClass instantiateUsing: anInterpreter
]

{ #category : #accessing }
WollokNamedObject >> name [
	
	^ self ast name value
]

{ #category : #initialization }
WollokNamedObject >> resolveBindingsUsing: aWollokInterpreter [ 
	
	wollokClass := aWollokInterpreter createAnonymousClasssForNamedObjectLiteral: ast
]
