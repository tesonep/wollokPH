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
WollokLangNumber >> doubleEquals: aWollokObject with: aWollokObject2 [ 

	^ aWollokObject asNumber = aWollokObject2 asNumber
			ifTrue: [ interpreter trueObject ]
			ifFalse: [ interpreter falseObject ]
]
