Class {
	#name : #WollokLangBoolean,
	#superclass : #WollokNativeObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokLangBoolean class >> wollokClassName [

	^ 'wollok.lang.Boolean'
]

{ #category : #'native methods' }
WollokLangBoolean >> and: aWollokObject with: aWollokObject2 [ 
	
	^ self doubleAnd: aWollokObject with: aWollokObject2
]

{ #category : #'native objects' }
WollokLangBoolean >> doubleAnd: aWollokObject with: aWollokObject2 [ 
	
	^ (aWollokObject asBoolean and: [ aWollokObject2 asBoolean ])
		ifTrue: [ interpreter trueObject ]
		ifFalse: [ interpreter falseObject ]
]

{ #category : #'native methods' }
WollokLangBoolean >> doubleOr: aWollokObject with: aWollokObject2 [ 
	
	^ (aWollokObject asBoolean or: [ aWollokObject2 asBoolean ])
		ifTrue: [ interpreter trueObject ]
		ifFalse: [ interpreter falseObject ]
]

{ #category : #'native methods' }
WollokLangBoolean >> negate: aWollokObject [

	^ interpreter trueObject = aWollokObject
		ifTrue: [ interpreter falseObject ]
		ifFalse: [ interpreter trueObject ]
]

{ #category : #'native methods' }
WollokLangBoolean >> or: aWollokObject with: aWollokObject2 [ 
	
	^ self doubleOr: aWollokObject with: aWollokObject2
]
