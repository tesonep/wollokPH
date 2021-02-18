Class {
	#name : #AbstractWollokSmokeTests,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'fileToTest'
	],
	#category : #'Wollok-Tests'
}

{ #category : #private }
AbstractWollokSmokeTests class >> isAbstract [

	^ self = AbstractWollokSmokeTests 
]

{ #category : #accessing }
AbstractWollokSmokeTests >> fileToTest [
	^ fileToTest
]

{ #category : #accessing }
AbstractWollokSmokeTests >> fileToTest: anObject [
	fileToTest := anObject
]

{ #category : #utils }
AbstractWollokSmokeTests >> parseFile: aFileReference [ 
	
	^ WollokParser parseFile: aFileReference
]

{ #category : #tests }
AbstractWollokSmokeTests >> testSmokeTests [

	self parseFile: fileToTest.
]
