Class {
	#name : #WollokLangBoolean,
	#superclass : #WollokNativeObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokLangBoolean class >> wollokClassName [

	^ 'wollok.lang.Boolean'
]

{ #category : #'native methods' }
WollokLangBoolean >> and: aWollokObject with: aWollokObject2 [ 
	
	^ interpreter asWollokBoolean: (aWollokObject asBoolean and: [ aWollokObject2 asBoolean ])
]

{ #category : #'native methods' }
WollokLangBoolean >> negate: aWollokObject [

	^ interpreter asWollokBoolean: aWollokObject asBoolean not

]

{ #category : #'native methods' }
WollokLangBoolean >> or: aWollokObject with: aWollokObject2 [ 
	
	^ interpreter asWollokBoolean: (aWollokObject asBoolean or: [ aWollokObject2 asBoolean ])

]
