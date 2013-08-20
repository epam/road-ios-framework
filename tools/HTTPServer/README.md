Simple Node.JS Based HTTP Server


Required

Before you start using this server you have to create an .htaccess file.
Start the Terminal application and type this:

htpasswd -nb username password

In this server application there is a check for the credentials, and it should be epam:epam.
So please take care about it or, change it in the source.

The second step, you have to install the node application to you workstation.
you can download the installer from here: http://nodejs.org/download/

After when you installed this application onto your workstation just make sure everything
is ok.

node -v

If you get back the version number of the node, it looks everything is ready to run this
Server.


Install

The server required a couple of packages, so you have to install all of them before
you would like to run the server.

npm install http
npm install colors
npm install url
npm install fs

Than copy your .htpasswd file what your created already to your chosen directory. Copy all this
files as well next to them and you're done. To run this server you need to call this
init command in your terminal:

node init.js

Now you can reach you're brand new Node.js Server on your localhost on port 1337.

http://localhost:1337

