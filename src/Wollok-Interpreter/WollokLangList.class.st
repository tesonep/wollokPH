Class {
	#name : #WollokLangList,
	#superclass : #WollokNativeObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokLangList class >> wollokClassName [

	^ 'wollok.lang.List'
]

{ #category : #'native methods' }
WollokLangList >> add: aWollokInmediate with: aWollokInmediate2 [ 
	
	^ aWollokInmediate unbox add: aWollokInmediate2
]

{ #category : #'native methods' }
WollokLangList >> clear: aWollokInmediate [ 
	
	^ aWollokInmediate box: OrderedCollection new
]

{ #category : #'native methods' }
WollokLangList >> contains: aWollokInmediate with: aWollokInmediate2 [ 
	
	^ interpreter asWollokBoolean: (aWollokInmediate unbox includes: aWollokInmediate2)
]

{ #category : #'native methods' }
WollokLangList >> equals: aWollokInmediate with: aWollokInmediate2 [ 
	
	(aWollokInmediate2 wollokClass = aWollokInmediate wollokClass)
		ifFalse: [ ^ interpreter falseObject ].
	
	^ interpreter asWollokBoolean: aWollokInmediate unbox = aWollokInmediate2 unbox
]

{ #category : #'native methods' }
WollokLangList >> filter: aWollokList with: aWollokClosure [ 

	^ interpreter asWollokList: (aWollokList asCollection 
		select: [ :elem | 
			(interpreter sendMessage: 'apply' 
				to: aWollokClosure withArguments: { elem }) unbox ])
]

{ #category : #'native methods' }
WollokLangList >> findOrElse: aWollokList with: aWollokClosure with: aWollokClosure3 [ 

	^ aWollokList asCollection 
		detect: [ :elem | 
			(interpreter sendMessage: 'apply' 
				to: aWollokClosure withArguments: { elem }) unbox ]
		ifNone: [ interpreter sendMessage: 'apply' to: aWollokClosure3 withArguments: #() ]
]

{ #category : #'native methods' }
WollokLangList >> fold: aWollokList with: anInitialValue with: aWollokClosure [ 

	^ aWollokList asCollection copy
		inject: anInitialValue 
		into: [ :accum :anItem | 
			interpreter sendMessage: 'apply' 
				to: aWollokClosure withArguments: { accum. anItem } ]
]

{ #category : #'native methods' }
WollokLangList >> get: aReceiver with: aWollokNumber [

	| indexToUse |
	self checkIntegerNumber: aWollokNumber name: 'at'.

	indexToUse := aWollokNumber unbox asInteger + 1.

	indexToUse < 1
		ifTrue: [ interpreter throwExceptionWithMessage: 'Index out of bounds' ].

	indexToUse > aReceiver asCollection size
		ifTrue: [ interpreter throwExceptionWithMessage: 'Index out of bounds' ].

	^ aReceiver asCollection at: indexToUse
]

{ #category : #'native methods' }
WollokLangList >> join: aWollokInmediate with: aWollokInmediate2 [
	
	^ interpreter asWollokString: (aWollokInmediate2 unbox join: (aWollokInmediate unbox collect: [ :e | e unbox asString ]))
]

{ #category : #'native methods' }
WollokLangList >> max: aWollokInmediate [ 
	
	aWollokInmediate unbox isEmpty 
		ifTrue: [ interpreter throwExceptionWithMessage: 'Cannot calculate max value in an empty List' ].
		
	^ interpreter asWollokNumber: (aWollokInmediate unbox max: [ :a | a unbox ])
]

{ #category : #'native methods' }
WollokLangList >> remove: aWollokInmediate with: aWollokInmediate2 [ 
	
	(aWollokInmediate unbox includes: aWollokInmediate2)
		ifFalse: [ self halt ].
	^ aWollokInmediate unbox remove: aWollokInmediate2
]

{ #category : #'native methods' }
WollokLangList >> size: aWollokInmediate [ 

	^ interpreter asWollokNumber: (aWollokInmediate instanceVariables at: 1) size
]

{ #category : #'native methods' }
WollokLangList >> sortBy: aWollokList with: aWollokClosure [ 
	
	"Sort in place"
	
	aWollokList asCollection 
		sort: [ :a :b | (interpreter sendMessage: 'apply' to: aWollokClosure withArguments: { a . b }) unbox ].
	^ aWollokList
]

{ #category : #'native methods' }
WollokLangList >> withoutDuplicates: aWollokList [ 
	
	| original proccessed |
	original := aWollokList unbox.
	proccessed := Set new.
	
	^ interpreter asWollokList: (original select: [ :e | | toInclude |
		toInclude := (proccessed includes: e) not.
		proccessed add: e.
		toInclude ]).
	
	
]
