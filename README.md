# Visual-Studio-2019-Offline
The one and only offline approach. Wrapping visual studio installation files in an offline installer with inno setup.

## How to use
Install inno setup, launch the iss file.<br>
Change this:<br>
#define VS_INSTALLER_EXE "vs_community_2019.exe" <br>
#define SOURCEFILE SourcePath + "workloads_2019_min.txt" <br>

## Result
An additative offline installer that is able to run silent.

## License
Just covers the *.iss and *.txt file. The orginal .exe belongs to Microsoft of course.
