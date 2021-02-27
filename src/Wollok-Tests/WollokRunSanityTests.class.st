Class {
	#name : #WollokRunSanityTests,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'fileToTest'
	],
	#category : #'Wollok-Tests'
}

{ #category : #'building suites' }
WollokRunSanityTests class >> testParameters [ 

	| directory aMatrix |
	
	aMatrix := ParametrizedTestMatrix new.

	directory := WollokLoader sanityTestsRootDirectory.

	directory allChildren 
		select: [ :e | #( 'wtest') includes: e extension ]
		thenDo: [ :e | aMatrix addCase: { #fileToTest -> e }]. 

	^ aMatrix
]

{ #category : #accessing }
WollokRunSanityTests >> fileToTest [
	^ fileToTest
]

{ #category : #accessing }
WollokRunSanityTests >> fileToTest: anObject [
	fileToTest := anObject
]

{ #category : #tests }
WollokRunSanityTests >> testExecuteSanityTest [

	| interpreter fileNode testResult |
	
	interpreter := WollokInterpreter new.
	fileNode := WollokParser parseFile: fileToTest.
	
	testResult := interpreter interpretTests: fileNode.
	
	self assert: testResult errors size equals: 0.
	self assert: testResult failures size equals: 0.	

]
