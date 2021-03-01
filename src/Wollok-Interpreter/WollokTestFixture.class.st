Class {
	#name : #WollokTestFixture,
	#superclass : #WollokRuntimeElement,
	#category : #'Wollok-Interpreter'
}

{ #category : #interpreting }
WollokTestFixture >> interpretOn: aWollokInterpreter [ 

	self ast elements do: [ :e | e acceptVisitor: aWollokInterpreter ].

]

{ #category : #testing }
WollokTestFixture >> isFixture [
	
	^ true
]

{ #category : #accessing }
WollokTestFixture >> parameters [
	
	"fixtures do not receive parameters"
	^#()
]
