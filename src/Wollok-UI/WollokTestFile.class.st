Class {
	#name : #WollokTestFile,
	#superclass : #Object,
	#instVars : [
		'suites',
		'astNode',
		'file'
	],
	#category : #'Wollok-UI'
}

{ #category : #'as yet unclassified' }
WollokTestFile class >> forFile: aFile [

	| instance wollokFileNode |
	instance := self new.
	instance file: aFile.
	
	wollokFileNode := WollokParser parseFile: aFile.
	instance astNode: wollokFileNode.
	
	wollokFileNode tests ifNotEmpty: [ | suite |
		suite := instance addDefaultSuite.
		wollokFileNode tests do: [ :aTestNode |
			suite addTestForAST: aTestNode
		] ].
	wollokFileNode suites do: [ :aSuiteNode | | suite |
		suite := instance addSuiteForAST: aSuiteNode.
		aSuiteNode tests do: [ :aTestNode |
			suite addTestForAST: aTestNode
		] ].
	^ instance
]

{ #category : #building }
WollokTestFile >> addDefaultSuite [
	
	^ self addSuiteForAST: nil
]

{ #category : #building }
WollokTestFile >> addSuiteForAST: aWollokSuiteNode [ 
	
	| suite |
	suite := WRTestSuite new
		astNode: aWollokSuiteNode;
		file: self;
		yourself.
	suites add: suite.
	^ suite
]

{ #category : #accessing }
WollokTestFile >> astNode [
	^ astNode
]

{ #category : #accessing }
WollokTestFile >> astNode: aWollokFileNode [

	astNode := aWollokFileNode 
]

{ #category : #accessing }
WollokTestFile >> children [
	
	^ suites
]

{ #category : #accessing }
WollokTestFile >> file: aFileReference [ 
	
	file := aFileReference
]

{ #category : #accessing }
WollokTestFile >> icon [
	
	^ self iconNamed: #catalog
]

{ #category : #building }
WollokTestFile >> initialize [
	super initialize.
	suites := OrderedCollection new
]

{ #category : #testing }
WollokTestFile >> isEmpty [
	
	^ suites isEmpty
]

{ #category : #accessing }
WollokTestFile >> name [
	
	^ (file relativeTo: WollokLoader sanityTestsRootDirectory) pathString
]

{ #category : #running }
WollokTestFile >> run [
	
	suites do: [ :suite | suite run ]
]

{ #category : #accessing }
WollokTestFile >> sourceCode [
	
	^ astNode source
]
