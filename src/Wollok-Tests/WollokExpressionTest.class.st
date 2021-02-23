Class {
	#name : #WollokExpressionTest,
	#superclass : #AbstractWollokInterpreterTest,
	#category : #'Wollok-Tests'
}

{ #category : #running }
WollokExpressionTest >> testObjectLiteralHasCorrectClassReference [

	| returnObject |

	returnObject := self interpretExpression: 'object {}'.
	
	self 
		assert: returnObject wollokClass superclass 
		equals: (interpreter resolve: 'wollok.lang.Object')
]
