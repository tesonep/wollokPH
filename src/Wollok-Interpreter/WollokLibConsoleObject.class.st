Class {
	#name : #WollokLibConsoleObject,
	#superclass : #WollokNativeObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokLibConsoleObject class >> wollokClassName [ 

	^ 'wollok.lib._consoleClass'
]

{ #category : #'native methods' }
WollokLibConsoleObject >> newline: aWollokObject [

	 ^ interpreter asWollokString: OSPlatform current lineEnding
]
