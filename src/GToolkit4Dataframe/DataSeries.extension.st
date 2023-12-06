Extension { #name : #DataSeries }

{ #category : #'*GToolkit4Dataframe' }
DataSeries >> gtViewSeriesFor: composite [
	<gtView>
	self isEmpty ifNil: [ ^ composite empty ].
	^ composite columnedList
		title: 'Series';
		priority: 35;
		items: [ { #name->self name } , self associations ];
		column: '#' text: [ :_ :position | position ] weight: 1;
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
