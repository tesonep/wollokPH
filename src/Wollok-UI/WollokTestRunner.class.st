Class {
	#name : #WollokTestRunner,
	#superclass : #SpPresenter,
	#instVars : [
		'testTree',
		'buttons',
		'runButton',
		'testFiles',
		'progressBar',
		'code'
	],
	#category : #'Wollok-UI'
}

{ #category : #specs }
WollokTestRunner class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: (SpBoxLayout newHorizontal 
			add: #testTree;
			add: #code;
			yourself);
		add: #progressBar withConstraints: [ :constraints | constraints height: 10 ];
		add: #buttons height: 50;
		yourself
]

{ #category : #highlighting }
WollokTestRunner >> highlight: anAST [

	^ WollokSyntaxHighlighter new highlight: anAST
]

{ #category : #TOREMOVE }
WollokTestRunner >> initialExtent [

	^ 800@600
]

{ #category : #initialization }
WollokTestRunner >> initializePresenter [

	self updateTree.
	
	testTree whenSelectionChangedDo: [ :selection |
		self select: selection selectedItem ]. 
	
	progressBar fixedPercentage: 0.
	runButton action: [ self runAllTests ]
]

{ #category : #initialization }
WollokTestRunner >> initializeWidgets [

	testTree := self newTreeTable.
	testTree
		addColumn: (SpCompositeTableColumn new
			title: 'Test'; 
			addColumn: ((SpImageTableColumn evaluated: [ :each | each icon ]) width: 20);
			addColumn: (SpStringTableColumn evaluated: [ :each | each name ]));
		children: [ :node | node children ].
	
	code := self newText.
	
	progressBar := self newProgressBar.
	
	buttons := self newButtonBar.
	buttons add: (runButton := self newButton).
	runButton label: 'Run tests'
]

{ #category : #initialization }
WollokTestRunner >> runAllTests [

	[
	self testFiles doWithIndex: [ :e :i |
		e run.
		self defer: [ progressBar adapter widget submorphs first value: (i / self testFiles size) asFloat ] ].
	self defer: [self updateTree].
	] forkAt: 39.
]

{ #category : #events }
WollokTestRunner >> select: aWollokTestElement [ 
	
	aWollokTestElement ifNil: [ 
		code text: ''.
		^ self ].
	code text: (self highlight: aWollokTestElement astNode)
]

{ #category : #initialization }
WollokTestRunner >> testFiles [

	| directory |
	
	testFiles ifNotNil: [ ^ testFiles ].
	
	directory := WollokLoader essentialTestsRootDirectory.
	testFiles := OrderedCollection new.
	directory allChildren 
		select: [ :e | #( 'wtest') includes: e extension ]
		thenDo: [ :e | | testFile |
			testFile := WollokTestFile forFile: e.
			testFile isEmpty ifFalse: [ testFiles add: testFile ] ].
	^ testFiles
]

{ #category : #initialization }
WollokTestRunner >> updateTree [

	testTree roots: self testFiles.
]
