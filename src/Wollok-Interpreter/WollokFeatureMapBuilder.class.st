Class {
	#name : #WollokFeatureMapBuilder,
	#superclass : #WollokInterpreter,
	#instVars : [
		'featureMap'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #visiting }
WollokFeatureMapBuilder >> activatePrimitiveMethod [
	
	| context nativeObject |
	
	context := self currentContext.
	nativeObject := context receiver wollokClass lookupNativeObjectForMethod: context method name.
	featureMap add: nativeObject class name, '>>', context method name.
	
	^ super activatePrimitiveMethod
]

{ #category : #accessing }
WollokFeatureMapBuilder >> featureMap [
	^ featureMap
]

{ #category : #accessing }
WollokFeatureMapBuilder >> initialize [

	super initialize.
	featureMap := Set new
]

{ #category : #visiting }
WollokFeatureMapBuilder >> lookupNativeObjectFor: aWollokClass [

	| nativeObject |
	nativeObject := super lookupNativeObjectFor: aWollokClass.
	nativeObject ifNotNil: [ featureMap add: aWollokClass name asSymbol ].
	^ nativeObject
]

{ #category : #visiting }
WollokFeatureMapBuilder >> lookupSelector: aString usingArguments: numberOfArguments [

	| found |
	found := super lookupSelector: aString usingArguments: numberOfArguments.
	found ifNil: [ featureMap add: #dnu ].
	^ found
]

{ #category : #visiting }
WollokFeatureMapBuilder >> sendMessage: aSelector to: aReceiver withArguments: arguments isSuperSend: aBoolean [

	featureMap add: #send.
	^ super sendMessage: aSelector to: aReceiver withArguments: arguments isSuperSend: aBoolean
]

{ #category : #visiting }
WollokFeatureMapBuilder >> throwException: aWollokObject [ 

	featureMap add: #exceptions.
	^ super throwException: aWollokObject 
]

{ #category : #visiting }
WollokFeatureMapBuilder >> visitCatch: aWollokCatchNode [ 

	featureMap add: #exceptions.
	^ super visitCatch: aWollokCatchNode 

]

{ #category : #visiting }
WollokFeatureMapBuilder >> visitClosure: aWollokClosureNode [ 

	featureMap add: #closures.
	^ super visitClosure: aWollokClosureNode
]

{ #category : #visiting }
WollokFeatureMapBuilder >> visitConstructorCall: aWollokConstructorCallNode [

	featureMap add: #constructors.
	^ super visitConstructorCall: aWollokConstructorCallNode
]

{ #category : #visiting }
WollokFeatureMapBuilder >> visitIfExpression: aWollokIfExpressionNode [ 

	featureMap add: #if.
	^ super visitIfExpression: aWollokIfExpressionNode 
]

{ #category : #visiting }
WollokFeatureMapBuilder >> visitSelfDelegatingConstructorCall: aWollokSelfDelegatingConstructorCallNode [ 

	featureMap add: #constructors.
	^ super visitSelfDelegatingConstructorCall: aWollokSelfDelegatingConstructorCallNode 
]

{ #category : #visiting }
WollokFeatureMapBuilder >> visitSuperDelegatingConstructorCall: aWollokSuperDelegatingConstructorCallNode [ 

	featureMap add: #constructors.
	^ super visitSuperDelegatingConstructorCall: aWollokSuperDelegatingConstructorCallNode 
]

{ #category : #visiting }
WollokFeatureMapBuilder >> visitSuperInvocation: invocation [ 

	featureMap add: #send.
	^ super visitSuperInvocation: invocation
]

{ #category : #visiting }
WollokFeatureMapBuilder >> visitThrow: aNode [

	featureMap add: #exceptions.
	^ super visitThrow: aNode
]

{ #category : #visiting }
WollokFeatureMapBuilder >> visitTry: aWollokTryNode [

	featureMap add: #exceptions.
	^ super visitTry: aWollokTryNode.
]
