Class {
	#name : #WollokLangNumber,
	#superclass : #WollokNativeObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokLangNumber class >> wollokClassName [

	^ 'wollok.lang.Number'
]

{ #category : #'native methods' }
WollokLangNumber >> abs: aWollokInmediate [ 

	^ interpreter asWollokNumber: aWollokInmediate asNumber abs
]

{ #category : #'native methods' }
WollokLangNumber >> add: aWollokObject with: aWollokObject2 [ 
	
	aWollokObject2 wollokClass = (interpreter resolve: 'wollok.lang.Number')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid number argument' ].
	^ interpreter asWollokNumber: (aWollokObject asNumber + aWollokObject2 asNumber)
]

{ #category : #'native methods' }
WollokLangNumber >> coerceToInteger: aWollokInmediate [ 

	^ interpreter asWollokNumber: aWollokInmediate asNumber asInteger
]

{ #category : #'native methods' }
WollokLangNumber >> division: aWollokInmediate with: aWollokInmediate2 [ 

	aWollokInmediate2 wollokClass = (interpreter resolve: 'wollok.lang.Number')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid number argument' ].
	aWollokInmediate2 asNumber = 0
		ifTrue: [ ^ interpreter throwExceptionWithMessage: 'Zero divide' ].
	^ interpreter asWollokNumber: aWollokInmediate asNumber / aWollokInmediate2 asNumber
]

{ #category : #'native methods' }
WollokLangNumber >> doubleEquals: aWollokObject with: aWollokObject2 [ 

	aWollokObject wollokClass = aWollokObject2 wollokClass
		ifFalse: [ ^ interpreter falseObject ].
		
	^ interpreter asWollokBoolean: (aWollokObject asNumber = aWollokObject2 asNumber)

]

{ #category : #'native methods' }
WollokLangNumber >> gcd: aWollokInmediate with: aWollokInmediate2 [ 

	aWollokInmediate2 wollokClass = (interpreter resolve: 'wollok.lang.Number')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid number argument' ].
		
	^ interpreter asWollokNumber: (aWollokInmediate asNumber asInteger gcd: aWollokInmediate2 asNumber asInteger)
]

{ #category : #'native methods' }
WollokLangNumber >> greaterThan: aWollokObject with: aWollokObject2 [ 
	
	aWollokObject2 wollokClass = (interpreter resolve: 'wollok.lang.Number')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid number argument' ].
	^ interpreter asWollokBoolean: (aWollokObject asNumber > aWollokObject2 asNumber)
]

{ #category : #'native methods' }
WollokLangNumber >> invert: aWollokNumber [ 
	
	^ interpreter asWollokNumber: aWollokNumber asNumber negated
]

{ #category : #'native methods' }
WollokLangNumber >> isInteger: aWollokInmediate [ 
	
	^ interpreter asWollokBoolean: (aWollokInmediate asNumber = aWollokInmediate asNumber asInteger)
]

{ #category : #'native methods' }
WollokLangNumber >> lowerThan: aWollokObject with: aWollokObject2 [ 

	aWollokObject2 wollokClass = (interpreter resolve: 'wollok.lang.Number')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid number argument' ].
	^ interpreter asWollokBoolean: (aWollokObject asNumber < aWollokObject2 asNumber)
]

{ #category : #'native methods' }
WollokLangNumber >> minus: aReceiver with: anotherObject [ 

	anotherObject wollokClass = (interpreter resolve: 'wollok.lang.Number')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid number argument' ].
	^ interpreter asWollokNumber: aReceiver asNumber - anotherObject asNumber
]

{ #category : #'native methods' }
WollokLangNumber >> modulo: aReceiver with: otherWollokNumber [

	otherWollokNumber wollokClass = (interpreter resolve: 'wollok.lang.Number')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid number argument' ].
	^ interpreter asWollokNumber: aReceiver asNumber \\ otherWollokNumber asNumber
]

{ #category : #'native methods' }
WollokLangNumber >> multiply: aReceiver with: otherWollokNumber [

	otherWollokNumber wollokClass = (interpreter resolve: 'wollok.lang.Number')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid number argument' ].
	^ interpreter asWollokNumber: aReceiver asNumber * otherWollokNumber asNumber
]

{ #category : #'native methods' }
WollokLangNumber >> raiseTo: aReceiver with: anotherObject [ 
	
	anotherObject wollokClass = (interpreter resolve: 'wollok.lang.Number')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid number argument' ].
	^ interpreter asWollokNumber: aReceiver asNumber ** anotherObject asNumber
]

{ #category : #'native methods' }
WollokLangNumber >> roundUp: aReceiver with: aWollokNumber [

	| aFloat rounding desiredDecimals parts aReceiverNumber |

	aWollokNumber wollokClass = (interpreter resolve: 'wollok.lang.Number')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid number argument' ].

	desiredDecimals := aWollokNumber asNumber.
	
	desiredDecimals >= 0
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid negative argument' ].
	
	aReceiverNumber := aReceiver asNumber asFloat.

	"Lets check if the rounding is already done"
	parts := aReceiverNumber printString splitOn: $. .
	parts size = 1 ifTrue: [ ^ aReceiver ].
	(parts at:2) size <= desiredDecimals ifTrue: [ ^ aReceiver ].

	rounding := desiredDecimals = 1 
							ifTrue: [ 0.1 ] 
							ifFalse: [ 10 ** desiredDecimals negated ].

	aFloat := (aReceiverNumber roundUpTo: rounding) asFloat.

	^ interpreter asWollokNumber: aFloat 
]

{ #category : #'native methods' }
WollokLangNumber >> toString: aWollokInmediate [ 
	
	| toStringify |
	toStringify := aWollokInmediate asNumber = aWollokInmediate asNumber asInteger
		ifTrue: [ aWollokInmediate asNumber asInteger ]
		ifFalse: [ aWollokInmediate asNumber asFloat ].
	^ interpreter asWollokString: toStringify asString
]

{ #category : #'native methods' }
WollokLangNumber >> truncate: aReceiver with: aPrecision [ 

	| aFloat rounding desiredDecimals parts aReceiverNumber |

	aPrecision wollokClass = (interpreter resolve: 'wollok.lang.Number')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid number argument' ].

	desiredDecimals := aPrecision asNumber.
	
	desiredDecimals >= 0
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid negative argument' ].
	aReceiverNumber := aReceiver asNumber asFloat.

	"Lets check if the rounding is already done"
	parts := aReceiverNumber printString splitOn: $. .
	parts size = 1 ifTrue: [ ^ aReceiver ].
	(parts at:2) size <= desiredDecimals ifTrue: [ ^ aReceiver ].

	rounding := desiredDecimals = 1 
							ifTrue: [ 0.1 ] 
							ifFalse: [ 10 ** desiredDecimals negated ].

	aFloat := (aReceiverNumber truncateTo: rounding) asFloat.

	^ interpreter asWollokNumber: aFloat 
]
