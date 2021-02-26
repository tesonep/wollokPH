Class {
	#name : #WollokInmediate,
	#superclass : #WollokObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #comparing }
WollokInmediate >> = anotherObject [ 
	
	anotherObject species = self species ifFalse: [ ^ false ].
	
	^ (instanceVariables at: 1) = (anotherObject instanceVariables at: 1)
]

{ #category : #comparing }
WollokInmediate >> hash [ 
	
	^ (instanceVariables at: 1) hash
]

{ #category : #comparing }
WollokInmediate >> printOn: aStream [

	super printOn: aStream.
	aStream 
		nextPut: $(;
		print: (instanceVariables at: 1);
		nextPut: $)

]
