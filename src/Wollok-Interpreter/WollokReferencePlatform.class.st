Class {
	#name : #WollokReferencePlatform,
	#superclass : #WollokPlatform,
	#category : #'Wollok-Interpreter'
}

{ #category : #'as yet unclassified' }
WollokReferencePlatform >> newInterpreterWithRootFileNode: aFileNode [

	| interpreter rootPackage |

	interpreter := WollokInterpreter new.

	rootPackage := WollokLoader new
		interpreter: interpreter;
		rootFile: aFileNode;
		load.
	interpreter rootPackage: rootPackage.

	^ interpreter
]

{ #category : #'as yet unclassified' }
WollokReferencePlatform >> wollokRepositoryDirectory [

	^ FileLocator localDirectory / 'iceberg' / 'wollok-language'
]
