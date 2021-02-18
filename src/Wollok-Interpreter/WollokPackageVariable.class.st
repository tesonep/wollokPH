Class {
	#name : #WollokPackageVariable,
	#superclass : #WollokElement,
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
