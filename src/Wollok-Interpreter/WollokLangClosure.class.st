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

	^ interpreter applyClosure: aWollokClosure withArguments: aCollection asCollection
]

{ #category : #'native methods' }
WollokLangClosure >> toString: aWollokClosure [ 
	
	^ interpreter asWollokString: aWollokClosure ast source
]
