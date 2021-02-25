Class {
	#name : #WollokPackageVariable,
	#superclass : #WollokRuntimeElement,
	#category : #'Wollok-Interpreter'
}

{ #category : #initialization }
WollokPackageVariable >> initializeStateUsing: anInterpreter [

	"Nothing to initialize"
]

{ #category : #accessing }
WollokPackageVariable >> name [
	
	^ self ast variable name value
]

{ #category : #initialization }
WollokPackageVariable >> resolveBindingsUsing: aWollokInterpreter [ 
	
	"Nothing to do yet"
]
