Class {
	#name : #WollokAnonymousClass,
	#superclass : #Object,
	#instVars : [
		'ast',
		'creationContext',
		'superclass'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokAnonymousClass >> ast [
	^ ast
]

{ #category : #accessing }
WollokAnonymousClass >> ast: anObject [
	ast := anObject
]

{ #category : #accessing }
WollokAnonymousClass >> creationContext: aWollokPackage [ 

	creationContext := aWollokPackage
]

{ #category : #instantiation }
WollokAnonymousClass >> instantiateUsing: aWollokInterpreter [ 

	^ WollokObject new
			wollokClass: self;
			yourself
]

{ #category : #accessing }
WollokAnonymousClass >> superclass [
	
	^ superclass 
]

{ #category : #accessing }
WollokAnonymousClass >> superclass: aWollokClass [ 
	superclass := aWollokClass
]
