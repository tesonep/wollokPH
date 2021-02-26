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
	
	^ object ifNil: [ 
			object := wollokClass basicInstantiate: interpreter.
		
			wollokClass
				runConstructorOn: object 
				parameters: Dictionary new
				allVariables: wollokClass allVariables
				interpreter: interpreter.
				
			object]
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
