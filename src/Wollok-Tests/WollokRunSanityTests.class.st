Class {
	#name : #WollokRunSanityTests,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'fileToTest',
		'suite',
		'interpreter',
		'rootAstNode'
	],
	#category : #'Wollok-Tests'
}

{ #category : #'building suites' }
WollokRunSanityTests class >> testParameters [ 

	| directory aMatrix |
	
	aMatrix := ParametrizedTestMatrix new.

	directory := WollokPlatform current sanityTestsRootDirectory / 'essential'.

	directory allChildren 
		select: [ :e | #( 'wtest') includes: e extension ]
		thenDo: [ :e | | wollokFileNode |
			wollokFileNode := WollokParser parseFile: e.

			wollokFileNode tests do: [ :aTest |
				aMatrix addCase: { 
					#suite -> nil. 
					#rootAstNode -> aTest.
					#fileToTest -> e } ].

			wollokFileNode suites do: [ :aSuite |
				aSuite tests do: [ :aTest | 
				aMatrix addCase: { 
					#suite -> aSuite . 
					#rootAstNode -> aTest.
					#fileToTest -> e } ] ] ].

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
WollokRunSanityTests >> newInterpreter [

	^ WollokInterpreter new
]

{ #category : #tests }
WollokRunSanityTests >> printOn: aStream [

	aStream nextPutAll: self class printString.
	self printTestSelectorOn: aStream.
	aStream nextPutAll: '('.
	parametersToUse do: [ :e |
		(e valuable isKindOf: FileReference)
			ifTrue: [ aStream nextPutAll: (e valuable path relativeTo: WollokPlatform current sanityTestsRootDirectory) pathString ]
			ifFalse: [ aStream nextPutAll: (e valuable ifNotNil: #name) value value asString ].
	] separatedBy: [ aStream nextPutAll: ';'. ].
	aStream nextPutAll: ')'.

]

{ #category : #accessing }
WollokRunSanityTests >> rootAstNode [
	^ rootAstNode
]

{ #category : #accessing }
WollokRunSanityTests >> rootAstNode: anObject [
	rootAstNode := anObject
]

{ #category : #tests }
WollokRunSanityTests >> setUp [

	super setUp.
	interpreter := self newInterpreter.
]

{ #category : #accessing }
WollokRunSanityTests >> suite: aWollokSuiteNode [ 
	
	suite := aWollokSuiteNode 
]

{ #category : #tests }
WollokRunSanityTests >> testExecuteSanityTest [

	| fileNode testResult rootPackage wollokSuite wollokTestCase |
	fileNode := rootAstNode topParent.

	rootPackage := WollokLoader new
		interpreter: interpreter;
		rootFile: fileNode;
		load.
	interpreter rootPackage: rootPackage.
	
	wollokSuite := suite
		ifNil: [ rootPackage defaultSuite ]
		ifNotNil: [ rootPackage suites detect: [ :e | e ast = suite ] ].
	wollokTestCase := wollokSuite tests detect: [ :e | e ast = rootAstNode ].
	
	rootPackage resolveBindingsUsing: interpreter.
	rootPackage initializeStateUsing: interpreter.

	testResult := WollokTestResult new.
	
	[interpreter interpretTest: wollokTestCase storingResultsIn: testResult]
		on: WollokError do: [ :e |
			(e wollokException wollokClass = (interpreter resolve: 'wollok.lib.AssertionException'))
				ifFalse: [ e pass ].
			self fail: e wollokException unbox unbox ]
	
]
