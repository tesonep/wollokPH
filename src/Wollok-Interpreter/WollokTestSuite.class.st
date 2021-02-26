Class {
	#name : #WollokTestSuite,
	#superclass : #WollokRuntimeElement,
	#instVars : [
		'tests',
		'fixture',
		'name'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #children }
WollokTestSuite >> addTest: aWollokTestCase [ 
	
	tests add: aWollokTestCase.
	aWollokTestCase parent: self
]

{ #category : #accessing }
WollokTestSuite >> fixture [

	^ fixture
]

{ #category : #accessing }
WollokTestSuite >> initialize [ 
	
	super initialize.
	tests := OrderedCollection new
]

{ #category : #accessing }
WollokTestSuite >> name [
	
	^ name ifNil: [ ast name value value]
]

{ #category : #accessing }
WollokTestSuite >> name: aValue [

	name := aValue
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
