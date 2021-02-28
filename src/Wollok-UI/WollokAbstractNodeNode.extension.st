Extension { #name : #WollokAbstractNodeNode }

{ #category : #'*Wollok-UI' }
WollokAbstractNodeNode >> gtInspectorSourceCodeIn: composite [
	<gtInspectorPresentationOrder: 30> 

	^ composite text
		title: [ 'Source code' translated ];
		display: [ self source ];
		initialize: [ :presentation | 
			presentation selectionInterval: self sourceInterval ];
		when: [ self source notNil ]
]

{ #category : #'*Wollok-UI' }
WollokAbstractNodeNode >> gtInspectorTreeIn: composite [
	<gtInspectorPresentationOrder: 30> 
	^ (GTSimpleSmaCCTreeBrowser new treeIn: composite)
		title: [ 'Tree' translated ]
]
