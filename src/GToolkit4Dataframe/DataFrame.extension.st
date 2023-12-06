Extension { #name : #DataFrame }

{ #category : #'*GToolkit4Dataframe' }
DataFrame >> gtViewColumnsFor: composite [
	<gtView>
	self columnNames ifNil: [ ^ composite empty ].
	^ composite columnedList
		title: 'Columns';
		priority: 35;
		items: [ self columnNames ];
		column: 'Position' text: [ :_ :position | position ];
		column: 'Column' text: #yourself weight: 2;
		column: 'Type' text: [ :column | self dataTypes at: column ]
]

{ #category : #'*GToolkit4Dataframe' }
DataFrame >> gtViewTableFor: composite [
	<gtView>
	| columnedList |
	self isEmpty ifTrue: [ ^ composite empty ].
	columnedList := composite columnedList
		title: 'Table';
		items: [ self asArrayOfRowsWithName ];
		priority: 30.
	columnedList column: '#' text: [ :_ :nr | nr asRopedText foreground: Color gray ] weight: 1.
	self rowNames = (1 to: self numberOfRows) asOrderedCollection
		ifFalse: [
			columnedList column: 'row name' text: [ :eachRow | eachRow at: 1 ] ].
	self columnNames doWithIndex: [ :column :index | 
		columnedList column: column do: [ :aColumn | 
			aColumn
				item: [ :eachRow | eachRow at: index + 1 ];
				weight: 1 ] ].
	^ columnedList
]
