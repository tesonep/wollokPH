Class {
	#name : #WollokConstructorArguments,
	#superclass : #Object,
	#instVars : [
		'interpreter',
		'namedArguments',
		'positionalArguments'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #'extracting arguments' }
WollokConstructorArguments class >> empty [

	^ self new
]

{ #category : #'extracting arguments' }
WollokConstructorArguments class >> extractArguments: arguments using: anInterpreter [

	| visitor |

	visitor := self new 
			interpreter: anInterpreter;
			yourself.
	
	arguments ifNotNil:[arguments acceptVisitor: visitor].
	
	^ visitor		
]

{ #category : #accessing }
WollokConstructorArguments >> initialize [

	super initialize.
	namedArguments := Dictionary new.
	positionalArguments := OrderedCollection new.
]

{ #category : #accessing }
WollokConstructorArguments >> interpreter: aWollokInterpreter [ 
	
	interpreter := aWollokInterpreter 
]

{ #category : #accessing }
WollokConstructorArguments >> namedArguments [
	^ namedArguments
]

{ #category : #accessing }
WollokConstructorArguments >> positionalArguments [
	^ positionalArguments
]

{ #category : #visiting }
WollokConstructorArguments >> visitAssignment: aNode [

	namedArguments
		at: aNode variable name value
		put: (aNode value acceptVisitor: interpreter)
]

{ #category : #'as yet unclassified' }
WollokConstructorArguments >> visitBinaryOperation: aWollokBinaryOperationNode [

	^ self visitExpression: aWollokBinaryOperationNode 
]

{ #category : #visiting }
WollokConstructorArguments >> visitExpression: anExpressionNode [
	
	positionalArguments add: (anExpressionNode acceptVisitor: interpreter)
]

{ #category : #visiting }
WollokConstructorArguments >> visitMemberFeatureCall: aWollokMemberFeatureCallNode [ 
	
	^ self visitExpression: aWollokMemberFeatureCallNode
]

{ #category : #visiting }
WollokConstructorArguments >> visitNumberLiteral: aWollokNumberLiteralNode [ 

	positionalArguments add: (aWollokNumberLiteralNode acceptVisitor: interpreter)
]

{ #category : #visiting }
WollokConstructorArguments >> visitPositionalArgumentsList: aNode [

	aNode values do: [ :anArgument | anArgument acceptVisitor: self ]
]

{ #category : #visiting }
WollokConstructorArguments >> visitStringLiteral: aWollokStringLiteralNode [ 
	
	positionalArguments add: (aWollokStringLiteralNode acceptVisitor: interpreter)
]

{ #category : #visiting }
WollokConstructorArguments >> visitVariable: aWollokVariableNode [ 
	
	^ self visitExpression: aWollokVariableNode
]
