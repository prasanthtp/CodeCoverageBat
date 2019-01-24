 @ECHO OFF

 REM ** Install OpenCover & ReportGenerator nuget packages and update the path below;
 
SET OpenCoverExe="C:\Users\<username>\.nuget\packages\opencover\4.6.519\tools\OpenCover.Console.exe"
SET ReportGeneratorExe="C:\Users\<username>\.nuget\packages\reportgenerator\3.1.2\tools\ReportGenerator.exe"


if not exist "%~dp0GeneratedReports" mkdir "%~dp0GeneratedReports"


call :RunOpenCoverUnitTestMetrics


if %errorlevel% equ 0 ( 
 call :RunReportGeneratorOutput 
)


if %errorlevel% equ 0 ( 
 call :RunLaunchReport 
)
exit /b %errorlevel%

:RunOpenCoverUnitTestMetrics 
 REM ** Make sure dotnet.exe is in the c:\Program Files\dotnet folder
"%OpenCoverExe%" ^
 -target:"c:\Program Files\dotnet\dotnet.exe" ^
 -targetargs:"test -f netcoreapp2.0 -c Release PortalWebApi.tests\PortalWebApi.tests.csproj" ^
   -mergeoutput  ^
  -hideskipped:File  ^
 -output:"%~dp0GeneratedReports\CoverageReport.xml" ^
  -oldStyle  ^
  -filter:"+[PortalWebApi*]* -[PortalWebApi.tests]* -[PortalWebApi]PortalWebApi.Program -[PortalWebApi]PortalWebApi.Startup -[PortalWebApi]PortalWebApi.Data.ApplicationDbContext -[PortalWebApi]PortalWebApi.Data.OPSCaseManagementSystemContext -[PortalWebApi]PortalWebApi.Entities.* "^
  -searchdirs:PortalWebApi.tests\bin\Release\netcoreapp2.0 ^
   -register:user ^
  
  REM ** https://github.com/opencover/opencover/wiki/Usage  Check for Filter syntax
 
exit /b %errorlevel%

:RunReportGeneratorOutput
"%ReportGeneratorExe%" ^
 -reports:GeneratedReports\CoverageReport.xml ^
 -targetdir:GeneratedReports  ^
 -verbosity:Error 
exit /b %errorlevel%

:RunLaunchReport
start "report" "GeneratedReports\index.htm"
exit /b %errorlevel%