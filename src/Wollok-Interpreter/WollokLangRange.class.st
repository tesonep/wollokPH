Class {
	#name : #WollokLangRange,
	#superclass : #WollokNativeObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokLangRange class >> wollokClassName [

	^ 'wollok.lang.Range'
]

{ #category : #'native methods' }
WollokLangRange >> forEach: aWollokObject with: aWollokClosure [ 

	aWollokObject asInterval do: [ :e |
		interpreter
			sendMessage: 'apply'
			to: aWollokClosure
			withArguments: { interpreter asWollokNumber: e }].
	^ interpreter voidObject
]
