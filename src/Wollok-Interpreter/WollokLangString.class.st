Class {
	#name : #WollokLangString,
	#superclass : #WollokNativeObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokLangString class >> wollokClassName [

	^ 'wollok.lang.String'
]

{ #category : #'native methods' }
WollokLangString >> concat: aWollokObject with: aWollokObject2 [ 
	
	^ interpreter asWollokString: (aWollokObject asPharoString , aWollokObject2 asPharoString)
]

{ #category : #'native methods' }
WollokLangString >> equals: aWollokObject with: aWollokObject2 [ 

	^ interpreter asWollokBoolean: (aWollokObject asPharoString = aWollokObject2 asPharoString)
]

{ #category : #'native method' }
WollokLangString >> toString: aWollokObject [ 
	
	"This is already an String"
	^ aWollokObject
]
