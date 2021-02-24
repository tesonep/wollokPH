Class {
	#name : #WollokContext,
	#superclass : #Object,
	#instVars : [
		'sender',
		'receiver',
		'selector',
		'method',
		'arguments',
		'hasReturned',
		'returnValue'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokContext >> arguments [
	^ arguments
]

{ #category : #accessing }
WollokContext >> arguments: value [ 

	| keys remainingArguments |

	arguments := Dictionary new.
	remainingArguments := value copy.

	method parameters do: [ :aParameter |
		aParameter isVarArg 
			ifNil: [ 
				arguments at: aParameter parameter value put: remainingArguments first.
				remainingArguments := remainingArguments allButFirst ] 
			ifNotNil: [ 
				"Variable parameter consume all remaining arguments"
				arguments at: aParameter parameter value put: remainingArguments.
				remainingArguments := #()]]
]

{ #category : #testing }
WollokContext >> hasReturned [
	
	^ hasReturned 
]

{ #category : #accessing }
WollokContext >> initialize [

	super initialize.

	hasReturned := false.
	arguments := Dictionary new.
]

{ #category : #accessing }
WollokContext >> method [
	^ method
]

{ #category : #accessing }
WollokContext >> method: aWollokMethod [ 

	method := aWollokMethod
	
]

{ #category : #accessing }
WollokContext >> receiver [
	^ receiver
]

{ #category : #accessing }
WollokContext >> receiver: anObject [ 
	receiver := anObject
]

{ #category : #resolving }
WollokContext >> resolve: aString [ 
	
	arguments at: aString ifPresent: [ :aValue | ^ aValue ].	
	^ receiver resolve: aString
]

{ #category : #accessing }
WollokContext >> returnValue [
	^ returnValue
]

{ #category : #accessing }
WollokContext >> returnValue: aWollokObject [ 
	
	returnValue := aWollokObject 
]

{ #category : #accessing }
WollokContext >> selector: aString [ 
	selector := aString
]

{ #category : #accessing }
WollokContext >> sender: anUndefinedObject [ 
	sender := anUndefinedObject
]
