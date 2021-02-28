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
	
	| toConcat |
	toConcat := aWollokObject2 wollokClass = interpreter numberClass 
		ifTrue: [ aWollokObject2 unbox asInteger ]
		ifFalse: [ aWollokObject2 unbox ].
	
	^ interpreter asWollokString: (aWollokObject asPharoString , toConcat asString)
]

{ #category : #'native methods' }
WollokLangString >> contains: aWollokInmediate with: aWollokInmediate2 [ 
	
	aWollokInmediate2 wollokClass = (interpreter resolve: 'wollok.lang.String')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid String argument' ].
	^ interpreter asWollokBoolean: (aWollokInmediate unbox includesSubstring: aWollokInmediate2 unbox)
]

{ #category : #'native methods' }
WollokLangString >> equals: aWollokObject with: aWollokObject2 [ 

	aWollokObject2 wollokClass = (interpreter resolve: 'wollok.lang.String')
		ifFalse: [ ^ interpreter falseObject ].
	^ interpreter asWollokBoolean: (aWollokObject asPharoString = aWollokObject2 asPharoString)
]

{ #category : #'native methods' }
WollokLangString >> greaterThan: aWollokInmediate with: aWollokObject [ 

	aWollokObject wollokClass = (interpreter resolve: 'wollok.lang.String')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid String argument' ].
	^ interpreter asWollokBoolean: (aWollokInmediate asPharoString > aWollokObject asPharoString)
]

{ #category : #'native methods' }
WollokLangString >> indexOf: aWollokInmediate with: aWollokInmediate2 [ 
	
	| index |
	aWollokInmediate2 wollokClass = (interpreter resolve: 'wollok.lang.String')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid String argument' ].

	index := aWollokInmediate unbox indexOfSubCollection: aWollokInmediate2 asPharoString.
	index = 0 ifTrue: [ interpreter throwExceptionWithMessage: 'String argument not in receiver' ].
	
	^ interpreter asWollokNumber: index - 1
]

{ #category : #'native methods' }
WollokLangString >> lastIndexOf: aWollokInmediate with: aWollokInmediate2 [ 

	| index foundIndex |
	aWollokInmediate2 wollokClass = (interpreter resolve: 'wollok.lang.String')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid String argument' ].

	foundIndex := 0.
	[ index := aWollokInmediate unbox indexOfSubCollection: aWollokInmediate2 asPharoString startingAt: foundIndex + 1. 
		index ~= 0 ] whileTrue: [ 
			foundIndex := index ].
	
	foundIndex = 0 ifTrue: [ interpreter throwExceptionWithMessage: 'String argument not in receiver' ].
	
	^ interpreter asWollokNumber: foundIndex - 1
]

{ #category : #'native methods' }
WollokLangString >> length: aWollokInmediate [ 
	
	^ interpreter asWollokNumber: aWollokInmediate asPharoString size
]

{ #category : #'native methods' }
WollokLangString >> lowerThan: aWollokInmediate with: aWollokInmediate2 [ 

	aWollokInmediate2 wollokClass = (interpreter resolve: 'wollok.lang.String')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid String argument' ].
	^ interpreter asWollokBoolean: (aWollokInmediate asPharoString < aWollokInmediate2 asPharoString)
]

{ #category : #'native methods' }
WollokLangString >> replace: aWollokInmediate with: aWollokInmediate2 with: aWollokInmediate3 [ 

	aWollokInmediate2 wollokClass = (interpreter resolve: 'wollok.lang.String')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid String argument' ].

	aWollokInmediate3 wollokClass = (interpreter resolve: 'wollok.lang.String')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid String argument' ].

	^ interpreter asWollokString: (aWollokInmediate unbox
		copyReplaceAll: aWollokInmediate2 unbox
		with: aWollokInmediate3 unbox)
]

{ #category : #'native methods' }
WollokLangString >> reverse: aWollokInmediate [ 

	^ interpreter asWollokString: aWollokInmediate asPharoString reversed
]

{ #category : #'native methods' }
WollokLangString >> substring: aWollokInmediate with: aWollokObject [ 
	
	self checkNumber: aWollokObject name: 'index'.
	
	^ interpreter asWollokString: (aWollokInmediate unbox copyFrom: aWollokObject asNumber asInteger + 1 to: aWollokInmediate unbox size)
]

{ #category : #'native methods' }
WollokLangString >> substring: aWollokInmediate with: aWollokInmediate2 with: aWollokInmediate3 [ 
	
	aWollokInmediate2 wollokClass = (interpreter resolve: 'wollok.lang.Number')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid Number argument' ].

	aWollokInmediate3 wollokClass = (interpreter resolve: 'wollok.lang.Number')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid Number argument' ].
	
	(aWollokInmediate2 asNumber asInteger + 1 between: 1 and: aWollokInmediate asPharoString size)
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Subscript out of bounds' ].

	(aWollokInmediate3 asNumber asInteger + 1 between: 1 and: aWollokInmediate asPharoString size)
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Subscript out of bounds' ].
	
	^ interpreter asWollokString: (aWollokInmediate asPharoString
		copyFrom: aWollokInmediate2 asNumber asInteger + 1
		to: aWollokInmediate3 asNumber asInteger)
]

{ #category : #'native methods' }
WollokLangString >> toLowerCase: aWollokInmediate [ 

	^ interpreter asWollokString: aWollokInmediate asPharoString asLowercase
]

{ #category : #'native methods' }
WollokLangString >> toString: aWollokObject [ 
	
	"This is already an String"
	^ aWollokObject
]

{ #category : #'native methods' }
WollokLangString >> toUpperCase: aWollokInmediate [ 

	^ interpreter asWollokString: aWollokInmediate asPharoString asUppercase
]

{ #category : #'native methods' }
WollokLangString >> trim: aWollokInmediate [ 

	^ interpreter asWollokString: aWollokInmediate asPharoString trim
]
