iOS App Accelerators
====================

  Copyright (c) 2013 Epam Systems. All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are met:

 - Redistributions of source code must retain the above copyright notice, this 
list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this 
list of conditions and the following disclaimer in the documentation and/or 
other materials provided with the distribution.
 - Neither the name of the EPAM Systems, Inc.  nor the names of its contributors 
may be used to endorse or promote products derived from this software without 
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Version beta 0.1

The iOS app accelerator framework intends to speed up iOS and Mac OS X app development: providing machniery behind the scenes to avoid boiler plate codes.

The netlog listener is a mac desktop application designed to work together with the accelerator framework's logging section, more specifically with the logging solution that produces output via Apple's Bonjour network services.

The attribute preprocessor workspace aids development by transforming commented attribute-like syntax in obj-c header files in a project into .plist files available to query during runtime.

The frontend contains mac and ios compatible development framework, divided into many functionally separate projects:
  - Reflection: provides convenience obj-c wrapper around apple's runtime machinery
  - Core: containing basic utility classes and categories
  - Observation: easy to use observer objects for the Foundation framework's KVO and notification center
  - Attribute: the project that allows easy access to the attribute .plist files produced by the preprocessor tool. The rest of the projects build upon this machinery
  - Services: attribute-based service provider implementation and accompanying attributes
  - Logger: convenient and highly customizable logging framework with formatters, and different writing targets
  - Serialization: attribute based json serialization framework and accompanying attributes
  - Workflow and processor: easy to use lightweight workflow engine solution
  - Webservice: attribute based web api implementation, easy to customize and configure via attributes without the need to create new implementation
  - DAO: attriute based mapping between managed objects and the rest of the application, as well as usual core data machinery implementation

The framework is a work in progress. Use with caution at your own risk.
- to be extended -
