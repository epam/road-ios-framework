OCLint setup
=========

OCLint is a static code analysis tool for improving quality and reducing defects by inspecting C, C++ and Objective-C code and looking for potential problems like:

* Possible bugs - empty if/else/try/catch/finally statements
* Unused code - unused local variables and parameters
* Complicated code - high cyclomatic complexity, NPath complexity and high NCSS
* Redundant code - redundant if statement and useless parentheses
* Code smells - long method and long parameter list
* Bad practices - inverted logic and parameter reassignment
* ...

Installation
--------------

We've configured aggregated targets to check each components code state. To get benefits from that, you need to have OCLint tool installed on your local machine. It's basically require from you to perfrom two steps:

* Download OCLint from [Downloads] page. Preferably, if it will be the latest version, which is 0.9dev at the moment of writting of this page.
* Add location of downloaded OCLint to $PATH in .bash_profile

```sh
OCLINT_HOME=/path/to/oclint-release
export PATH=$OCLINT_HOME/bin:$PATH
```

And don't forget to reload machine or at least terminal with

```sh
source ~/.bash_profile
```

For more infromation check out official page of [OCLint].


[Downloads]:http://oclint.org/downloads.html
[OCLint]:http://oclint.org
