Class {
	#name : #WRTestSuite,
	#superclass : #Object,
	#instVars : [
		'astNode',
		'tests',
		'file'
	],
	#category : #'Wollok-UI'
}

{ #category : #accessing }
WRTestSuite >> addTestForAST: aWollokTestNode [ 
	
	| test |
	test := WRTestCase new
		astNode: aWollokTestNode;
		suite: self;
		yourself.
	tests add: test.
	^ test
]

{ #category : #accessing }
WRTestSuite >> astNode [
	^ astNode
]

{ #category : #accessing }
WRTestSuite >> astNode: aWollokSuiteNode [ 
	astNode := aWollokSuiteNode
]

{ #category : #accessing }
WRTestSuite >> children [
	
	^ tests
]

{ #category : #accessing }
WRTestSuite >> file [
	^ file
]

{ #category : #accessing }
WRTestSuite >> file: anObject [
	file := anObject
]

{ #category : #accessing }
WRTestSuite >> fileNode [
	
	^ file astNode
]

{ #category : #accessing }
WRTestSuite >> icon [
	
	^ self result icon
]

{ #category : #accessing }
WRTestSuite >> initialize [

	super initialize.
	tests := OrderedCollection new
]

{ #category : #accessing }
WRTestSuite >> name [

	astNode ifNil: [ ^ 'default suite' ].
	^ astNode name value value allButFirst allButLast
]

{ #category : #accessing }
WRTestSuite >> result [

	^ tests
		inject: WRTestResultNotRun new
		into: [ :result :test | result + test result ]
]

{ #category : #running }
WRTestSuite >> run [
	
	tests do: [ :e | e run ]
]

{ #category : #accessing }
WRTestSuite >> sourceCode [
	
	^ astNode
		ifNil: [ file sourceCode ]
		ifNotNil: [ astNode source ]
]

{ #category : #accessing }
WRTestSuite >> tests: anObject [
	tests := anObject
]
