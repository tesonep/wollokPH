Class {
	#name : #WollokLangDictionary,
	#superclass : #WollokNativeObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokLangDictionary class >> wollokClassName [ 
	
	^ 'wollok.lang.Dictionary'
]

{ #category : #'native methods' }
WollokLangDictionary >> initialize: aWollokObject [ 
	
	aWollokObject instanceVariables: { Dictionary new }
]
