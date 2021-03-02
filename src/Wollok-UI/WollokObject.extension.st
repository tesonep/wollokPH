Extension { #name : #WollokObject }

{ #category : #'*Wollok-UI' }
WollokObject >> gtInspectorVariablesIn: composite [
	<gtInspectorPresentationOrder: 1> 

	^ composite fastTable
		title: 'Wollok Inspector';
		display: [ self valueCollection ];
		column: 'Name' evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each key ];
		column: 'Value' evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each value ];
		send: [ :selection | 
			selection
				ifNil: [ nil ]
				ifNotNil: [ selection value ] ]
]

{ #category : #'*Wollok-UI' }
WollokObject >> valueCollection [

	^ { 'self' -> self }, 
			(self wollokClass allVariables
				with: instanceVariables
				collect: [ :n :v | n key variable name value -> v ])
]
