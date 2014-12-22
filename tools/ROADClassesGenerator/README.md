[![Platform](https://cocoapod-badges.herokuapp.com/p/libObjCAttr/badge.png)](https://github.com/epam/road-ios-framework/) 

#ROADClassesGenerator

An attribute generator is executable file that takes your json model and generate classes model for it.

##Usage

The attribute generator have one required argument and bunch of optional.

Required arguments:

* `-source`.  Source json file for classes generator.

Optional arguments:

* `-output`. Directory path for saving generated classes.
* `-prefix`. Generated classes name prefix.

If the parameter **output** not specified, the generated file is stored in the directory in which the json file specified parameter **source**.
The resulting models are ready to use attributed classes for [lib-Obj-Attr] (https://github.com/epam/lib-obj-c-attr).

**Important:** arguments can't contain whitespace, unless you escape them or place double quotes around value. (Legit: `-src=My\ Project` or `-src="My Project"`)
