Class {
	#name : #WollokConstructor,
	#superclass : #WollokRuntimeElement,
	#category : #'Wollok-Interpreter'
}

{ #category : #interpreting }
WollokConstructor >> interpretOn: aWollokInterpreter [ 
	
	aWollokInterpreter visitMaybeClosureAsBlock: self ast expression

]

{ #category : #accessing }
WollokConstructor >> parameters [
	
	^ ast parameters
]
