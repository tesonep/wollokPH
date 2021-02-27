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
WollokLangList >> fold: aWollokList with: anInitialValue with: aWollokClosure [ 

	^ aWollokList asCollection 
		inject: anInitialValue 
		into: [ :accum :anItem | 
			interpreter sendMessage: 'apply' 
				to: aWollokClosure withArguments: { accum. anItem } ]
]

{ #category : #'native methods' }
WollokLangList >> get: aReceiver with: aWollokNumber [

	^ aReceiver asCollection at: aWollokNumber asNumber + 1
]

{ #category : #'native methods' }
WollokLangList >> size: aWollokInmediate [ 

	^ interpreter asWollokNumber: (aWollokInmediate instanceVariables at: 1) size
]
