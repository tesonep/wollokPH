Class {
	#name : #BaselineOfWollokPH,
	#superclass : #BaselineOf,
	#category : #BaselineOfWollokPH
}

{ #category : #baselines }
BaselineOfWollokPH >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			
			spec
				baseline: 'SmaCC' 
				with: [
					spec
						loads: 'Runtime';
						repository: 'github://j-brant/Smacc:7aafca9' ].
			
			spec
				package: 'Wollok-Interpreter' with: [ spec requires: 'Wollok-Parser' ];
				package: 'Wollok-Parser' with: [ spec requires: 'SmaCC' ];
				package: 'Wollok-Tests' with: [ spec requires: 'Wollok-Interpreter' ];
				package: 'Wollok-UI' with: [ spec requires: 'Wollok-Interpreter' ];
				package: 'Wollok-UI-Extensions' with: [ spec requires: 'Wollok-Interpreter' ]				]
]
