Class {
	#name : #WollokConstructor,
	#superclass : #WollokMethod,
	#category : #'Wollok-Interpreter'
}

{ #category : #interpreting }
WollokConstructor >> interpretOn: aWollokInterpreter [ 
	
	self ast delegatingConstructorCall ifNotNil: [ 
		^ self ast delegatingConstructorCall acceptVisitor: aWollokInterpreter.
	].
	
	self ast expression ifNotNil: [ 
		^ aWollokInterpreter visitMaybeClosureAsBlock: self ast expression ].
	
	
]

{ #category : #accessing }
WollokConstructor >> parameters [
	
	^ ast parameters
]
