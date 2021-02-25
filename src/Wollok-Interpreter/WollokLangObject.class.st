Class {
	#name : #WollokLangObject,
	#superclass : #WollokNativeObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokLangObject class >> wollokClassName [

	^ 'wollok.lang.Object'
]

{ #category : #'native methods' }
WollokLangObject >> checkNotNull: aReceiver with: aMaybeNull with: variableName [

	aReceiver = interpreter nullObject 
		ifTrue: [ self halt ].

]

{ #category : #'native methods' }
WollokLangObject >> identity: aWollokObject [ 
	
	^ interpreter asWollokNumber: aWollokObject hash
]
