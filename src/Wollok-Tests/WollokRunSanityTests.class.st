Class {
	#name : #WollokRunSanityTests,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'fileToTest',
		'test',
		'suite'
	],
	#category : #'Wollok-Tests'
}

{ #category : #'building suites' }
WollokRunSanityTests class >> testParameters [ 

	| directory aMatrix defaultSuite |
	
	aMatrix := ParametrizedTestMatrix new.

	directory := WollokLoader sanityTestsRootDirectory.

	directory allChildren 
		select: [ :e | #( 'wtest') includes: e extension ]
		thenDo: [ :e | | wollokFileNode |
			wollokFileNode := WollokParser parseFile: e.

			defaultSuite := WollokTestSuite new 
				name: 'defaultTestSuite';
				yourself.
			wollokFileNode tests do: [ :aTest |
				aMatrix addCase: { 
					#suite -> defaultSuite. 
					#test -> aTest.
					#fileToTest -> e } ].

			wollokFileNode suites do: [ :aSuite |
				aSuite tests do: [ :aTest | 
				aMatrix addCase: { 
					#suite -> aSuite . 
					#test -> aTest.
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
WollokRunSanityTests >> printOn: aStream [

	aStream nextPutAll: self class printString.
	self printTestSelectorOn: aStream.
	aStream nextPutAll: '('.
	parametersToUse do: [ :e |
		(e valuable isKindOf: FileReference)
			ifTrue: [ aStream nextPutAll: (e valuable path relativeTo: WollokLoader sanityTestsRootDirectory) pathString ]
			ifFalse: [ aStream nextPutAll: e valuable name value value asString ].
	] separatedBy: [ aStream nextPutAll: ';'. ].
	aStream nextPutAll: ')'.

]

{ #category : #accessing }
WollokRunSanityTests >> suite: aWollokSuiteNode [ 
	
	suite := aWollokSuiteNode 
]

{ #category : #accessing }
WollokRunSanityTests >> test [
	^ test
]

{ #category : #accessing }
WollokRunSanityTests >> test: anObject [
	test := anObject
]

{ #category : #tests }
WollokRunSanityTests >> testExecuteSanityTest [

	| interpreter fileNode testResult rootPackage wollokSuite wollokTestCase |
	interpreter := WollokInterpreter new.
	fileNode := test topParent.

	rootPackage := WollokLoader new
		interpreter: interpreter;
		rootFile: fileNode;
		load.
	interpreter rootPackage: rootPackage.
	
	wollokSuite := rootPackage suites detect: [ :e | e ast = suite ].
	wollokTestCase := wollokSuite tests detect: [ :e | e ast = test ].
	
	rootPackage resolveBindingsUsing: interpreter.
	rootPackage initializeStateUsing: interpreter.

	testResult := WollokTestResult new.
	
	suite fixture ifNotNil: [:aFixture | interpreter interpretFixture: aFixture ].
	interpreter interpretTest: wollokTestCase storingResultsIn: testResult.
	
	self assert: testResult errors size equals: 0.
	self assert: testResult failures size equals: 0.	

]
