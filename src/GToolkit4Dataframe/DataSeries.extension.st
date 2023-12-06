Extension { #name : #DataSeries }

{ #category : #'*GToolkit4Dataframe' }
DataSeries >> gtViewSeriesFor: composite [
	<gtView>
	self isEmpty ifNil: [ ^ composite empty ].
	^ composite columnedList
		title: 'Series';
		priority: 35;
		items: [ { #name->self name } , self associations ];
		column: '#' text: [ :_ :position | position ];
		column: 'Key' text: #key weight: 2;
		column: 'Value' text: #value
]
