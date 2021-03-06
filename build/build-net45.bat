@setlocal

@rem Initialize Visual Studio build environment:
@rem - Visual Studio 2017 Community/Professional/Enterprise is the preferred option
@rem - Visual Studio 2015 is the fallback option (which might or might not work)
@set tools=
@set tmptools="c:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\vsvars32.bat"
@if exist %tmptools% set tools=%tmptools%
@set tmptools="c:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsMSBuildCmd.bat"
@if exist %tmptools% set tools=%tmptools%
@set tmptools="c:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\Tools\VsMSBuildCmd.bat"
@if exist %tmptools% set tools=%tmptools%
@set tmptools="c:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\Tools\VsMSBuildCmd.bat"
@if exist %tmptools% set tools=%tmptools%
@if not defined tools goto :error
call %tools%
@echo on

@rem Delete output directory
rmdir /S /Q net45

@rem Clean project
msbuild ..\src\Pkcs11Interop\Pkcs11Interop\Pkcs11Interop.csproj ^
/p:Configuration=Release /p:Platform=AnyCPU /p:TargetFrameworkVersion=v4.5 ^
/target:Clean || goto :error
msbuild ..\src\Pkcs11Interop\Pkcs11Interop.StrongName\Pkcs11Interop.StrongName.csproj ^
/p:Configuration=Release /p:Platform=AnyCPU /p:TargetFrameworkVersion=v4.5 ^
/target:Clean || goto :error

@rem Build project
msbuild ..\src\Pkcs11Interop\Pkcs11Interop\Pkcs11Interop.csproj ^
/p:Configuration=Release /p:Platform=AnyCPU /p:TargetFrameworkVersion=v4.5 ^
/target:Build || goto :error
msbuild ..\src\Pkcs11Interop\Pkcs11Interop.StrongName\Pkcs11Interop.StrongName.csproj ^
/p:Configuration=Release /p:Platform=AnyCPU /p:TargetFrameworkVersion=v4.5 ^
/target:Build || goto :error

@rem Copy result to output directory
mkdir net45 || goto :error
copy ..\src\Pkcs11Interop\Pkcs11Interop\bin\Release\Pkcs11Interop.dll net45 || goto :error
copy ..\src\Pkcs11Interop\Pkcs11Interop\bin\Release\Pkcs11Interop.xml net45 || goto :error
copy ..\src\Pkcs11Interop\Pkcs11Interop.StrongName\bin\Release\Pkcs11Interop.StrongName.dll net45 || goto :error
copy ..\src\Pkcs11Interop\Pkcs11Interop.StrongName\bin\Release\Pkcs11Interop.StrongName.xml net45 || goto :error

@echo *** BUILD NET45 SUCCESSFUL ***
@endlocal
@exit /b 0

:error
@echo *** BUILD NET45 FAILED ***
@endlocal
@exit /b 1
