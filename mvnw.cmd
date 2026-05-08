@REM ----------------------------------------------------------------------------
@REM Licensed to the Apache Software Foundation (ASF) under one
@REM or more contributor license agreements.  See the NOTICE file
@REM distributed with this work for additional information
@REM regarding copyright ownership.  The ASF licenses this file
@REM to you under the Apache License, Version 2.0 (the
@REM "License"); you may not use this file except in compliance
@REM with the License.  You may obtain a copy of the License at
@REM
@REM    https://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing,
@REM software distributed under the License is distributed on an
@REM "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
@REM KIND, either express or implied.  See the License for the
@REM specific language governing permissions and limitations
@REM under the License.
@REM ----------------------------------------------------------------------------

@REM Apache Maven Wrapper startup batch script, version 3.3.2

@IF "%__MVNW_ARG0_NAME__%"=="" (SET "BASE_DIR=%~dp0") ELSE SET "BASE_DIR=%__MVNW_ARG0_NAME__%"

@SET MAVEN_PROJECTBASEDIR=%MAVEN_BASEDIR%
@IF NOT "%MAVEN_PROJECTBASEDIR%"=="" GOTO endDetectBaseDir

@SET EXEC_DIR=%CD%
@SET WDIR=%EXEC_DIR%
:findBaseDir
@IF EXIST "%WDIR%"\.mvn GOTO baseDirFound
@cd ..
@SET WDIR=%CD%
@IF NOT "%WDIR%"=="%CD%" GOTO findBaseDir
:baseDirFound
@SET MAVEN_PROJECTBASEDIR=%WDIR%
@cd "%EXEC_DIR%"
:endDetectBaseDir

@SET WRAPPER_JAR="%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.jar"
@SET WRAPPER_PROPERTIES="%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.properties"
@SET WRAPPER_DOWNLOADER_PROPERTIES_SUPPORTED=false

@FOR /F "usebackq tokens=1,* delims==" %%A IN ("%WRAPPER_PROPERTIES%") DO (
    @IF "%%A"=="wrapperUrl" SET WRAPPER_URL=%%B
    @IF "%%A"=="distributionUrl" SET DISTRIBUTION_URL=%%B
)

@IF NOT EXIST %WRAPPER_JAR% (
    @IF NOT "%MVNW_REPOURL%"=="" (
        @SET WRAPPER_URL=%MVNW_REPOURL%/org/apache/maven/wrapper/maven-wrapper/3.3.2/maven-wrapper-3.3.2.jar
    )
    @IF "%WRAPPER_URL%"=="" (
        @SET WRAPPER_URL=https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.3.2/maven-wrapper-3.3.2.jar
    )
    @ECHO Downloading: %WRAPPER_URL%
    @powershell -Command "&{"^
        "$webclient = new-object System.Net.WebClient;"^
        "if (-not ([string]::IsNullOrEmpty('%MVNW_USERNAME%') -and [string]::IsNullOrEmpty('%MVNW_PASSWORD%'))) {"^
        "$webclient.Credentials = new-object System.Net.NetworkCredential('%MVNW_USERNAME%', '%MVNW_PASSWORD%');"^
        "}"^
        "$webclient.DownloadFile('%WRAPPER_URL%', %WRAPPER_JAR%)"^
        "}"
    @IF "%ERRORLEVEL%"=="0" GOTO execute
    @DEL /F %WRAPPER_JAR%
    @ECHO ERROR: Failed to download %WRAPPER_URL%
    @EXIT /B 1
)

:execute
@IF "%JAVA_HOME%"=="" (SET JAVACMD=java) ELSE SET JAVACMD=%JAVA_HOME%/bin/java

@"%JAVACMD%" ^
  %MAVEN_OPTS% ^
  %MAVEN_DEBUG_OPTS% ^
  -classpath %WRAPPER_JAR% ^
  "-Dmaven.multiModuleProjectDirectory=%MAVEN_PROJECTBASEDIR%" ^
  org.apache.maven.wrapper.MavenWrapperMain %*
