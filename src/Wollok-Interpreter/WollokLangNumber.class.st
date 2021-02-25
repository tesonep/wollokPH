Class {
	#name : #WollokLangNumber,
	#superclass : #WollokNativeObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokLangNumber class >> wollokClassName [

	^ 'wollok.lang.Number'
]

{ #category : #'native methdos' }
WollokLangNumber >> add: aWollokObject with: aWollokObject2 [ 
	
	^ interpreter asWollokNumber: (aWollokObject asNumber + aWollokObject2 asNumber)
]

{ #category : #'native methods' }
WollokLangNumber >> doubleEquals: aWollokObject with: aWollokObject2 [ 

	aWollokObject wollokClass = aWollokObject2 wollokClass
		ifFalse: [ ^ interpreter falseObject ].
		
	^ interpreter asWollokBoolean: (aWollokObject asNumber = aWollokObject2 asNumber)

]

{ #category : #'native methods' }
WollokLangNumber >> greaterThan: aWollokObject with: aWollokObject2 [ 
	
	^ interpreter asWollokBoolean: (aWollokObject asNumber > aWollokObject2 asNumber)
]

{ #category : #'native methods' }
WollokLangNumber >> lowerThan: aWollokObject with: aWollokObject2 [ 

	^ interpreter asWollokBoolean: (aWollokObject asNumber < aWollokObject2 asNumber)
]
