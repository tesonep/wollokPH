Class {
	#name : #WollokGameObject,
	#superclass : #WollokNativeObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokGameObject class >> wollokClassName [ 

	^ 'wollok.game._gameClass'
]

{ #category : #'native methods' }
WollokGameObject >> doCellSize: aWollokGame with: aWollokInmediate [ 
	
	self checkNumber: aWollokInmediate name: 'cellsize'.
	self ensureInitialized: aWollokGame.
	aWollokGame instanceVariables at: 4 put: aWollokInmediate	
]

{ #category : #utils }
WollokGameObject >> ensureInitialized: aWollokGame [ 

	aWollokGame instanceVariables size = 0
		ifTrue: [ aWollokGame instanceVariables: { interpreter nullObject. interpreter nullObject. interpreter nullObject.
			interpreter nullObject. interpreter nullObject.} ]
]

{ #category : #'native methods' }
WollokGameObject >> ground: aWollokGame with: aWollokString [ 

	aWollokString wollokClass = interpreter stringClass
		ifFalse: [ interpreter throwExceptionWithMessage: 'Ground should be a String' ].
		
	self ensureInitialized: aWollokGame.
	aWollokGame instanceVariables at: 5 put: aWollokString
]

{ #category : #'native methods' }
WollokGameObject >> height: aWollokGame with: aWollokInmediate [ 
	
	self checkNumber: aWollokInmediate name: 'height'.
	self ensureInitialized: aWollokGame.
	aWollokGame instanceVariables at: 3 put: aWollokInmediate	
]

{ #category : #'native methods' }
WollokGameObject >> title: aWollokGame with: aWollokString [ 

	aWollokString wollokClass = interpreter stringClass
		ifFalse: [ interpreter throwExceptionWithMessage: 'Title should be a String' ].
		
	self ensureInitialized: aWollokGame.
	aWollokGame instanceVariables at: 1 put: aWollokString
]

{ #category : #'native methods' }
WollokGameObject >> width: aWollokGame with: aWollokInmediate [ 
	
	self checkNumber: aWollokInmediate name: 'width'.
	self ensureInitialized: aWollokGame.
	aWollokGame instanceVariables at: 2 put: aWollokInmediate	
]
