# ScrapeKit #
While you would think that the days of scraping screens (or web pages) are long behind us, the reality is that there are still many websites that do not provide an easy-to-consume data feed.

ScrapeKit is an Objective-C library that aims to provide a simple, extensible mechanism to be able to parse and consume data from formatted text input. 

It does this by using a simple text-based language to describe the way text needs to be extracted.  By using a text-based description that is interpreted at runtime, it can be easily updated if the format/layout of the original source changes.

## Underlying Concepts ##
### Working Premise ###
The working premise for ScrapeKit is that when dealing with scraped data, there are two distinct phases:

* Extraction of data from an input source 
* Processing of that data

If we're able to provide a clearly defined data interface between these two stages, it allows the means of extraction to vary over time without impacting the processing of the data. 

Allow me to present an example… if you were scraping, say, a real estate site, you would be expecting to get back  a collection of `houses`, where each `house` has attributes like `address`, `bedrooms`, `bathrooms` and `price`.  This represents the data interface between the extraction and processing phases.

Just because the layout of the input data changes from, say, `td` tags to `div` tags, it shouldn't mean that your processing phase should need changing.  What it does mean is that your extraction phase needs to be modified to handle the new input, while still producing the original output data model.

ScrapeKit provides the means through which this can easily be achieved.

### Implementation ###
ScrapeKit uses a *very* simple [stack based machine](http://en.wikipedia.org/wiki/Stack_machine) and [DSL](http://en.wikipedia.org/wiki/Domain-specific_language) to manage the state of the parsing process.  

* The ScrapeKit engine walks through a set of *rules*, evaluating each one-by-one.  
* Input data for the rules is represented as a *text buffer*, which has an internal cursor that points to a location in the original text.
* Various rules allow you to move that cursor back/forth within the *text buffer*, create new *text buffers* and push/pop them onto a stack, and save portions of the *text buffer* along the way.

In addition to the existing built-in rules, you can easily add your own custom rules.

## A Simple Example ##
A very simple example is as follows.  Imagine that your input looks like:

	<ol>
		<li>abc</li>
		<li>def</li>
		<li>ghi</li>
	</ol>

To extract out the list items, your general logic would be:

* Create an array to hold the resulting items
* Look for text between `<li>` and `</li>` tags
* Repeat whileever there are more tags

A script to achieve this might look something like:

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

	#import <ScrapeKit/ScrapeKit.h>

	NSString *script = ...;
	NSString *input  = ...;
	
	SKEngine *engine = [[SKEngine alloc] init];
	[engine compile:script error:nil];
	[engine parse:input];

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

	#import <ScrapeKit/ScrapeKit.h>

	NSString *script = ...;
	NSString *input  = ...;

	SKEngine *engine = [[SKEngine alloc] init];
	[engine compile:script error:nil];
	
	[engine parse:input];
	
	NSMutableArray *addresses = [engine variableFor:@"addresses"];
	for (MyAddress *address in addresses)
		NSLog(@"%@, %@ %@", [address street], [address city], [address postcode]);

## Awesome Sauce… What Next? ##
There is some more detailed information on the rules and how you might apply them documented in the [ScrapeKit documentation](Documentation/documentation.md).

## When Shouldn't You Use ScrapeKit ##
Ideally, there shouldn't be a market for ScrapeKit, however, the fact is that scraping data from loosely structured input is still a common scenario.  While ScrapeKit could theoretically be used for the following scenarios, there are far better tools for:

* Parsing XML. Use `NSXMLParser` - it is an excellent way to parse XML.
* Parsing JSON. Use one of the million JSON parsers.
* Parsing HTML that you know is structurally sound. Walking a pre-parsed DOM tree will be far more accurate than using ScrapeKit (having said that, one advantage that ScrapeKit does give is the ability to easily change the walking logic without having to recompile your app).