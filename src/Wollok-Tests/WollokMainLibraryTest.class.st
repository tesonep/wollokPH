Class {
	#name : #WollokMainLibraryTest,
	#superclass : #TestCase,
	#instVars : [
		'interpreter'
	],
	#category : #'Wollok-Tests'
}

{ #category : #tests }
WollokMainLibraryTest >> setUp [

	interpreter := WollokInterpreter new.

]

{ #category : #tests }
WollokMainLibraryTest >> testParseWollokLangHasObjectClass [

	interpreter initializeWithMainLibrary.
		
	self assert: (interpreter resolve: 'wollok.lang.Object') isNotNil. 

	
]

{ #category : #tests }
WollokMainLibraryTest >> testParseWollokLangHasWollokLangPackage [

	interpreter initializeWithMainLibrary.

	self assert: (interpreter resolve: 'wollok.lang') isNotNil. 

	
]

{ #category : #tests }
WollokMainLibraryTest >> testParseWollokLangObjectHasCorrectFQN [

	interpreter initializeWithMainLibrary.
		
	self assert: (interpreter resolve: 'wollok.lang.Object') fullyQualifiedName asString equals: 'wollok.lang.Object'. 

	
]
