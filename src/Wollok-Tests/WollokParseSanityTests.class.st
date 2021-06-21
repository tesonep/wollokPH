Class {
	#name : #WollokParseSanityTests,
	#superclass : #AbstractWollokSmokeTests,
	#category : #'Wollok-Tests'
}

{ #category : #'building suites' }
WollokParseSanityTests class >> testParameters [ 

	| directory aMatrix |
	
	aMatrix := ParametrizedTestMatrix new.

	directory := WollokLoader current sanityTestsRootDirectory.

	directory allChildren 
		select: [ :e | #( 'wlk' 'wtest' 'wpgm' ) includes: e extension ]
		thenDo: [ :e | aMatrix addCase: { #fileToTest -> e }]. 

	^ aMatrix
]
