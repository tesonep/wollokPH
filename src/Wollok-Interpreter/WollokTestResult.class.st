Class {
	#name : #WollokTestResult,
	#superclass : #Object,
	#instVars : [
		'success',
		'errors',
		'failures'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokTestResult >> errors [
	
	^ errors
]

{ #category : #accessing }
WollokTestResult >> failures [
	^ failures
]

{ #category : #initialization }
WollokTestResult >> initialize [ 
	
	super initialize.
	
	errors := OrderedCollection new.
	failures := OrderedCollection new.
	success := OrderedCollection new
]

{ #category : #recording }
WollokTestResult >> recordSuccessful: aWollokTestCase [ 

	success add: aWollokTestCase 
]
