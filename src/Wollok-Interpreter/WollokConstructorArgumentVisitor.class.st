Class {
	#name : #WollokConstructorArgumentVisitor,
	#superclass : #Object,
	#instVars : [
		'interpreter'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #'extracting arguments' }
WollokConstructorArgumentVisitor class >> extractArguments: arguments using: anInterpreter [

	| visitor |

	visitor := self new 
			interpreter: anInterpreter;
			yourself.
			
	^ arguments acceptVisitor: visitor
			
]

{ #category : #accessing }
WollokConstructorArgumentVisitor >> interpreter: aWollokInterpreter [ 
	
	interpreter := aWollokInterpreter 
]

{ #category : #visiting }
WollokConstructorArgumentVisitor >> visitAssignment: aNode [ 

	^ aNode variable name value -> (aNode value acceptVisitor: interpreter)
	
]

{ #category : #visiting }
WollokConstructorArgumentVisitor >> visitPositionalArgumentsList: aNode [

	| arguments associations |
	arguments := Dictionary new.
	
	associations := aNode values
		do: [ :anArgument | arguments add: (anArgument acceptVisitor: self) ].
		
	^ arguments 
		

]
