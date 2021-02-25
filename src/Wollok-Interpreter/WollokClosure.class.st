Class {
	#name : #WollokClosure,
	#superclass : #WollokObject,
	#instVars : [
		'homeContext',
		'ast',
		'arguments'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #arguments }
WollokClosure >> argumentAt: aString put: aWollokObject [ 
	
	arguments at: aString put: aWollokObject 
]

{ #category : #accessing }
WollokClosure >> arguments: aCollection [ 
	arguments := aCollection
]

{ #category : #accessing }
WollokClosure >> ast [
	^ ast
]

{ #category : #accessing }
WollokClosure >> ast: aWollokClosureNode [ 
	
	ast := aWollokClosureNode
]

{ #category : #accessing }
WollokClosure >> homeContext: aWollokContext [ 
	
	homeContext := aWollokContext
]

{ #category : #arguments }
WollokClosure >> initialize [ 
	
	super initialize.
	
	arguments := Dictionary new
]

{ #category : #resolving }
WollokClosure >> resolve: aName [

	arguments at:aName ifPresent: [ :x | ^ x ].
	^ super resolve: aName
]