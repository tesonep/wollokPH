Class {
	#name : #WollokNativeObject,
	#superclass : #Object,
	#instVars : [
		'interpreter'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #executing }
WollokNativeObject >> activateNativeContext: aWollokContext [ 
	
	| arguments selector returnValue |
 
		"The first argument is the receiver, and then the arguments of the message"
		arguments := Array new: 1 + aWollokContext arguments size.
		arguments at: 1 put: aWollokContext receiver.
		aWollokContext method parameters 
			withIndexDo: [ :each :index | arguments at: index + 1 put: (aWollokContext arguments at: each parameter value) ].
			
		selector := (self convertSymbolSelector: aWollokContext method name value asSymbol) numArgs: arguments size.

		returnValue := (self perform: selector withArguments: arguments).
		
		aWollokContext returnValue:(returnValue = self ifTrue: [ interpreter voidObject ] ifFalse: [ returnValue ])
]

{ #category : #utils }
WollokNativeObject >> checkIntegerNumber: aMaybeWollokNumber name: aName [ 

	self checkNumber: aMaybeWollokNumber name: aName.
		
	aMaybeWollokNumber asNumber = aMaybeWollokNumber asNumber asInteger
		ifFalse: [ interpreter throwExceptionWithMessage: 'Parameter ' , aName , ' should be an integer number'].	
]

{ #category : #utils }
WollokNativeObject >> checkNumber: aMaybeWollokNumber name: aName [

	aMaybeWollokNumber wollokClass = interpreter numberClass
		ifFalse: [ interpreter
				throwExceptionWithMessage: 'Parameter ' , aName , ' should be a number' ]
]

{ #category : #symbols }
WollokNativeObject >> convertSymbolSelector: aSymbol [ 

	aSymbol isBinary ifFalse: [ ^ aSymbol ].
	
	^ {
			#'==' 	-> #equals.
			#'===' -> #doubleEquals.
			#/			-> #division.
			#* 		-> #multiply.
			#+ 		-> #add.
			#-			-> #minus.
			#**		-> #raiseTo.
			#< 		-> #lowerThan.
			#> 		-> #greaterThan.
			#% 		-> #modulo } asDictionary at: aSymbol
]

{ #category : #accessing }
WollokNativeObject >> interpreter: aWollokInterpreter [ 

	interpreter := aWollokInterpreter
]
