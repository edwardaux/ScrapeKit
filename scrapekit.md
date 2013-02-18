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

## Script Layout ##
The general layout of a script file can contain the following elements:
### Comments ###
Comments are defined as anything after a `#` character.  Everything after that to the end of the line is ignored.

### Functions / Rules ###
You can define your own functions in a ScrapeKit script by using `@xxxx` where `xxxx` is the name of your function.  Exit of a function occurs when there are no more rules to evaluate.  Some example functions are defined below:

<pre lang="text">
@myfunc
	# push some data onto the stack
	PushBetween "&lt;div&gt;" exclude "&lt;/div&gt;" exclude
	# now call another function to do something
	Call anotherfunc
	# and save the result
	PopInto myvar
	
@anotherfunc
	# do some stuff with the input and push result onto the stack
	# ...
	PushBetween "&lt;a&gt;" exclude "&lt;/a&gt;" exclude
</pre>

You can pass data into functions by pushing it onto the stack before calling it.  Likewise, if a function needs to return data, it can push it onto the stack before it returns.

The ScrapeKit engine expects, at a minimum, a function called `main` that will be used as the entry point for the execution.

### Labels ###
You can define a label by using a colon-prefixed label. eg. `:xxxx`  A label is normally used to control script logic flow in conjunction with the `Goto` rule.

### Indenting ###
Leading whitespace is ignored, but encouraged to maintain readability.

### Strings ###
ScrapeKit is very simplistic in that all function names, labels, rule names, parameters are treated as simple strings. If you need to define a string that has embedded spaces, you must enclose it within `"` characters.  If your string contains a `"` character, then it must be escaped with a `\` character. For example, `"<a href=\"blah.html\">"`

### Flow Control ###
There are a couple of rules that can be used to control the flow within your script.  Specifically, `IfSuccess`, `IfFailure`, `Goto`, and `Invoke`.  

* `IfSuccess` and `IfFailure` shifts the execution location to the passed *label* based on the success/failure of the previous rule.  The definition of success or failure varies from rule to rule and can be seen in the header file for the respective rule. For example, see [SKAssignVarRule.h](ScrapeKit/Classes/Engine/Rules/SKAssignVarRule.h).
* `Invoke` simply invokes another ScrapeKit function (and can be used recursively).  
* `Goto` unconditionally shifts the execution to the specified *label*. For example:

	<pre lang="text">
@myfunc
	:loop
		PushBetween "X" exclude "Y" include 
		PopInto blah
		Invoke someotherfunction
		Goto loop
</pre>

## Variable Management ##
ScrapeKit uses a single global variable pool that is available to all functions and rules within a script.  Each script uses its own variable pool.

There several ways data can be stored as variables:

* Saving directly into an `NSString`
* Adding to a `NSmutableArray`
* Adding to a `NSMutableDictionary`
* Setting properties on objects using `setValue:forKey:` 

## Rules ##
### Built-in Rules ###
ScrapeKit comes with a number of pre-built rules that should cover most text parsing cases.  The header files for each contain a more detailed explanation of each rule.

#### Variable Management ####
* `AssignConst` - Assigns a constant to a variable and/or property.
* `AssignVar` - Assigns a variable to another variable and/or property.
* `CreateVar` - Creates a new variable in the global variable pool.
* `PopIntoVar` - Pops text off the text stack into a variable and/or property.

#### Flow Control ####
* `Goto` - Unconditionally switches execution to a particular label.
* `IfSuccess` - Switches execution to a label based on success of previous rule.
* `IfFailure` - Switches execution to a label based on success of previous rule.
* `Invoke` - Invokes a sub-function.  Can be used recursively.
* `Label` - A nop rule that provides a target for the other flow control rules.

#### Stack / Text Management ####
* `Pop` - Pops a single text buffer off the text stack.
* `PushBetween` - Searches for a piece of text within other text and pushes it onto the text stack for later processing.

## When Shouldn't You Use ScrapeKit ##
Ideally, there shouldn't be a market for ScrapeKit, however, the fact is that scraping data from loosely structured input is still a common scenario.  While ScrapeKit could theoretically be used for the following scenarios, there are far better tools for:

* Parsing XML. Use `NSXMLParser` - it is an excellent way to parse XML.
* Parsing JSON. Use one of the million JSON parsers.
* Parsing HTML that you know is structurally sound. Walking a pre-parsed DOM tree will be far more accurate than using ScrapeKit (having said that, one advantage that ScrapeKit does give is the ability to easily change the walking logic without having to recompile your app).