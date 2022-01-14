# CommonQt for Qt5

This is a version of CommonQt adapted for Qt5. It uses the same
package names as the original CommonQt for Qt4, therefore the two
cannot be loaded simultaneously.

## Building CommonQt on Windows

### Initial Setup

  1. Ensure you have the following tools accessible via PATH
     (https://doc.qt.io/qt-5/windows-requirements.html):

    * jom (1.1.3 works)
    * ninja (v1.10.2 works)
    * Ruby (2.7.3 works)
    * Python 2.7
    * bison and flex 2.5.5
    * gnuwin32
    * GPerf
    * xmlstarlet 1.6.1
    * Visual Studio 2019 Community edition

  2. Make sure the directory that contains `win_bison.exe` and
     `win_flex.exe` has priority over `gnuwin32` in the `PATH`
     environment variable.

  3. Copy or rename `win_bison.exe` and `win_flex.exe` to `bison.exe`
     and `flex.exe`.

  4. Add the `qt-install\bin` directory to the beginning of the PATH
     environment variable, it's where `moc.exe` and Qt's DLLs are
     installed.

### Compiling Non-Lisp Dependencies

Every project listed below should be compiled using "x64 Native Tools
Command Prompt for VS 2019" cmd.

#### llvm
Repo: https://github.com/llvm/llvm-project, branch: 11.x.x
```
mkdir build && cd build
cmake ../llvm -G "Visual Studio 16 2019" -DLLVM_ENABLE_PROJECTS=clang;llvm;openmp -DCMAKE_INSTALL_PREFIX=%cd%\..\..\llvm-install -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_INCLUDE_TESTS=Off -DLLVM_INCLUDE_EXAMPLES=Off -DCMAKE_BUILD_TYPE=Release -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_CXX_STANDARD=14
msbuild ALL_BUILD.vcxproj -maxcpucount:4 /p:Configuration=RelWithDebInfo
msbuild INSTALL.vcxproj -maxcpucount:4 /p:Configuration=RelWithDebInfo
```

#### qtbase
Repo: https://github.com/qt/qtbase, branch: 5.14.2	
```
configure -opensource -release -platform win32-msvc -nomake tests -nomake examples -c++std c++14 -no-dbus -prefix %cd%\..\qt-install -confirm-license -force-debug-info
..\tools\jom\jom.exe -j 6
```

#### qtdeclarative
Repo: https://github.com/qt/qtdeclarative, branch: 5.14.2	
```
qmake && nmake && nmake install
```

#### qtquickcontrols2
Repo: https://github.com/qt/qtquickcontrols2, branch: 5.14.2	
```
qmake && nmake && nmake install
```

#### qtwebchannel
Repo: https://github.com/qt/qtwebchannel, branch: 5.14.2	
```
qmake && nmake && nmake install
```

#### qtwebsockets
Repo: https://github.com/qt/qtwebsockets, branch: 5.14.2	
```
qmake && nmake && nmake install
```

#### qtwebengine
Repo: https://github.com/qt/qtwebengine, branch: 5.14.2	
```
qmake -r && nmake && nmake install
```

#### qtsvg
Repo: https://github.com/qt/qtsvg, branch: 5.14.2
```	
qmake && nmake && nmake install
```

#### smokegen
Repo: https://github.com/commonqt/smokegen, branch: clang	
```
mkdir build && cd build
cmake .. -G "Visual Studio 16 2019" -DCMAKE_INSTALL_PREFIX=%cd%\..\..\smokegen-install -DQt5_DIR="%cd%\..\..\qtbase" -DCMAKE_BUILD_TYPE=Release
msbuild ALL_BUILD.vcxproj -maxcpucount:4 /p:Configuration=Release
msbuild INSTALL.vcxproj -maxcpucount:4 /p:Configuration=Release
```

#### smokeqt
Repo: https://github.com/commonqt/smokeqt, branch: qt5	
```
mkdir build && cd build
cmake .. -G "Visual Studio 16 2019" -DCMAKE_INSTALL_PREFIX=%cd%\..\..\smokeqt-install -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON
msbuild ALL_BUILD.vcxproj -maxcpucount:4 /p:Configuration=Release /t:Rebuild
msbuild INSTALL.vcxproj -maxcpucount:4 /p:Configuration=Release
```

### Notes

* `CMAKE_INSTALL_PREFIX` and `-prefix` (for compiling qtbase) indicate
  the installation directory. Ensure that all those directories are
  included in the `PATH` environment variable.

* Compiling LLVM takes several GB of space, ensure that there is at
  least 30GB of free space.

* The configure step of `qtbase` will set the definitions for all
  other Qt projects.

* Every project must be compile in the same configuration: DEBUG or
  RELEASE.

* Qt, LLVM and smokegen **must be** compiled in RELEASE mode. The
  reason why is that Qt5 on windows differentiate the debug vs release
  dlls by a suffix letter, e.g. Qt5Core.dll (release) vs Qt5Cored.dll
  (debug). smokegen and smokeqt are not capable of coping with such
  difference. When migrating to Qt6, this will not be a problem as the
  suffix letter was dropped.

* While compiling LLVM openmp, an error about "setlocal" and missing
  copy files may occur. To work around it:
  - Go to `llvm-project\build\bin\Debug` and move `libomp.dll` to
    `llvm-project\build\bin\`;
  - Go to `llvm-project\build\lib\Debug` and move `libomp.dll.lib` to
    `llvm-project\build\lib`;
  - Go to `llvm-project\build\lib\Debug` and move `libomp.lib` to
    `llvm-project\build\lib`;
  - Run build Again

* Visual Studio 2019.8.1 has a bug
  (https://github.com/microsoft/STL/issues/1300) that can be fixed
  using [this patch](https://common-lisp.net/~loliveira/patches/vs2019.8.1.diff):

  - Go to `C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.28.29333\include`
    and back up files `intrin.h` and `intrin0.h`.
  - `git apply --unsafe-paths -p6 --directory="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.28.29333\include" vs2019.8.1.diff`

## CommonQt

TODO: The qt-libs project has not yet been adapted to commonqt5.
