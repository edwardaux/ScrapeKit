# ScrapeKit #
While you would think that the days of scraping screens (or web pages) are long behind us, however the reality is that there are still many websites that do not provide an easy-to-consume data feed.

ScrapeKit is an Objective-C library that aims to provide a simple, extensible mechanism to be able to parse and consume data from formatted text input. 

It does this by using a simple text-based language to describe the way text needs to be extracted.  By using a text-based description that is interpreted at runtime, it can be easily updated if the format/layout of the original site changes.

## Underlying Concepts ##
### Development Technique ###
The working premise for ScrapeKit is that you can define a simple scraped data model using Objective-C classes that represents the contents of the data you are scraping.  Your application is coded against that simple data model (which would **not** be expected to change even if the source input layout changes).  Then, you use a ScrapeKit script to populate the data model with scraped data, and if the input changes, you just need to update the script, not your whole application.

For example, if you were scraping, say, a real estate site, you might create a `House` object that has properties such as `address`, `bedrooms`, `bathrooms` and `price`.  When you call the scraping routine, you basically expect to get back a populated `House` object… you don't really have to care whether the scraped site is using `div` or `td` tags.  

### Implementation ###
ScrapeKit uses a *very* simple [stack based machine](http://en.wikipedia.org/wiki/Stack_machine) and [DSL](http://en.wikipedia.org/wiki/Domain-specific_language) to manage the state of the parsing process.  The ScrapeKit engine walks through a set of *rules*, evaluating each one-by-one. For example:

<pre lang="text">
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
</pre>

The ScrapeKit language essentially maintains a cursor that points to some location in the original text.  It allows you to move that cursor back and forward and store pieces of text along the way.

In addition to the existing built-in rules, you can easily add your own custom rules.

## API ##
Supports programmatic and interpreted
### Script Layout ###
The general layout of a script file is can contain the following elements:
#### Comments ####
Comments are defined as anything after a `#` character.  Everything after that to the end of the line is ignored.

#### Main ####
The ScrapeKit engine expects, at a minimum, a function called `main` that will be used as the entry point for the execution.

#### Functions / Rules ####
You can define your own functions in a ScrapeKit script by using `@xxxx` where `xxxx` is the name of your function.  Entry for a function is the first rule.  Exit of a function occurs when there are no more rules to evaluate.  Some example functions are defined below:

<pre lang="text">
@myfunc
	# push some data onto the stack
	PushBetween "<div>" exclude "</div>" exclude
	# now call another function to do something
	Call anotherfunc
	# and save the result
	PopInto myvar
	
@anotherfunc
	# do some stuff with the input and push result onto the stack
	# ...
	PushBetween "<a>" exclude "</a>" exclude
</pre>

You can pass data into functions by pushing it onto the stack before calling it.  Likewise, if a function needs to return data, it can push it onto the stack before it returns.

#### Indenting ####
Leading whitespace is ignored, but encouraged to maintain readability.

#### Strings ####
ScrapeKit is very simplistic in that all function names, labels, rule names, parameters are treated as simple strings. If you need to, say, pass a parameter to a rule that has embedded spaces, you must wrap it in `"` characters.  If your parameter contains a `"` character, then it must be escaped with another `"` character. For example, `"<a href=""blah.html"">"`

### Flow Control ###
There are a couple of rules that can be used to control the flow within your script.  Specifically, `Goto` and `Call`.  `Call` simply invokes another ScrapeKit function (and can be used recursively).  `Goto` shifts the execution to the specified *label*.  A *label* can be defined anywhere in a function and looks like `:mylabel`.  For example:

<pre lang="text">
@myfunc
	:loop
		PushBetween "X" exclude "Y" include 
		PopInto blah
		Call someotherfunction
		Goto :loop
</pre>

### Text Rules ###
ScrapeKit comes with a number of pre-built rules that should cover most text parsing cases.
#### PushBetweenXX ####

#### Custom Rules ####
To create a new custom rule, you need to do the following:
??????

### Variables ###
Parsed data
## When Shouldn't You Use ScrapeKit ##
Ideally, there shouldn't be a market for ScrapeKit, however, the fact is that scraping data from loosely structured input is still a common scenario.  While ScrapeKit could be used for the following scenarios, there are far better tools for:

* Parsing XML. Use `NSXMLParser` - it is an excellent way to parse XML.
* Parsing JSON. Use one of the million JSON parsers.
* Parsing HTML that you know is structurally sound. Walking a pre-parsed DOM tree will be far more accurate than using ScrapeKit (having said that, one advantage that ScrapeKit does give is the ability to easily change the walking logic without having to recompile your app).