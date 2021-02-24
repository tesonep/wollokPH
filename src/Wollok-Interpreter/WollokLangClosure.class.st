Class {
	#name : #WollokLangClosure,
	#superclass : #WollokNativeObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokLangClosure class >> wollokClassName [

	^ 'wollok.lang.Closure'
]

{ #category : #'native methods' }
WollokLangClosure >> apply: aWollokClosure with: aCollection [ 

	| lastExpression |
	lastExpression := interpreter voidObject.

	aWollokClosure ast expression expressions do: [:e | 
			lastExpression := e acceptVisitor: interpreter ].
		
	^ lastExpression
]
