Class {
	#name : #WollokQualifiedName,
	#superclass : #Object,
	#instVars : [
		'segments'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #'instance creation' }
WollokQualifiedName class >> empty [
	
	^ self from: #()
]

{ #category : #'instance creation' }
WollokQualifiedName class >> from: someSegments [
	
	^ self new 
			segments: someSegments;
			yourself
]

{ #category : #'instance creation' }
WollokQualifiedName class >> fromString: aString [ 
	
	^ self from: (aString splitOn: '.') asArray
]

{ #category : #concatenating }
WollokQualifiedName >> , aWollokQualifiedName [ 
	
	^ self class from: (self segments , aWollokQualifiedName segments)
]

{ #category : #accessing }
WollokQualifiedName >> = anotherOne [

	anotherOne species = self species ifFalse: [ ^ false ].
	^ anotherOne segments = self segments 
]

{ #category : #accessing }
WollokQualifiedName >> asString [
	
	segments ifEmpty: [ ^ 'ROOT' ].
	^ segments joinUsing: '.'
]

{ #category : #converting }
WollokQualifiedName >> asWollokQualifiedName [
	
	^ self
]

{ #category : #copying }
WollokQualifiedName >> copyWithSegment: aString [ 
	
	| aCopy |
	aCopy := self copy.
	aCopy segments: (aCopy segments copyWith: aString).
	^ aCopy
]

{ #category : #copying }
WollokQualifiedName >> copyWithoutFirst [

	| aCopy |
	aCopy := self copy.
	aCopy segments: (aCopy segments allButFirst).
	^ aCopy
]

{ #category : #copying }
WollokQualifiedName >> copyWithoutLast [

	| aCopy |
	aCopy := self copy.
	aCopy segments: (aCopy segments allButLast).
	^ aCopy
]

{ #category : #accessing }
WollokQualifiedName >> hash [ 
	
	^ 31 + (segments sumNumbers: [ :e | e hash])
]

{ #category : #accessing }
WollokQualifiedName >> printOn: aStream [

	super printOn: aStream.
	aStream 
		nextPutAll: ' ( ';
		nextPutAll: self asString;
		nextPutAll: ' )'.
]

{ #category : #accessing }
WollokQualifiedName >> segments [
	^ segments
]

{ #category : #accessing }
WollokQualifiedName >> segments: aCollection [ 
	
	segments := aCollection 
]
