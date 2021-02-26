Class {
	#name : #WollokLangDate,
	#superclass : #WollokNativeObject,
	#category : #'Wollok-Interpreter'
}

{ #category : #accessing }
WollokLangDate class >> wollokClassName [

	^ 'wollok.lang.Date'
]

{ #category : #converting }
WollokLangDate >> asWollokDate: aDate [ 
	
	| dateClass |

	dateClass := interpreter currentContext resolve: 'wollok.lang.Date'.

	^ aDate dayMonthYearDo: [ :d :m :y |
			WollokObject new 
				wollokClass: dateClass;
				instanceVariables: {d. m. y};
				yourself	].



]

{ #category : #'native methods' }
WollokLangDate >> equals: aReceiver with: otherObject [

	otherObject wollokClass = otherObject wollokClass 
		ifFalse: [ ^ interpreter falseObject ].
		
	^ interpreter asWollokBoolean: (aReceiver instanceVariables collect: [:e | e asNumber]) = (otherObject instanceVariables collect: [:e | e asNumber])
]

{ #category : #'native methods' }
WollokLangDate >> greaterThan: aReceiver with: anotherDate [ 

	^ interpreter asWollokBoolean: aReceiver asDate > anotherDate asDate
]

{ #category : #'native methods' }
WollokLangDate >> initialize: anInstance [ 
	

	"If the constants are not initialized we need to init them"
	(anInstance instanceVariables allSatisfy: [ :e | interpreter nullObject = e ])
		ifTrue: [ Date today dayMonthYearDo: [ :d :m :y | 
							anInstance instanceVariables at: 1 put: (interpreter asWollokNumber: d).
							anInstance instanceVariables at: 2 put: (interpreter asWollokNumber: m).
							anInstance instanceVariables at: 3 put: (interpreter asWollokNumber: y)]]
]

{ #category : #'native methods' }
WollokLangDate >> internalDayOfWeek: aWollokDate [
	
	"/** Answers the day of week of the Date, where
   * 1 = MONDAY
   * 2 = TUESDAY
   * 3 = WEDNESDAY
   * ...
   * 7 = SUNDAY
   *
   * Example:
   *     new Date(day = 24, month = 2, year = 2018).internalDayOfWeek() ==> Answers 6 (SATURDAY)
   */"
	
	| dayOfWeek |

	dayOfWeek := aWollokDate asDate dayOfWeek - 1.
	dayOfWeek := dayOfWeek = 0 ifTrue: [ 7 ] ifFalse: [ dayOfWeek ].
	
	^ interpreter asWollokNumber: dayOfWeek
]

{ #category : #'native methods' }
WollokLangDate >> isLeapYear: aReceiver [
	
	^ interpreter asWollokBoolean: (aReceiver asDate isLeapYear)
]

{ #category : #'native methods' }
WollokLangDate >> lowerThan: aReceiver with: anotherDate [

	^ interpreter asWollokBoolean: aReceiver asDate < anotherDate asDate
]

{ #category : #'native methods' }
WollokLangDate >> minus: aWollokDate with: anotherWollokDate [ 

	^ interpreter asWollokNumber: (aWollokDate asDate - anotherWollokDate asDate) days
]

{ #category : #'native methods' }
WollokLangDate >> minusDays: aReceiver with: anWollokNumber [ 

	^ self asWollokDate: (aReceiver asDate addDays: anWollokNumber asNumber negated)
]

{ #category : #'native methods' }
WollokLangDate >> minusMonths: aWollokDate with: aWollokNumber [

	^ self asWollokDate: (aWollokDate asDate addMonths: aWollokNumber asNumber asInteger negated)
]

{ #category : #'native methods' }
WollokLangDate >> minusYears: aWollokDate with: aWollokNumber [ 

	^ self asWollokDate: (aWollokDate asDate addMonths: aWollokNumber asNumber * -12)

]

{ #category : #'native methods' }
WollokLangDate >> plusDays: aReceiver with: aWollokNumber [ 

	^ self asWollokDate: (aReceiver asDate addDays: aWollokNumber asNumber)
]

{ #category : #'native methods' }
WollokLangDate >> plusMonths: aWollokDate with: aWollokNumber [ 

	^ self asWollokDate: (aWollokDate asDate addMonths: aWollokNumber asNumber)
	
]

{ #category : #'native methods' }
WollokLangDate >> plusYears: aWollokDate with: aWollokNumber [ 
	
	^ self asWollokDate: (aWollokDate asDate addMonths: aWollokNumber asNumber * 12)
	
]

{ #category : #'native methods' }
WollokLangDate >> shortDescription: aWollokObject [ 

	^ interpreter asWollokString: ('{2}/{1}/{3}' format: (aWollokObject instanceVariables collect: #asNumber))
]
