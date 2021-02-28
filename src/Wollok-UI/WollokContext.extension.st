Extension { #name : #WollokContext }

{ #category : #'*Wollok-UI' }
WollokContext >> gtInspectorSourceCodeIn: composite [
	<gtInspectorPresentationOrder: 1> 

	^ composite text
		title: [ 'Source code' translated ];
		display: [ self source ];
		when: [ self source notNil ]
]

{ #category : #'*Wollok-UI' }
WollokContext >> source [

	^ method source
]
