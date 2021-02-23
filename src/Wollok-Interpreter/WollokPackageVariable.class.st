Class {
	#name : #WollokPackageVariable,
	#superclass : #WollokRuntimeElement,
	#category : #'Wollok-Interpreter'
}

{ #category : #initialization }
WollokPackageVariable >> initializeStateUsing: aWollokInterpreter [ 
	
	"Nothing to do yet"
]

{ #category : #accessing }
WollokPackageVariable >> name [
	
	^ self ast variable name value
]
