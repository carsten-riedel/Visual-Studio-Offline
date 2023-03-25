# Visual-Studio-Offline
The one and only offline approach. Wrapping visual studio installation files in an offline installer with inno setup.

## Description
This guide explains how to create an offline installer for Visual Studio 2019 using Inno Setup, a powerful tool for creating Windows installers. The resulting installer can be used to perform silent, additive installations of Visual Studio 2019 without an internet connection.
Create you individual offline installation packages!

Install Inno Setup on your machine.<br>
Launch the ISS file.<br>
Modify the following variables in the ISS file as needed:<br>
GETINSTALLLOCATION: Specifies the location for the installation of Visual Studio Community 2019. This is the string you see in Windows under "Programs and Features" (Uninstall). The Displayname in "Programs and Features" is used to get the Installlocation, the Installlocation is what you need to modify an existing installation.<br>
VS_INSTALLER_EXE: Specifies the name of the Visual Studio 2019 installer executable file.<br>
SOURCEFILE: Specifies the location of the workloads_2019_test.txt file. (Workloads prepared, just change according to your needs)<br>
Save the modified ISS and workloads file.<br>
Run the ISS file to create the offline installer. (It downloads the required workloads automatilcy preparing the "layout")
The resulting installer can be used for silent, additive installations of Visual Studio 2019.
Note: The modified ISS file can also be used for creating an offline installer for Visual Studio 2022 with a few modifications, including changing the workloads in the SOURCEFILE variable. (VS2022 has different workloads)

## Sources
[Visual Studio 2019 Community](https://my.visualstudio.com/) (Download and rename the installer if you don't trust the file in the repository)<br>
[Inno Setup](https://jrsoftware.org/isinfo.php)

## Usecase
Offline

## License
The license for the *.iss and *.txt files is MIT. Please note that the original *.exe file belongs to Microsoft.

