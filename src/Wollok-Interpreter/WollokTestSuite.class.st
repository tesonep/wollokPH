Class {
	#name : #WollokTestSuite,
	#superclass : #WollokClass,
	#instVars : [
		'tests',
		'fixture'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #children }
WollokTestSuite >> addTest: aWollokTestCase [ 
	
	tests add: aWollokTestCase.
	aWollokTestCase parent: self
]

{ #category : #accessing }
WollokTestSuite >> fixture [

	^ fixture
]

{ #category : #accessing }
WollokTestSuite >> fixture: aWollokTestFixture [ 

	fixture := aWollokTestFixture
]

{ #category : #accessing }
WollokTestSuite >> initialize [ 
	
	super initialize.
	tests := OrderedCollection new
]

{ #category : #accessing }
WollokTestSuite >> name [
	
	^ name ifNil: [ ast name value value]
]

{ #category : #accessing }
WollokTestSuite >> name: aValue [

	name := aValue
]

{ #category : #initialization }
WollokTestSuite >> resolveBindingsUsing: aWollokInterpreter [ 

	super resolveBindingsUsing: aWollokInterpreter.
	tests do: [ :e | e resolveBindingsUsing: aWollokInterpreter]
]

{ #category : #'private - intance creation' }
WollokTestSuite >> runConstructorOn: anInstance arguments: arguments allVariables: allVariables interpreter: anInterpreter [

	anInterpreter pushInitializationContextFor: anInstance.

	allVariables withIndexDo: [ :aVariable :anIndex | 
			anInstance instanceVariables at: anIndex put: (
					aVariable right 
						ifNil: [ anInterpreter nullObject ] 
						ifNotNil:[ :anExpression | anExpression acceptVisitor: anInterpreter ])  ].

	fixture ifNotNil: [  
		anInterpreter activateMethod: fixture withReceiver: anInstance withArguments: #()].
	
	anInterpreter popContext
]

{ #category : #accessing }
WollokTestSuite >> superclassName [
	"A test suite does not have a superclass"
	^ nil
]

{ #category : #accessing }
WollokTestSuite >> tests [
	^ tests
]

{ #category : #accessing }
WollokTestSuite >> tests: aCollection [ 

	tests := aCollection
]
