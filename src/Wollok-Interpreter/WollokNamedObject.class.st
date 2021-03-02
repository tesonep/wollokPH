Class {
	#name : #WollokNamedObject,
	#superclass : #WollokRuntimeElement,
	#instVars : [
		'object',
		'wollokClass',
		'interpreter'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokNamedObject >> assignedValue [
	
	^ object ifNil: [ | arguments |

		"should be executed here because it may be recursive"
		object := wollokClass basicInstantiate: interpreter.
		
		arguments := WollokConstructorArguments 
			extractArguments: self ast parentParameters
			using: interpreter.
		
		wollokClass 
			runConstructorOn: object
			arguments: arguments
			allVariables: wollokClass allVariables
			interpreter: interpreter.

		object ]
]

{ #category : #initialization }
WollokNamedObject >> initializeStateUsing: anInterpreter [ 
	
	self assignedValue
]

{ #category : #accessing }
WollokNamedObject >> name [
	
	^ self ast name value
]

{ #category : #state }
WollokNamedObject >> resetState [
	
	object := nil
]

{ #category : #initialization }
WollokNamedObject >> resolveBindingsUsing: anInterpreter [ 
	
	interpreter := anInterpreter.
	wollokClass := anInterpreter createAnonymousClasssForNamedObjectLiteral: ast
]
