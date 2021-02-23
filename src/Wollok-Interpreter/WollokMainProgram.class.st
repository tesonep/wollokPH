Class {
	#name : #WollokMainProgram,
	#superclass : #WollokRuntimeElement,
	#category : #'Wollok-Interpreter'
}

{ #category : #interpreting }
WollokMainProgram >> interpretUsing: aWollokInterpreter [ 
	self shouldBeImplemented.
]

{ #category : #accessing }
WollokMainProgram >> name [ 

	^ ast name value
]
