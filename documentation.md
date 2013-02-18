# Technical Details #

## Script Layout ##
The general layout of a script file can contain the following elements:
### Comments ###
Comments are defined as anything after a `#` character.  Everything after that to the end of the line is ignored.

### Functions / Rules ###
You can define your own functions in a ScrapeKit script by using `@xxxx` where `xxxx` is the name of your function.  Exit of a function occurs when there are no more rules to evaluate.  Some example functions are defined below:

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
* `Goto` unconditionally shifts the execution to the specified *label*. 

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

## Debugging ##

## Writing Custom Rules ##



