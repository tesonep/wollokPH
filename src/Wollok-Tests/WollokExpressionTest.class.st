Class {
	#name : #WollokExpressionTest,
	#superclass : #TestCase,
	#instVars : [
		'interpreter'
	],
	#category : #'Wollok-Tests'
}

{ #category : #running }
WollokExpressionTest >> interpretExpression: aString [

	^ interpreter interpretProgram: (self parse: (self wrapForREPL: aString))
]

{ #category : #utils }
WollokExpressionTest >> parse: aString [ 
	
	^ WollokParser parse: aString
]

{ #category : #running }
WollokExpressionTest >> setUp [

	interpreter := WollokInterpreter new.
	interpreter initializeWithMainLibrary

]

{ #category : #running }
WollokExpressionTest >> testObjectLiteralHasCorrectClassReference [

	| returnObject |

	returnObject := self interpretExpression: 'object {}'.
	
	self 
		assert: returnObject wollokClass superclass 
		equals: (interpreter resolve: 'wollok.lang.Object')
]

{ #category : #running }
WollokExpressionTest >> wrapForREPL: aString [

	^ String streamContents: [ :aStream | 
			aStream 
				nextPutAll:	'program testExpression {'; cr;
				tab; nextPutAll: aString; cr;
	 			nextPutAll: '}'
		 ]
]
