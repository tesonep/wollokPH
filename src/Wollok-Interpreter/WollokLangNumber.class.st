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
WollokLangNumber >> division: aWollokInmediate with: aWollokInmediate2 [ 
	
	^ interpreter asWollokNumber: aWollokInmediate asNumber / aWollokInmediate2 asNumber
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
WollokLangNumber >> invert: aWollokNumber [ 
	
	^ interpreter asWollokNumber: aWollokNumber asNumber negated
]

{ #category : #'native methods' }
WollokLangNumber >> lowerThan: aWollokObject with: aWollokObject2 [ 

	^ interpreter asWollokBoolean: (aWollokObject asNumber < aWollokObject2 asNumber)
]

{ #category : #'native method' }
WollokLangNumber >> minus: aReceiver with: anotherObject [ 

	^ interpreter asWollokNumber: aReceiver asNumber - anotherObject asNumber
]

{ #category : #'native methods' }
WollokLangNumber >> multiply: aReceiver with: otherWollokNumber [

	^ interpreter asWollokNumber: aReceiver asNumber * otherWollokNumber asNumber
]

{ #category : #'native methods' }
WollokLangNumber >> raiseTo: aReceiver with: anotherObject [ 
	
	^ interpreter asWollokNumber: aReceiver asNumber ** anotherObject asNumber
]
