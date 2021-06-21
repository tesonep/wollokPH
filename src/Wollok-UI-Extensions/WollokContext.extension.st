Extension { #name : #WollokContext }

{ #category : #'*Wollok-UI-Extensions' }
WollokContext >> gtInspectorSourceCodeIn: composite [
	<gtInspectorPresentationOrder: 1> 

	^ composite text
		title: [ 'Source code' translated ];
		display: [ self source ];
		when: [ self source notNil ]
]

{ #category : #'*Wollok-UI-Extensions' }
WollokContext >> source [

	^ method source
]
