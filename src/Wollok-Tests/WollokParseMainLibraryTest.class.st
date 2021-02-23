Class {
	#name : #WollokParseMainLibraryTest,
	#superclass : #AbstractWollokSmokeTests,
	#category : #'Wollok-Tests'
}

{ #category : #'building suites' }
WollokParseMainLibraryTest class >> testParameters [ 

	| directory aMatrix |
	
	aMatrix := ParametrizedTestMatrix new.

	directory := WollokLoader libraryRootDirectory.

	directory allChildren 
		select: [ :e | #( 'wlk' 'wtest' 'wpgm' ) includes: e extension ]
		thenDo: [ :e | aMatrix addCase: { #fileToTest -> e }]. 

	^ aMatrix
]
