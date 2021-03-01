Class {
	#name : #WollokMixin,
	#superclass : #WollokRuntimeElement,
	#category : #'Wollok-Interpreter'
}

{ #category : #initialization }
WollokMixin >> initializeStateUsing: aWollokInterpreter [ 
	
	"Nothing for now?"
]

{ #category : #accessing }
WollokMixin >> name [
	
	^ ast name value
]

{ #category : #initialization }
WollokMixin >> resolveBindingsUsing: aWollokInterpreter [ 
	
	"Nothing for now?"
]
