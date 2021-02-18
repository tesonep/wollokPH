Class {
	#name : #WollokInterpreter,
	#superclass : #Object,
	#instVars : [
		'rootPackage',
		'parser',
		'creationContextStack'
	],
	#category : #'Wollok-Interpreter'
}

{ #category : #parameters }
WollokInterpreter class >> libraryExtension [
	
	^ 'wlk'
]

{ #category : #'as yet unclassified' }
WollokInterpreter class >> libraryRootDirectory [

	^ '/Users/admin/dev/wollok/wollok-language/src' asFileReference
]

{ #category : #'anonymous classes' }
WollokInterpreter >> createAnonymousClasssForNamedObjectLiteral: aWollokObjectLiteralNode [ 

	| superclassName superclass |
	
	superclassName := aWollokObjectLiteralNode superclass ifNil: [WollokClass defaultSuperclassName].

	superclass := self creationContext resolve: superclassName.

	^ WollokAnonymousClass new 
		ast: aWollokObjectLiteralNode;
		creationContext: self creationContext;
		superclass: superclass;
		yourself
]

{ #category : #'anonymous classes' }
WollokInterpreter >> createAnonymousClasssForObjectLiteral: aWollokObjectLiteralNode [ 

	| superclassName superclass |
	
	superclassName := aWollokObjectLiteralNode superclass ifNil: [WollokClass defaultSuperclassName].

	superclass := self creationContext resolve: superclassName.

	^ WollokAnonymousClass new 
		ast: aWollokObjectLiteralNode;
		creationContext: self creationContext;
		superclass: superclass;
		yourself
]

{ #category : #'creation context' }
WollokInterpreter >> creationContext [

	^ creationContextStack top
]

{ #category : #packages }
WollokInterpreter >> ensurePackageFor: aWollokFileNode [ 
	
	| fullyQualifiedName |
	
	fullyQualifiedName := self fullPackageNameFor: aWollokFileNode.
	
	^ (self ensurePackageNamed: fullyQualifiedName)
			fileNode: aWollokFileNode;
			yourself.
]

{ #category : #packages }
WollokInterpreter >> ensurePackageNamed: aWollokQualifiedName [
	| currentPackage |

	currentPackage := self rootPackage.

	aWollokQualifiedName segments
		do: [ :aSegment | currentPackage := currentPackage ensurePackage: aSegment ].
		
	^ currentPackage
]

{ #category : #packages }
WollokInterpreter >> fullPackageNameFor: aWollokFileNode [ 

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
WollokInterpreter >> initialize [

	super initialize.
	creationContextStack := Stack new
]

{ #category : #initialization }
WollokInterpreter >> initializeWithMainLibrary [
	
	| allFiles |
	allFiles := self class libraryRootDirectory 
		allChildren select: [ :aChild | aChild isFile ].

	allFiles do: [ :aFile | self loadFile: (self parser parseFile: aFile) ].
]

{ #category : #interpreting }
WollokInterpreter >> interpretProgram: aWollokFileNode [ 

	| package lastValue |

	self assert: aWollokFileNode isProgram.
	package := self ensurePackageFor: aWollokFileNode.
	
	package initializeStateUsing: self.

	self pushCreationContext: package.

	aWollokFileNode main elements do: [ :anExpression |
		lastValue := anExpression acceptVisitor: self ].
	
	self popCreationContext.
	
	^ lastValue
]

{ #category : #activation }
WollokInterpreter >> loadFile: aFileNode [

	| aPackage |

	self assert: aFileNode isLibrary.
	self assert: aFileNode tests isEmpty.
	self assert: aFileNode suites isEmpty.
	self assert: aFileNode main isNil.
	
	aPackage := self ensurePackageFor: aFileNode.
	aPackage fileNode: aFileNode.
	
	aFileNode elements do: [ :anElement | anElement acceptVisitor: aPackage ]
]

{ #category : #accessing }
WollokInterpreter >> parser [
	
	^ parser ifNil: [ parser := WollokParser ]
]

{ #category : #'creation context' }
WollokInterpreter >> popCreationContext [
	
	creationContextStack pop
]

{ #category : #'creation-context' }
WollokInterpreter >> pushCreationContext: aCreationContext [
 
	creationContextStack push: aCreationContext
]

{ #category : #resolving }
WollokInterpreter >> resolve: aString [ 
	
	| qualifiedName currentElement |
	
	qualifiedName := WollokQualifiedName fromString: aString.
	
	currentElement := self rootPackage.
	
	qualifiedName segments do: [ :aSegment | 
		currentElement := currentElement at: aSegment ifAbsent: [ ^ nil ]].
	
	^ currentElement 
]

{ #category : #accessing }
WollokInterpreter >> rootPackage [

	^ rootPackage
		ifNil: [ rootPackage := WollokPackage named: 'ROOT' parent: nil ]
]

{ #category : #accessing }
WollokInterpreter >> rootPaths [
	
	^ { self class libraryRootDirectory asAbsolute asPath }
]

{ #category : #visiting }
WollokInterpreter >> visitObjectLiteral: aWollokObjectLiteralNode [

	| anAnonymousClass |
	anAnonymousClass := self createAnonymousClasssForObjectLiteral: aWollokObjectLiteralNode.
	^ anAnonymousClass instantiateUsing: self.

]
