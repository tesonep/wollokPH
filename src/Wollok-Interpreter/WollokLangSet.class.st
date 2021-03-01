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
WollokLangSet >> equals: aWollokInmediate with: aWollokObject [ 

	aWollokInmediate wollokClass = aWollokObject wollokClass
		ifFalse: [ ^ interpreter falseObject ].
		
	^ interpreter asWollokBoolean: (aWollokInmediate unbox = aWollokObject unbox)
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
