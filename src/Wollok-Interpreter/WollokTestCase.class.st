Class {
	#name : #WollokTestCase,
	#superclass : #WollokRuntimeElement,
	#category : #'Wollok-Interpreter'
}

{ #category : #interpreting }
WollokTestCase >> interpretOn: aWollokInterpreter [ 
	
	self ast elements do: [ :e | e acceptVisitor: aWollokInterpreter ].

]

{ #category : #accessing }
WollokTestCase >> name [
	
	^ ast name value value
]

{ #category : #accessing }
WollokTestCase >> parameters [
	"Tests have no parameters"
	^ #()
]

{ #category : #initialization }
WollokTestCase >> resolveBindingsUsing: aWollokInterpreter [ 

	
]
