Class {
	#name : #WollokParseSanityTests,
	#superclass : #AbstractWollokSmokeTests,
	#category : #'Wollok-Tests'
}

{ #category : #'building suites' }
WollokParseSanityTests class >> testParameters [ 

	| directory aMatrix |
	
	aMatrix := ParametrizedTestMatrix new.

	directory := '/Users/admin/dev/wollok/wollok-language/test/sanity' asFileReference.

	directory allChildren 
		select: [ :e | #( 'wlk' 'wtest' 'wpgm' ) includes: e extension ]
		thenDo: [ :e | aMatrix addCase: { #fileToTest -> e }]. 

	^ aMatrix
]
