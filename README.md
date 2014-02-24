Minuit
======

**Propositions for a post-OSC prototypal protocol**

We propose some specifications for a query system based on OSC, coined here Minuit.
It has been discussed and refined by the protocol workgroup of the Virage platform on november 26th 2008.

###Structure
We define a namespace as a tree-structure of OSC addresses, sorted in nodes binding on objects which have attributes.

###Syntax
It has been decided that queries and replies should be separated from the address for optimization’s sake.
The type of message is then possible to filter based on tree specific characters into the first word of the message :
* a slash at start (/) indicates an OSC “standard“ command to the specified address (this includes addressing attributes)
* a question mark (?) indicates a query.
* a colon (:) indicates a reply to a query, and duplicates the query’s syntax (colon is also used further to separate attributes from address)
* a exclamation mark (!) indicates an error.

It turns out that the namespace can be handle using 4 differents operations :
* discovering (using **namespace**) : asks for the names of nodes and the types of objects on the next tree-structure level. The request allows also to get the attributes at the current tree-structure level.
* getting (using **get**) : gets the value of a particular attribute in an object.
* setting (using the standard OSC style) : sets the value of a particular attribute of
an object in the tree.
* listening (using **listen**) : enable or disable listening of the value of a particular attribute of an object in the tree. When a listening is enabled, the value would be sent as a reply to the application which ask for.

Hereafter we consider an application A (IP, port) and an application B (IP, port) which knows themself on an the network.
~~~
B would talk to A like that :
B?operation /whereTo ... (the rest depends on the operation)

A would replies to B using :
A:operation /whereTo ... (the rest depends on the operation)
~~~

###Discovering
~~~
B?namespace /WhereToDiscover
A:namespace /WhereToDiscover ObjectType nodes={ name1 name2 ...} attributes={ attributes of the object under the whereToDiscover node }
~~~

Important note : considering the genericity of this approach any types and attributes can be shared using this exchange format. However, to ensure interoperability between systems, we have to define standard object types and attributes (see below for a proposition of attributes name).

###Getting
~~~
B?get /WhereToGet:attribute 
A:get /WhereToGet:attribute value
~~~

###Setting
~~~
/WhereToSet value (this is standard OSC) no reply from A.
~~~

###Listening
~~~
B?listen /WhereToListen:attribute enable (turn on the listening) 
B?listen /WhereToListen:attribute disable (turn off the listening)

A:listen /WhereToListen:attribute value (each time the attribute change if the listening is turned on)
~~~

###Object types
There are 4 types of objects : 
* **Application** : the root of the tree structure.
* **Container** : a node of the tree structure which is not handling a value but provides features to manage the sub tree structure.
* **Data** : a node a the tree structure which handles a value.
* **none** : no object.

###Data Attributes
There are many attributes for the Data object. Here is a first overview :
* **value** : the value attribute is implicitly linked to the address, and then can be ommitted.
* **type** : the possible types are : integer, decimal, string, generic, boolean, none, array.
* **service**
what kind of access the value provides : parameter (read+write), message (write), return (read).
* **priority** : this a number used to order the setting of several object values in the same time. Smaller the number is the later it would receive the value. 0 means this object don’t care about order.
* **rangeBounds** : an array of two values of the specified type.
* **description** : textual description of what is the Data for.

###Example
Below is an example of dialog between 2 environments. In this case, this is the namespace discovery of a Max patcher (using Jamoma 0.6 framework) by the i-score Sequencer :

~~~
i-score?namespace /
Jamoma:namespace / Application nodes={ filter input recorder } attributes={ debug version type name author }
i-score?namespace /filter
Jamoma:namespace /filter Container nodes={ gain q } attributes={ tag service description priority }
i-score?namespace /filter/gain
Jamoma:namespace /filter/gain Data attributes={ rangeBounds service active tag type repetitionsFilter description priority valueDefault value }
~~~

~~~
i-score?get /filter/gain 
Jamoma:get /filter/gain 90
i-score?get /filter/gain:rangeBounds 
Jamoma:get /filter/gain:rangeBounds 0 127
~~~

~~~
i-score?listen /filter/gain enable
Jamoma:listen /filter/gain:value 53 
Jamoma:listen /filter/gain:value 54 
Jamoma:listen /filter/gain:value 55
~~~

~~~
i-score?get /foo
Jamoma!get /foo
~~~