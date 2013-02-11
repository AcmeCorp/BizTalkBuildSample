%windir%\Microsoft.NET\Framework64\v4.0.30319\msbuild.exe ..\Scripts\AcmeCorp.BizTalkBuildSample.Build.proj /m /t:GenerateConfigurationFiles /consoleloggerparameters:Verbosity=minimal /fileLogger /fileLoggerParameters:LogFile=GenerateConfigurationFiles.msbuild.log;verbosity=diagnostic
ECHO.
pause
