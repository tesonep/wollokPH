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

	| arguments |
	
	arguments := interpreter distributeArguments: aCollection asCollection intoParameters: aWollokClosure ast parameters.
	aWollokClosure arguments: arguments.

	^ aWollokClosure ast expression acceptVisitor: interpreter.

]
