"
I am ProjectGutenbergBook, a free eBook.

https://www.gutenberg.org

For the catalog entries, I use https://gutendex.com
"
Class {
	#name : #ProjectGutenbergBook,
	#superclass : #Object,
	#instVars : [
		'metaData',
		'fullText'
	],
	#classVars : [
		'MostPopular'
	],
	#category : #'GT-Experiments-svc'
}

{ #category : #accessing }
ProjectGutenbergBook class >> clear [
	"Cached book might contain their full text, which takes memory. Clear everything."
	<gtExample>
	MostPopular:= nil
]

{ #category : #'instance creation' }
ProjectGutenbergBook class >> downloadMostPopular [
	| result |
	result := ZnClient new enforceHttpSuccess; forJsonREST; get: 'https://gutendex.com/books'.
	^ result results collect: [ :each | self metaData: each ]
]

{ #category : #accessing }
ProjectGutenbergBook class >> dracula [
	<gtExample>
	^ self id: 345
]

{ #category : #accessing }
ProjectGutenbergBook class >> gtMostPopularViewFor: aView [
	<gtClassView>
	^ aView columnedList
		title: 'Most popular books';
		items: self mostPopular;
		column: 'title' text: [ :book | book title ];
		column: 'author' text: [ :book | book author ];
		column: 'downloaded' text: [ :book | book hasFullText ];
		actionStencil: [ :aButton | 
				GtSpotterDropdownButtonStencil new
					object: self;
					id: GtPharoSearchCodeButtonId;
					asElement ]
			tooltip: 'Search most popular books by title';
		actionUpdateButton
]

{ #category : #accessing }
ProjectGutenbergBook class >> gtSearchMostPopularBooksFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 15;
		title: 'Most popular books titles';
		items: [ self mostPopular ];
		itemName: [ :book | book title ];
		filterBySubstring
]

{ #category : #'instance creation' }
ProjectGutenbergBook class >> id: integer [
	| url metaData |
	url := 'https://gutendex.com/books/' , integer asString.
	metaData := ZnClient new enforceHttpSuccess; forJsonREST; get: url.
	^ self metaData: metaData 
]

{ #category : #'instance creation' }
ProjectGutenbergBook class >> metaData: json [
	^ self new metaData: json; yourself
]

{ #category : #accessing }
ProjectGutenbergBook class >> mostPopular [
	<gtExample>
	^ MostPopular ifNil: [ MostPopular := self downloadMostPopular ]
]

{ #category : #accessing }
ProjectGutenbergBook >> author [
	^ self metaData authors
		ifEmpty: [ #'n/a' ]
		ifNotEmpty: [ :authors | authors first name ]
]

{ #category : #accessing }
ProjectGutenbergBook >> copyright [
	^ self metaData copyright
]

{ #category : #operations }
ProjectGutenbergBook >> downloadFullText [
	^ ZnClient new get: self plainTextUrl
]

{ #category : #accessing }
ProjectGutenbergBook >> fullText [
	^ fullText
]

{ #category : #accessing }
ProjectGutenbergBook >> fullText: anObject [
	^ fullText := anObject
]

{ #category : #accessing }
ProjectGutenbergBook >> gtClearFullTextAction: action [
	<gtAction>
	self hasFullText ifFalse: [ ^ action noAction ].
	^ action button
		tooltip: 'Clear the full text of this book';
		icon: BrGlamorousVectorIcons remove;
		action: [ :aButton |
			self fullText: nil.
			aButton phlow fireUpdateWish ]
]

{ #category : #accessing }
ProjectGutenbergBook >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 30;
		items: [ {
			('id' -> self id).
			('title' -> self title).
			('author' -> self author).
			('copyright' -> self copyright).
			('size' -> (self size ifNil: [ 'n/a' ])).
			('line count' -> (self lineCount ifNil: [ 'n/a' ])) } ];
		column: 'Key' text: #key;
		column: 'Value' text: #value weight: 3;
		send: #value
]

{ #category : #accessing }
ProjectGutenbergBook >> gtDownloadFullTextAction: action [
	<gtAction>
	self hasFullText ifTrue: [ ^ action noAction ].
	^ action button
		tooltip: 'Download the full text of this book';
		icon: BrGlamorousVectorIcons down;
		action: [ :aButton |
			self fullText: self downloadFullText.
			aButton phlow fireUpdateWish ]
]

{ #category : #accessing }
ProjectGutenbergBook >> gtFullTextFor: aView [
	<gtView>
	self hasFullText ifFalse: [ ^ aView empty ].
	^ aView textEditor
		title: 'Full text';
		priority: 35;
		text: self fullText
]

{ #category : #accessing }
ProjectGutenbergBook >> gtJSONMetaDataFor: composite [
	<gtView>
	^ composite forward
		title: 'JSON meta data';
		priority: 40;
		object: [ self metaData ];
		view: #gtJsonFor:
]

{ #category : #accessing }
ProjectGutenbergBook >> gtSearchFullTextFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 15;
		title: 'Full text lines';
		items: [ self fullText ifNil: [ #() ] ifNotNil: [ :text | text lines ] ];
		filterBySubstring
]

{ #category : #testing }
ProjectGutenbergBook >> hasFullText [
	^ fullText notNil
]

{ #category : #accessing }
ProjectGutenbergBook >> id [
	^ self metaData id
]

{ #category : #accessing }
ProjectGutenbergBook >> lineCount [
	^ self hasFullText ifTrue: [ fullText lines size ]
]

{ #category : #accessing }
ProjectGutenbergBook >> metaData [
	^ metaData ifNil: [ metaData := NeoJSONObject new ]
]

{ #category : #accessing }
ProjectGutenbergBook >> metaData: anObject [
	metaData := anObject
]

{ #category : #accessing }
ProjectGutenbergBook >> plainTextUrl [
	self metaData formats keysAndValuesDo: [ :mimeType :url |
		(mimeType asZnMimeType matches: ZnMimeType textPlain)
			ifTrue: [ ^ url ] ].
	self  error: 'no plain text format found'
]

{ #category : #accessing }
ProjectGutenbergBook >> printOn: stream [
	super printOn: stream.
	stream nextPut: $(; nextPutAll: self title; nextPut: $)
]

{ #category : #accessing }
ProjectGutenbergBook >> size [
	^ self hasFullText ifTrue: [ fullText size ]
]

{ #category : #accessing }
ProjectGutenbergBook >> title [
	^ self metaData title
]
