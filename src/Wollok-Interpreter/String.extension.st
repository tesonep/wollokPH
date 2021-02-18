Extension { #name : #String }

{ #category : #'*Wollok-Interpreter' }
String >> asWollokQualifiedName [
	
	^ WollokQualifiedName fromString: self
]
