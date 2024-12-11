# fife_image

Image processing for the Fife Lab.

## Getting Started

The flutter project is designed to be used in the browser.

To run the server:
Download conda. Create the conda environment for the project:
```
conda env create -f environment.yml
```
Activate the environment:
```
conda activate fife-image
```

```
cd server/
python main.py
```

Configuration for installing the server on mac is done in xcode adn the information is stored in:
macos/Runner.xcodeproj/project.pbxproj
this file runs a shell script 

Configuration for running the server on mac is stored in:
macos/Runner/AppDelegate.swift
It runs the server in the users home directory ~/FifeImage and stores the logs there too

Note: if you run the app from android studio it will NOT build the server if macos/dist/main 
already exists. If it does not exist it will build it.
however it WILL attempt to run the server from macos/dist/main if the server is not already running
manually.
If the app is closed from android studio with the stop button it will not kill the server. You
must kill it manually.

TODO write a makefile that cleans everything as well

to build for MacOS:
pyinstaller --onefile main.py
flutter build macos

to build for Windows:
dart run msix:create
then copy the python binary into the resulting folder

