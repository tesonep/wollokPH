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
	
	^ aWollokDictionary unbox at: aKey ifAbsent: [ 
		interpreter nullObject ]
]

{ #category : #'native methods' }
WollokLangDictionary >> clear: aWollokObject [ 
	
	aWollokObject unbox removeAll.
	^ interpreter voidObject
]

{ #category : #'native methods' }
WollokLangDictionary >> forEach: aWollokObject with: aWollokClosure [ 

	aWollokObject unbox keysAndValuesDo: [ :k :v |
		interpreter
			sendMessage: 'apply'
			to: aWollokClosure
			withArguments: { k . v }].
	^ interpreter voidObject
]

{ #category : #'native methods' }
WollokLangDictionary >> initialize: aWollokObject [ 
	
	aWollokObject instanceVariables: { Dictionary new }
]

{ #category : #'native methods' }
WollokLangDictionary >> keys: aWollokObject [ 
	
	^ interpreter asWollokList: aWollokObject unbox keys
]

{ #category : #'native methods' }
WollokLangDictionary >> put: aWollokDictionary with: aKey with: aValue [ 
	
	aWollokDictionary unbox at: aKey put: aValue.
	^ aWollokDictionary
]

{ #category : #'native methods' }
WollokLangDictionary >> remove: aWollokObject with: aWollokInmediate [ 
	
	aWollokObject unbox removeKey: aWollokInmediate ifAbsent: [ "Nothing" ].
	^ interpreter voidObject
]

{ #category : #'native methods' }
WollokLangDictionary >> values: aWollokObject [ 
	
	^ interpreter asWollokList: aWollokObject unbox values
]
