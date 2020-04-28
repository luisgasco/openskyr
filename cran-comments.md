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
