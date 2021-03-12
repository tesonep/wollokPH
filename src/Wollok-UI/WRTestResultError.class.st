Class {
	#name : #WRTestResultError,
	#superclass : #WRTestResult,
	#instVars : [
		'reason'
	],
	#category : #'Wollok-UI'
}

{ #category : #accessing }
WRTestResultError >> icon [

	^ self iconNamed: #testRed
]

{ #category : #accessing }
WRTestResultError >> reason: aString [ 
	
	reason := aString
]
