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

	aWollokObject2 wollokClass = (interpreter resolve: 'wollok.lang.String')
		ifFalse: [ ^ interpreter falseObject ].
	^ interpreter asWollokBoolean: (aWollokObject asPharoString = aWollokObject2 asPharoString)
]

{ #category : #'native methods' }
WollokLangString >> length: aWollokInmediate [ 
	
	^ interpreter asWollokNumber: aWollokInmediate asPharoString size
]

{ #category : #'native methods' }
WollokLangString >> substring: aWollokInmediate with: aWollokObject [ 
	
	^ interpreter throwExceptionWithMessage: 'Invalid Number of Arguments'
]

{ #category : #'native methods' }
WollokLangString >> substring: aWollokInmediate with: aWollokInmediate2 with: aWollokInmediate3 [ 
	
	aWollokInmediate2 wollokClass = (interpreter resolve: 'wollok.lang.Number')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid Number argument' ].

	aWollokInmediate3 wollokClass = (interpreter resolve: 'wollok.lang.Number')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid Number argument' ].
	
	^ interpreter asWollokString: (aWollokInmediate asPharoString
		copyFrom: aWollokInmediate2 asNumber asInteger + 1
		to: aWollokInmediate3 asNumber asInteger)
]

{ #category : #'native methods' }
WollokLangString >> toString: aWollokObject [ 
	
	"This is already an String"
	^ aWollokObject
]
