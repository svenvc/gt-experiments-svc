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
	#category : #'GT-Experiments-svc'
}

{ #category : #accessing }
ProjectGutenbergBook class >> dracula [
	<gtExample>
	^ self id: 345
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

{ #category : #'instance creation' }
ProjectGutenbergBook class >> mostPopular [
	<gtExample>
	| result |
	result := ZnClient new enforceHttpSuccess; forJsonREST; get: 'https://gutendex.com/books'.
	^ result results collect: [ :each | self metaData: each ]
]

{ #category : #accessing }
ProjectGutenbergBook >> author [
	^ self metaData authors first name
]

{ #category : #operations }
ProjectGutenbergBook >> downloadFullText [
	^ ZnClient new get: self plainTextUrl
]

{ #category : #accessing }
ProjectGutenbergBook >> fullText [
	^ fullText ifNil: [ fullText := self downloadFullText ]
]

{ #category : #accessing }
ProjectGutenbergBook >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		items: [ {
			('id' -> self id).
			('title' -> self title).
			('author' -> self author). } ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
ProjectGutenbergBook >> id [
	^ self metaData id
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
	^ self metaData formats at: 'text/plain'
]

{ #category : #accessing }
ProjectGutenbergBook >> printOn: stream [
	super printOn: stream.
	stream nextPut: $(; nextPutAll: self title; nextPut: $)
]

{ #category : #accessing }
ProjectGutenbergBook >> title [
	^ self metaData title
]
