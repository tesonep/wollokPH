Class {
	#name : #WollokMethod,
	#superclass : #WollokRuntimeElement,
	#instVars : [
		'methodClass'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokMethod >> expression [
	
	^ ast expression
]

{ #category : #accessing }
WollokMethod >> expressionReturns [
	
	^ ast expressionReturns 
]

{ #category : #testing }
WollokMethod >> hasNumberOfArguments: numberOfArguments [ 

	| mandatoryArguments varArgArguments |
	
	"If we have the exact number of argument nothing more is required"
	ast parameters size = numberOfArguments
		ifTrue: [ ^ true ].
		
	mandatoryArguments := ast parameters count: [ :e | e isVarArg isNil ].
	varArgArguments := ast parameters count: [ :e | e isVarArg isNotNil ].

	"If we have exactly the mandatory arguments it can go"	
	numberOfArguments = mandatoryArguments ifTrue: [ ^ true ].
	
	"If we have less than the mandatory arguments this is not the method"
	numberOfArguments < mandatoryArguments ifTrue: [ ^ false ].
	
	varArgArguments > 1 
		ifTrue: [ self error: 'I cannot handle more than one variadic arg' ].
	
	"If we have more than the mandatory arguments we should have a var arg"
	
	(numberOfArguments > mandatoryArguments and: [varArgArguments = 1]) 
		ifTrue: [ ^ true ].	
	
	^ false
]

{ #category : #accessing }
WollokMethod >> methodClass [
	
	^ methodClass
]

{ #category : #accessing }
WollokMethod >> methodClass: aWollokClass [
	
	methodClass := aWollokClass
]

{ #category : #accessing }
WollokMethod >> name [
	
	^ ast name value
]

{ #category : #accessing }
WollokMethod >> native [

	^ ast native 
]

{ #category : #accessing }
WollokMethod >> parameters [
	
	^ ast parameters
]
