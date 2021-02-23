Class {
	#name : #AbstractWollokInterpreterTest,
	#superclass : #TestCase,
	#instVars : [
		'interpreter'
	],
	#category : #'Wollok-Tests'
}

{ #category : #running }
AbstractWollokInterpreterTest >> interpretExpression: aString [

	^ interpreter interpretProgram: (self parse: (self wrapForREPL: aString))
]

{ #category : #utils }
AbstractWollokInterpreterTest >> parse: aString [ 
	
	^ WollokParser parse: aString
]

{ #category : #tests }
AbstractWollokInterpreterTest >> setUp [

	interpreter := WollokInterpreter new		

]

{ #category : #running }
AbstractWollokInterpreterTest >> wrapForREPL: aString [

	^ String streamContents: [ :aStream | 
			aStream 
				nextPutAll:	'program testExpression {'; cr;
				tab; nextPutAll: aString; cr;
	 			nextPutAll: '}'
		 ]
]
