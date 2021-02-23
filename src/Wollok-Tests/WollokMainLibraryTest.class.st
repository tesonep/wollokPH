Class {
	#name : #WollokMainLibraryTest,
	#superclass : #AbstractWollokInterpreterTest,
	#category : #'Wollok-Tests'
}

{ #category : #tests }
WollokMainLibraryTest >> testParseWollokLangHasObjectClass [

	self interpretExpression: '1'.

	self assert: (interpreter resolve: 'wollok.lang.Object') isNotNil. 

	
]

{ #category : #tests }
WollokMainLibraryTest >> testParseWollokLangHasWollokLangPackage [

	self interpretExpression: '1'.
	self assert: (interpreter resolve: 'wollok.lang') isNotNil. 

	
]

{ #category : #tests }
WollokMainLibraryTest >> testParseWollokLangObjectHasCorrectFQN [

	self interpretExpression: '1'.
	self assert: (interpreter resolve: 'wollok.lang.Object') fullyQualifiedName asString equals: 'wollok.lang.Object'. 

	
]
