Class {
	#name : #WollokMirrorObjectMirror,
	#superclass : #WollokNativeObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokMirrorObjectMirror class >> wollokClassName [

	^ 'wollok.mirror.ObjectMirror'
]

{ #category : #'native methods' }
WollokMirrorObjectMirror >> resolve: anInstance with: aWollokString [ 

	| mirroredInstance |
	
	aWollokString wollokClass = interpreter stringClass
		ifFalse: [ ^ interpreter throwExceptionWithMessage: 'Invalid String argument' ].
		
	mirroredInstance := anInstance instanceVariables at: 1.
	
	^ mirroredInstance resolve: aWollokString asPharoString
]
