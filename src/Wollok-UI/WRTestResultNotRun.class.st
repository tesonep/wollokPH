Class {
	#name : #WRTestResultNotRun,
	#superclass : #WRTestResult,
	#category : #'Wollok-UI'
}

{ #category : #combining }
WRTestResultNotRun >> + aTestResult [
	
	^ aTestResult
]

{ #category : #accessing }
WRTestResultNotRun >> icon [

	^ self iconNamed: #testNotRun
]
