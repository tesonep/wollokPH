Class {
	#name : #WollokLoader,
	#superclass : #Object,
	#instVars : [
		'interpreter',
		'rootFile',
		'parser',
		'rootPackage',
		'packageStack',
		'loadedPackages'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #parameters }
WollokLoader class >> libraryExtension [
	
	^ 'wlk'
]

{ #category : #'as yet unclassified' }
WollokLoader class >> libraryRootDirectory [

	^ '/Users/admin/dev/wollok/wollok-language/src' asFileReference
]

{ #category : #accessing }
WollokLoader >> currentPackage [
	
	^ 	packageStack top.
]

{ #category : #'file lookup' }
WollokLoader >> doFileLookup: aWollokPackage [ 

	| fqn currentFile |

	fqn := aWollokPackage fullyQualifiedName.	
	currentFile := self class libraryRootDirectory.
		
	fqn segments do: [ :aSegment | 
			currentFile := currentFile / aSegment..
			currentFile isDirectory ifFalse: [ 
				currentFile := currentFile withExtension: self class libraryExtension.
				currentFile exists ifFalse: [ self error: 'Couldn''t resolve ' , fqn printString ].
				^ currentFile ]  ].
		
	self error: 'Couldn''t resolve ' , fqn printString
]

{ #category : #packages }
WollokLoader >> ensurePackageNamed: aWollokQualifiedName [
	| currentPackage |

	currentPackage := self rootPackage.

	aWollokQualifiedName segments
		do: [ :aSegment | 
			currentPackage := currentPackage 
				at: aSegment 
				ifAbsentPut: [WollokPackage named: aSegment parent: currentPackage ]].
		
	^ currentPackage
]

{ #category : #imports }
WollokLoader >> fillDefaultImports: aWollokPackage [ 

	| imports |

	imports := (aWollokPackage imports ifNil: [ Set new ]) , 
		{ 'wollok.lang' asWollokQualifiedName. 'wollok.lib' asWollokQualifiedName. }  asSet.
		
	aWollokPackage imports: imports
]

{ #category : #packages }
WollokLoader >> fullPackageNameFor: aWollokFileNode [ 

	| path rootPathToUse relativePath |

	"If it does not have filename we assume is root"
	aWollokFileNode filename 
		ifNil: [ ^ WollokQualifiedName empty ].

	path := aWollokFileNode filename withoutExtension asAbsolute asPath .
	rootPathToUse := self rootPaths detect: [ :aRoot | aRoot containsPath: path ].
	
	relativePath := path relativeToPath: rootPathToUse.
	
	^ WollokQualifiedName from: relativePath segments
]

{ #category : #initialization }
WollokLoader >> initialize [

	super initialize.
	
	packageStack := Stack new.
	loadedPackages := OrderedCollection new.

]

{ #category : #accessing }
WollokLoader >> interpreter: aWollokInterpreter [ 

	interpreter := aWollokInterpreter
]

{ #category : #loading }
WollokLoader >> load [
	
	"Ensure Root Package"
	self ensurePackageNamed: WollokQualifiedName empty.

	rootPackage fileNode: rootFile.
	self loadPackage: rootPackage.
	
	rootPackage initializeStateUsing: interpreter.
	^ rootPackage
]

{ #category : #loading }
WollokLoader >> loadPackage: aWollokPackage [ 

	(loadedPackages includes: aWollokPackage) 
		ifTrue: [ ^self ].

	aWollokPackage fileNode ifNil: [ 
		aWollokPackage fileNode: (self parser parseFile:(self doFileLookup: aWollokPackage)) ].
	
	packageStack push: aWollokPackage.
	aWollokPackage fileNode acceptVisitor: self.
	packageStack pop.

	loadedPackages add: aWollokPackage.
	
	self fillDefaultImports: aWollokPackage.
	
	aWollokPackage imports do: [ :anImport | self loadPackage: (self ensurePackageNamed: anImport) ].

]

{ #category : #accessing }
WollokLoader >> parser [
	
	^ parser ifNil: [ parser := WollokParser ]
]

{ #category : #accessing }
WollokLoader >> rootFile: aWollokFileNode [ 
	
	rootFile := aWollokFileNode
]

{ #category : #packages }
WollokLoader >> rootPackage [

	^ rootPackage
		ifNil: [ rootPackage := WollokPackage named: 'ROOT' parent: nil ]
]

{ #category : #loading }
WollokLoader >> visitClass: aWollokClassNode [ 

	^ WollokClass fromAST: aWollokClassNode
]

{ #category : #visiting }
WollokLoader >> visitFile: aWollokFileNode [ 
	
	aWollokFileNode imports do: [ :e | e acceptVisitor: self ].

	aWollokFileNode elements do: [ :e | self currentPackage add: (e acceptVisitor: self) ].
	aWollokFileNode tests do: [ :e | self currentPackage defaultSuite addTest: (e acceptVisitor: self) ].
	aWollokFileNode suites do: [ :e | self currentPackage addSuite: (e acceptVisitor: self) ].

	aWollokFileNode main ifNotNil: [ :e | |aMain|
		aMain := e acceptVisitor: self.
		aMain parent: self currentPackage.
		self currentPackage main: aMain ]
]

{ #category : #loading }
WollokLoader >> visitNamedObject: aWollokNamedObjectNode [ 

	^ WollokNamedObject fromAST: aWollokNamedObjectNode
	
]

{ #category : #visiting }
WollokLoader >> visitProgram: aWollokProgramNode [ 

	^ WollokMainProgram fromAST: aWollokProgramNode
]

{ #category : #loading }
WollokLoader >> visitSuite: aWollokSuiteNode [ 

	| aSuite | 

	aSuite := WollokTestSuite fromAST: aWollokSuiteNode.
	aSuite tests: (aWollokSuiteNode tests collect: [:e | e acceptVisitor: self]).
	aSuite tests do: [ :e | e parent: aSuite ].
	
	aWollokSuiteNode fixture ifNotNil: [ self notYetImplemented  ].
	
	^ aSuite
]

{ #category : #visiting }
WollokLoader >> visitTest: aWollokTestNode [ 

	^ WollokTestCase fromAST: aWollokTestNode 
]

{ #category : #loading }
WollokLoader >> visitVariableDeclaration: aWollokVariableDeclarationNode [ 

	^ WollokPackageVariable fromAST: aWollokVariableDeclarationNode
]
