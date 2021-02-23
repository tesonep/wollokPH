Class {
	#name : #WollokTestSuite,
	#superclass : #WollokRuntimeElement,
	#instVars : [
		'tests',
		'fixture'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokTestSuite >> fixture [

	^ fixture
]

{ #category : #initialization }
WollokTestSuite >> initializeStateUsing: aWollokInterpreter [ 

	tests do: [ :e | e initializeStateUsing: aWollokInterpreter]
]

{ #category : #accessing }
WollokTestSuite >> name [
	
	^ ast name value value
]

{ #category : #accessing }
WollokTestSuite >> tests [
	^ tests
]

{ #category : #accessing }
WollokTestSuite >> tests: aCollection [ 

	tests := aCollection
]
