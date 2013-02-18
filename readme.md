# ScrapeKit #
While you would think that the days of scraping screens (or web pages) are long behind us, the reality is that there are still many websites that do not provide an easy-to-consume data feed.

ScrapeKit is an Objective-C library that aims to provide a simple, extensible mechanism to be able to parse and consume data from formatted text input. 

It does this by using a simple text-based language to describe the way text needs to be extracted.  By using a text-based description that is interpreted at runtime, it can be easily updated if the format/layout of the original source changes.

## Underlying Concepts ##
### Working Premise ###
The working premise for ScrapeKit is that, while the format of the input may change over time, the general underlying data model is constant.  

For example, if you were scraping, say, a real estate site, you might create a `House` class that has properties such as `address`, `bedrooms`, `bathrooms` and `price`.  When you call ScrapeKit, you can expect to get back a populated `House` object; you don't really have to care whether the scraped site is using `div` or `td` tags.  

In this way, your application can be coded against that simple data model (which would **not** be expected to change even if the source input layout changes).  If the input format changes, you just need to update the script, not your whole application.

### Implementation ###
ScrapeKit uses a *very* simple [stack based machine](http://en.wikipedia.org/wiki/Stack_machine) and [DSL](http://en.wikipedia.org/wiki/Domain-specific_language) to manage the state of the parsing process.  The ScrapeKit engine walks through a set of *rules*, evaluating each one-by-one. For example:

	# the following rule pushes text between "XXX" and "YYY"
	# onto the stack (including the XXX component). For
	# example, if the input text was:
	#   Hello there XXX how are you YYY good thanks
	# the text that would be pushed onto the stack would be:
	#   "XXX how are you "
	
	PushBetween "XXX" include "YYY" exclude
	
	# and then the following saves that value into a property
	# called foo
	
	PopInto foo

The ScrapeKit language essentially maintains a cursor that points to some location in the original text.  It allows you to move that cursor back and forward and store pieces of text along the way.

In addition to the existing built-in rules, you can easily add your own custom rules.

## A Simple Example ##
A very simple example is as follows.  Imagine that your input looks like:

	<ol>
		<li>abc</li>
		<li>def</li>
		<li>ghi</li>
	</ol>

To parse this, you might create a script that looks something like:

	@main
		createvar NSMutableArray elements
		pushbetween <li> exclude </li> exclude
		iffailure end
		:loop
			popIntoVar elements
			pushbetween <li> exclude </li> exclude
			iffailure end
			goto loop
	:end

And to invoke ScrapeKit to use this script, you would use (assuming ARC):

	NSString *script = ...;
	NSString *data   = ...;
	
	SKEngine *engine = [[SKEngine alloc] init];
	[engine compile:script error:nil];

	[engine parse:data];

	NSMutableArray *elements = [engine variableFor:@"elements"];
	for (NSString *element in elements)
		NSLog(@"List element = %@", element);

## A Slightly More Complex Example ##
A more likely scenario, though, is that you want to parse the data into actual objects.  So, imagine the case where you want to go through a HTML table a row at a time, pulling out each cell value into an object's properties.

	<table>
		<tr><td>10 Smith St</td><td>Hopetown</td><td>2222</td></tr>
		<tr><td>20 Jones Rd</td><td>Danville</td><td>5555</td></tr>
		<tr><td>30 Brown Ln</td><td>Cessnock</td><td>7777</td></tr>
	</table>

You would most likely have an object model that looks a bit like:

	@interface MyAddress : NSObject
	@property (nonatomic,strong) NSString *street;
	@property (nonatomic,strong) NSString *city;
	@property (nonatomic,strong) NSString *postcode;
	@end
	
	@implementation MyAddress
	@end

To parse this input data the general logic would be:

* Create an array to hold all the addresses
* Extract a row's worth of data (ie. everything between `<tr>` and `</tr>` tags)
* For each row:
	* Create a MyAddress object
	* Walk through the row extracting the values from between each `<td>` tag.
	* Assign each cell to the appropriate property
	* Add the address object to the array

This would result in a script that looks something like:

	@main
		createvar NSMutableArray addresses
		pushbetween <tr> exclude </tr> exclude
		iffailure end
		:loop
			invoke handleRow
			pop
			pushbetween <tr> exclude </tr> exclude
			iffailure end
			goto loop
	:end
	
	@handleRow
		createvar MyAddress address
		pushbetween <td> exclude </td> exclude
		popintovar address street
		pushbetween <td> exclude </td> exclude
		popintovar address city
		pushbetween <td> exclude </td> exclude
		popintovar address postcode
		assignvar address addresses
		
And would be invoked using something like the following code:

	NSString *script = ...;
	NSString *data   = ...;

	SKEngine *engine = [[SKEngine alloc] init];
	[engine compile:script error:nil];
	
	[engine parse:data];
	
	NSMutableArray *addresses = [engine variableFor:@"addresses"];
	for (MyAddress *address in addresses)
		NSLog(@"%@, %@ %@", [address street], [address city], [address postcode]);


## When Shouldn't You Use ScrapeKit ##
Ideally, there shouldn't be a market for ScrapeKit, however, the fact is that scraping data from loosely structured input is still a common scenario.  While ScrapeKit could theoretically be used for the following scenarios, there are far better tools for:

* Parsing XML. Use `NSXMLParser` - it is an excellent way to parse XML.
* Parsing JSON. Use one of the million JSON parsers.
* Parsing HTML that you know is structurally sound. Walking a pre-parsed DOM tree will be far more accurate than using ScrapeKit (having said that, one advantage that ScrapeKit does give is the ability to easily change the walking logic without having to recompile your app).