## Resubmission
This is a resubmission. In this version I have:

* I have omitted the redundant "R" in a description
* I have added the URL of the api in the description field.
* I have spoken with OpenSky-Network people and they agree with the use of
OpenSky, but I have added a clarification that they are not responsible of 
the library (I have specified the term "third-party" in some parts of the
description and title)


## Test environments
* win-builder (devel and release) on local and Github CI/CD
* ubuntu 16.04 (release) on Github CI/CD
* macOS builder (devel and release) on Github CI/CD

## R CMD check GITHUB CI/CD results
There were no ERRORs or WARNINGs. 

## Notes
In my local (Windows), I have test the library using all the tools
provided by devtools::check(), without any error; and devtools::release():

* spell_check() : Suggest revise the spelling in proper nouns such as Gasco, OpenSky, etc.
* "R CMD check": No ERRORs or WARNINGs
* "check_rhub()": The rhub builder identifies mis-spelled words in DESCRIPTION
for proper nouns (the propor noun is OpenSky, it cannot be changed).
