###################################################################
#
# Readme file for the iOS build script
# Maintained by: Szilveszter_Molnar@epam.com
#
###################################################################

1. Update the build.properties with the values from the XCode4 project
2. to build the project from the command line use:
	ant build
3. to run the unit tests from the command line use:
	ant test
4. to create an .ipa file and upload it to the Mobile App Store use:
	ant publish

###################################################################
#	
# Important Notes
#
###################################################################

------------------------ Code signing -----------------------------

- the build script will successfully do a code-sign only if:
	1. there is a valid provisioning profile for the bundle id that is used
	2. the value for the xcode.codesignidentity property should be set to match the code
		signing identity together with the provisioning profile (see below how to find
		the id of the signing identity )
				
- to find all valid signing identities use the following command line:
	security find-identity -v
	
- if the ceritificate + private keys that is used for code-signing is placed in 
the login keychain then the code-signing process will ask for a password, and
the build process will fail on an automated CI system. To prevent this make sure that you
place the certificate + private key into the System keychain.

------------------------ Mobile App Store ---------------------------

- to upload the .ipa file to the mobile app store you need to provide a PMC username for that project, 
or to create an 'upload user' on the mobile app store for that project

- if installation fails on the phone check the following:
	- get-task-allow should be disabled for Release builds
	- if you are upgrading:
		- the bundle id for the application you are trying to install is 
		higher then the already installed version
- generally speaking the XCode Organizer console will tell you exactly 
	why the installation fails, if there is a problem you can't solve 
	contact me