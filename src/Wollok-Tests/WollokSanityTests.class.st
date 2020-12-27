Class {
	#name : #WollokSanityTests,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'fileToTest'
	],
	#category : #'Wollok-Tests'
}

{ #category : #'building suites' }
WollokSanityTests class >> testParameters [ 

	| directory aMatrix |
	
	aMatrix := ParametrizedTestMatrix new.

	directory := '/Users/admin/dev/wollok/wollok-language/test/sanity' asFileReference.

	directory allChildren 
		select: [ :e | #( 'wlk' 'wtest' 'wpgm' ) includes: e extension ]
		thenDo: [ :e | aMatrix addCase: { #fileToTest -> e }]. 

	^ aMatrix
]

{ #category : #accessing }
WollokSanityTests >> fileToTest [
	^ fileToTest
]

{ #category : #accessing }
WollokSanityTests >> fileToTest: anObject [
	fileToTest := anObject
]

{ #category : #utils }
WollokSanityTests >> parseFile: aFileReference [ 
	
	^ WollokParser parseFile: fileToTest
]

{ #category : #tests }
WollokSanityTests >> testSmokeTests [

	self parseFile: fileToTest.
]
