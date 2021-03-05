Class {
	#name : #WollokTestFeatureMapBuilder,
	#superclass : #WollokRunSanityTests,
	#instVars : [
		'success'
	],
	#category : #'Wollok-Tests'
}

{ #category : #'as yet unclassified' }
WollokTestFeatureMapBuilder class >> exportAsCSVMap: aDictionary to: file [
	file asFileReference ensureDelete.
	file asFileReference writeStreamDo: [ :str | | sortedValues |
		str tab;tab.
		sortedValues := aDictionary values flattened asSet sorted.
		sortedValues do: [ :e |
			str nextPutAll: e asString; tab ].
		str cr.
		aDictionary keysAndValuesDo: [ :k :v |
			str
				nextPutAll: k first name value value asString;
				tab;
				nextPutAll: (k second relativeTo: WollokLoader essentialTestsRootDirectory) pathString asString;
				tab.
			
			sortedValues do: [ :e |
				str nextPutAll: (v includes: e) asString; tab.
			 ].
			str cr.
			]
		]
]

{ #category : #'building suites' }
WollokTestFeatureMapBuilder class >> testParameters [ 

	| directory aMatrix |
	
	aMatrix := ParametrizedTestMatrix new.

	directory := WollokLoader essentialTestsRootDirectory.

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

{ #category : #tests }
WollokTestFeatureMapBuilder >> newInterpreter [

	^ WollokFeatureMapBuilder new
]

{ #category : #tests }
WollokTestFeatureMapBuilder >> tearDown [

	success = true ifTrue: [
		FeatureMap at: {rootAstNode . fileToTest} put: interpreter featureMap.
		interpreter rootPackage children collect: [ :e | 
			interpreter featureMap add: e class name ].
	].
	super tearDown.
]

{ #category : #tests }
WollokTestFeatureMapBuilder >> testExecuteSanityTest [

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
interpreter initialize.
	testResult := WollokTestResult new.
	
	[interpreter interpretTest: wollokTestCase storingResultsIn: testResult]
		on: WollokError do: [ :e |
			(e wollokException wollokClass = (interpreter resolve: 'wollok.lib.AssertionException'))
				ifFalse: [ e pass ].
			self fail: e wollokException unbox unbox ].
	success := true.
]
