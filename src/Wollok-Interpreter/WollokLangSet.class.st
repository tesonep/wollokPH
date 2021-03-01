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
WollokLangSet >> add: aWollokSet with: aWollokObject [

	^ aWollokSet unbox add: aWollokObject 
]

{ #category : #'native methods' }
WollokLangSet >> anyOne: aWollokSet [ 
	
	aWollokSet unbox ifEmpty: [ interpreter throwExceptionWithMessage: 'Cannot do anyOne on empty Set' ].
	
	^ aWollokSet unbox anyOne
]

{ #category : #'native methods' }
WollokLangSet >> contains: aWollokSet with: aWollokObject [ 
	
	^ interpreter asWollokBoolean: (aWollokSet unbox includes: aWollokObject)
]

{ #category : #'native methods' }
WollokLangSet >> equals: aWollokInmediate with: aWollokObject [ 

	aWollokInmediate wollokClass = aWollokObject wollokClass
		ifFalse: [ ^ interpreter falseObject ].
		
	^ interpreter asWollokBoolean: (aWollokInmediate unbox = aWollokObject unbox)
]

{ #category : #'native methods' }
WollokLangSet >> filter: aWollokSet with: aWollokClosure [ 
	
	aWollokClosure wollokClass = (interpreter resolve: 'wollok.lang.Closure')
		ifFalse: [ interpreter throwExceptionWithMessage: 'parameter should be a Closure' ].
		
	^ interpreter asWollokSet: (aWollokSet unbox select: [ :anItem | |aMaybeBoolean|
			aMaybeBoolean := interpreter sendMessage: 'apply' to: aWollokClosure withArguments: { anItem }.
			aMaybeBoolean wollokClass = interpreter booleanClass 
				ifFalse:[ interpreter 
					throwExceptionWithMessage: 'Closure used as parameter in filter should return a Boolean' ].
			aMaybeBoolean asBoolean ])
]

{ #category : #'native methods' }
WollokLangSet >> fold: aWollokSet with: anInitialValue with: aWollokClosure [ 

	aWollokClosure wollokClass = (interpreter resolve: 'wollok.lang.Closure')
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'The second argument should be a closure' ].
		
	^ aWollokSet asCollection 
		inject: anInitialValue 
		into: [ :accum :anItem | 
			interpreter sendMessage: 'apply' 
				to: aWollokClosure withArguments: { accum. anItem } ]
]

{ #category : #'native methods' }
WollokLangSet >> remove: aWollokSet with: aWollokObject [ 

	^ aWollokSet unbox remove: aWollokObject
]

{ #category : #'native methods' }
WollokLangSet >> size: aWollokInmediate [ 
	
	^ interpreter asWollokNumber: aWollokInmediate unbox size
]
