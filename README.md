# Visual-Studio-2019-Offline
The one and only offline approach. Wrapping visual studio installation files in an offline installer with inno setup.

## Description
This guide explains how to create an offline installer for Visual Studio 2019 using Inno Setup, a powerful tool for creating Windows installers. The resulting installer can be used to perform silent, additive installations of Visual Studio 2019 without an internet connection.
Create you individual offline installation packages!

Install Inno Setup on your machine.<br>
Launch the ISS file.<br>
Modify the following variables in the ISS file as needed:
GETINSTALLLOCATION: Specifies the location for the installation of Visual Studio Community 2019. This is the string you see in Windows under "Programs and Features" (Uninstall)<br>
VS_INSTALLER_EXE: Specifies the name of the Visual Studio 2019 installer executable file.<br>
SOURCEFILE: Specifies the location of the workloads_2019_test.txt file. (Workloads prepared, just change according to your needs)
Save the modified ISS file.<br>
Run the ISS file to create the offline installer.
The resulting installer can be used for silent, additive installations of Visual Studio 2019.
Note: The modified ISS file can also be used for creating an offline installer for Visual Studio 2022 with a few modifications, including changing the workloads in the SOURCEFILE variable.

## Usecase
Offline

## License
The license for the *.iss and *.txt files is MIT. Please note that the original *.exe file belongs to Microsoft.

