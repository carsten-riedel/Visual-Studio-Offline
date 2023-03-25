# Visual-Studio-Offline

The one and only offline approach. Wrapping Visual Studio installation files in an offline installer with Inno Setup.

## Description

This guide explains how to create an offline installer for Visual Studio 2019 using Inno Setup, a powerful tool for creating Windows installers. The resulting installer can be used to perform silent, additive installations of Visual Studio 2019 without an internet connection. You can create individual offline installation packages tailored to your needs.

To create the offline installer, follow these steps:
1. Install Inno Setup on your machine.
2. Launch the ISS file.
3. Modify the following variables in the ISS file as needed:
- `GETINSTALLLOCATION`: Specifies the location for the installation of Visual Studio Community 2019. This is the string you see in Windows under "Programs and Features" (Uninstall). The display name in "Programs and Features" is used to get the install location, which is what you need to modify an existing installation.
- `VS_INSTALLER_EXE`: Specifies the name of the Visual Studio 2019 installer executable file.
- `SOURCEFILE`: Specifies the location of the `workloads_2019_test.txt` file. (Workloads are prepared, just change according to your needs)
4. Save the modified ISS and workloads file.
5. Run the ISS file to create the offline installer. (It downloads the required workloads automatically, preparing the "layout".)
6. The resulting installer can be used for silent, additive installations of Visual Studio 2019.

Note: The modified ISS file can also be used for creating an offline installer for Visual Studio 2022 with a few modifications, including changing the workloads in the `SOURCEFILE` variable. (VS2022 has different workloads)

## Sources
- [Visual Studio 2019 Community](https://my.visualstudio.com/) (Download and rename the installer if you don't trust the file in the repository)<br>
- [Inno Setup](https://jrsoftware.org/isinfo.php)

## Use case

Offline installations of Visual Studio 2019 or 2022 when there is limited or no internet connectivity.

## License

The license for the *.iss and *.txt files is MIT. Please note that the original *.exe file belongs to Microsoft.
