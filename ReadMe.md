skeletonKey 0.99.80.40

 2020-11-22 8:22 PM
 
by romjacket 

This tool is a unified interface for ROMs, emulators and frontends.
SkeletonKey can be used as a GUI to download and configure emulators, deploy frontends, 
launch ROMs, and manage assets & artwork by leveraging metadata-databases,
 art/video-scrapers and more.  

Official files are found at GITHUB
http://github.com/romjacket/skeletonKey


https://www.paypal.me/romjacket/8.88

              
donate for the 8 if you're gr8 m8.			  

################  USAGE  ##################

Nearly all options have a hover-tool-tip which describe uses and functions.

Refer to the html help included (..\site\index.html) for detailed information.

The skeletonKey.exe file contains all the files it needs and creates them in the directory it in which it is executed.


###########################################

# DEVELOPING AND FORKING SKELETONKEY

You are free to deploy your own installer, binary and github-website which is automated easily by the SKey-Deploy.exe tool.

You will need a [github account](https://github.com/join) and a [token](https://github.com/settings/tokens).  

If you obtained source files for skeletonKey without executables, source-links to the needed binary dependencies can be found in the \bin\ directory.

and, you should compile all the files with an ".ahk" extension found in the root of the skeletonKey directory as well as those found in the

"\bin" directory to their respective directories with the Ahk2Exe compiler found in AutoHotKey's "Compiler" directory.


###########################################
# SOURCE & TOOLS
###########################################

skeletonkey.exe
This is the main program compiled from the working.ahk file.

SKey-Deploy.exe:  	
The development and deployment tool.

Init.exe
This tool initializes and creates the skeletonKey configuration.

Update.exe
This tool is called to update the existing skeletonKey application.

bin\BSL.exe
This is an enhanced launcher for ROM-Jackets.

bin\PortableUtil.exe
This tool is called before launching skeletonKey from a portable device on a new computer.

bin\EmuExe.exe
This tool is used by the executable utility.

R###########################################
License information:
This software is for personal, non-commercial use only.
You may not compile, deploy or distribute skeletonKey in any manner which facilitates financial profit.  
You may not compile, deploy or distribute skeletonKey in any manner which facilitates piracy.

You must include this unaltered readme along with any binary.