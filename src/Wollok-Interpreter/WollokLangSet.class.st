Class {
	#name : #WollokLangSet,
	#superclass : #WollokNativeObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokLangSet class >> wollokClassName [

	^ 'wollok.lang.Set'
]

{ #category : #'native methods' }
WollokLangSet >> equals: aWollokInmediate with: aWollokObject [ 

	aWollokInmediate wollokClass = aWollokObject wollokClass
		ifFalse: [ ^ interpreter falseObject ].
		
	^ interpreter asWollokBoolean: (aWollokInmediate unbox = aWollokObject unbox)
]
