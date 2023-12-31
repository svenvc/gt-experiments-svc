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
		column: 'Type' text: [ :column | self dataTypes at: column ];
		send: [ :column | self column: column ]
]

{ #category : #'*GToolkit4Dataframe' }
DataFrame >> gtViewHeadFor: composite [
	<gtView>
	self isEmpty ifTrue: [ ^ composite empty ].
	self numberOfRows <= 100 ifTrue: [ ^ composite empty ].
	^ composite forward
		title: 'Head';
		priority: 31;
		object: [ self head ];
		view: #gtViewTableFor:
]

{ #category : #'*GToolkit4Dataframe' }
DataFrame >> gtViewSummaryFor: composite [
	<gtView>
	self isEmpty ifNil: [ ^ composite empty ].
	(self dataTypes values 
		noneSatisfy: [ :dataType | dataType inheritsFrom: Number ]) ifTrue: [ ^ composite empty ].
	^ composite forward
		title: 'Summary';
		priority: 40;
		object: [ self summary ];
		view: #gtViewTableFor:
]

{ #category : #'*GToolkit4Dataframe' }
DataFrame >> gtViewTableFor: composite [
	<gtView>
	| columnedList |
	self isEmpty ifTrue: [ ^ composite empty ].
	self numberOfRows > 100 ifTrue: [ ^ composite empty ].
	columnedList := composite columnedList
		title: 'Table';
		items: [ self rows ];
		priority: 30.
	columnedList column: '#' text: [ :_ :index | index asRopedText foreground: Color gray ] weight: 1.
	self rowNames = (1 to: self numberOfRows) asOrderedCollection
		ifFalse: [
			columnedList column: 'row name' text: [ :series | series name ] ].
	self columnNames do: [ :column  | 
		columnedList column: column do: [ :aColumn | 
			aColumn
				item: [ :series | series at: column ];
				weight: 1 ] ].
	^ columnedList
]

{ #category : #'*GToolkit4Dataframe' }
DataFrame >> gtViewTailFor: composite [
	<gtView>
	self isEmpty ifTrue: [ ^ composite empty ].
	self numberOfRows <= 100 ifTrue: [ ^ composite empty ].
	^ composite forward
		title: 'Tail';
		priority: 32;
		object: [ self tail ];
		view: #gtViewTableFor:
]
