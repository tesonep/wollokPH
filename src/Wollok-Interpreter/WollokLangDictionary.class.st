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
WollokLangDictionary >> basicGet: aWollokDictionary with: aKey [ 
	
	^ aWollokDictionary unbox at: aKey
]

{ #category : #'native methods' }
WollokLangDictionary >> initialize: aWollokObject [ 
	
	aWollokObject instanceVariables: { Dictionary new }
]

{ #category : #'native methods' }
WollokLangDictionary >> put: aWollokDictionary with: aKey with: aValue [ 
	
	aWollokDictionary unbox at: aKey put: aValue.
	^ aWollokDictionary
]
