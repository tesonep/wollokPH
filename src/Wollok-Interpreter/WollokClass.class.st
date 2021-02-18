Class {
	#name : #WollokClass,
	#superclass : #WollokElement,
	#category : #'Wollok-Interpreter'
}

{ #category : #'default configuration' }
WollokClass class >> defaultSuperclassName [
	
	^ 'wollok.lang.Object'
]

{ #category : #initialization }
WollokClass >> initializeStateUsing: aWollokInterpreter [ 
	
	"Nothing to initialize here"
]

{ #category : #accessing }
WollokClass >> name [
	
	^ self ast name value
]
