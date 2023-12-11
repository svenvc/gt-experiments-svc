Extension { #name : #DataSeries }

{ #category : #'*GToolkit4Dataframe' }
DataSeries >> gtViewHeadFor: composite [
	<gtView>
	self isEmpty ifNil: [ ^ composite empty ].
	self size <= 100 ifTrue: [ ^ composite empty ].
	^ composite forward
		title: 'Head';
		priority: 36;
		object: [ self head ];
		view: #gtViewSeriesFor:
]

{ #category : #'*GToolkit4Dataframe' }
DataSeries >> gtViewSeriesFor: composite [
	<gtView>
	self isEmpty ifNil: [ ^ composite empty ].
	self size > 100 ifTrue: [ ^ composite empty ].
	^ composite columnedList
		title: 'Series';
		priority: 35;
		items: [ { #name->self name } , self associations ];
		column: '#' text: [ :_ :position | position asRopedText foreground: Color gray ] weight: 1;
		column: 'Key' text: #key weight: 2;
		column: 'Value' text: #value weight: 3
]

{ #category : #'*GToolkit4Dataframe' }
DataSeries >> gtViewSummaryFor: composite [
	<gtView>
	self isEmpty ifNil: [ ^ composite empty ].
	self isNumerical ifFalse: [ ^ composite empty ].
	^ composite forward
		title: 'Summary';
		priority: 40;
		object: [ self summary ];
		view: #gtViewSeriesFor:
]

{ #category : #'*GToolkit4Dataframe' }
DataSeries >> gtViewTailFor: composite [
	<gtView>
	self isEmpty ifNil: [ ^ composite empty ].
	self size <= 100 ifTrue: [ ^ composite empty ].
	^ composite forward
		title: 'Tail';
		priority: 37;
		object: [ self tail ];
		view: #gtViewSeriesFor:
]
