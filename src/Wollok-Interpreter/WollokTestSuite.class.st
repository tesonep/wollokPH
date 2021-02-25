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

{ #category : #accessing }
WollokTestSuite >> name [
	
	^ ast name value value
]

{ #category : #initialization }
WollokTestSuite >> resolveBindingsUsing: aWollokInterpreter [ 

	tests do: [ :e | e resolveBindingsUsing: aWollokInterpreter]
]

{ #category : #accessing }
WollokTestSuite >> tests [
	^ tests
]

{ #category : #accessing }
WollokTestSuite >> tests: aCollection [ 

	tests := aCollection
]
