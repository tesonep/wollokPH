Class {
	#name : #WollokClosure,
	#superclass : #WollokObject,
	#instVars : [
		'homeContext',
		'ast'
	],
	#category : #'Wollok-Interpreter'
}

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
