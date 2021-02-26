Class {
	#name : #WollokPackageVariable,
	#superclass : #WollokRuntimeElement,
	#instVars : [
		'value'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokPackageVariable >> assignedValue [
	
	^ value
]

{ #category : #initialization }
WollokPackageVariable >> initializeStateUsing: anInterpreter [

	value := ast right acceptVisitor: anInterpreter
]

{ #category : #accessing }
WollokPackageVariable >> name [
	
	^ self ast variable name value
]

{ #category : #state }
WollokPackageVariable >> resetState [
	
	value := nil
]

{ #category : #initialization }
WollokPackageVariable >> resolveBindingsUsing: aWollokInterpreter [ 
	
	"Nothing to do yet"
]
