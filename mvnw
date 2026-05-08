#!/bin/sh
# ----------------------------------------------------------------------------
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Apache Maven Wrapper startup batch script, version 3.3.2
# ----------------------------------------------------------------------------

set -e

# Find the project base dir, i.e. the directory that contains the folder ".mvn".
find_maven_basedir() {
  if [ -z "$1" ]; then
    echo "Path not specified to find_maven_basedir" 1>&2
    return 1
  fi
  basedir="$1"
  wdir="$1"
  while [ "$wdir" != '/' ]; do
    if [ -d "$wdir"/.mvn ]; then
      basedir=$wdir
      break
    fi
    wdir=$(
      cd "$wdir/.." || exit 1
      pwd
    )
  done
  printf '%s' "$(cd "$basedir" || exit 1; pwd)"
}

# concatenates all lines of a file
concat_lines() {
  if [ -f "$1" ]; then
    # Remove \r in case we run on Windows within Git Bash
    # and check output string is not empty
    MVNW_VERBOSE="$(tr -d '\015' <"$1")"
    [ -n "$MVNW_VERBOSE" ] && printf "%s\n" "$MVNW_VERBOSE"
  fi
}

log() {
  if [ "$MVNW_VERBOSE" = true ]; then
    printf '%s\n' "$1"
  fi
}

BASE_DIR=$(find_maven_basedir "$(dirname "$0")")
MAVEN_PROJECTBASEDIR=${MAVEN_BASEDIR:-"$BASE_DIR"}
export MAVEN_PROJECTBASEDIR
log "$MAVEN_PROJECTBASEDIR"

MAVEN_WRAPPER_PROPERTIES="$MAVEN_PROJECTBASEDIR/.mvn/wrapper/maven-wrapper.properties"
MAVEN_WRAPPER_JAR="$MAVEN_PROJECTBASEDIR/.mvn/wrapper/maven-wrapper.jar"
MVNW_REPOURL=${MVNW_REPOURL:-"https://repo.maven.apache.org/maven2"}

# Parse distribution url
distributionUrl=$(concat_lines "$MAVEN_WRAPPER_PROPERTIES" | grep "^distributionUrl=" | tail -1 | cut -d= -f2-)
if [ -z "$distributionUrl" ]; then
  echo "distributionUrl not found in $MAVEN_WRAPPER_PROPERTIES" 1>&2
  exit 1
fi

# Parse wrapper url
wrapperUrl=$(concat_lines "$MAVEN_WRAPPER_PROPERTIES" | grep "^wrapperUrl=" | tail -1 | cut -d= -f2-)
if [ -z "$wrapperUrl" ]; then
  wrapperUrl="$MVNW_REPOURL/org/apache/maven/wrapper/maven-wrapper/3.3.2/maven-wrapper-3.3.2.jar"
fi

# Download the wrapper jar if necessary
if [ -r "$MAVEN_WRAPPER_JAR" ]; then
  log "Found $MAVEN_WRAPPER_JAR"
else
  log "Couldn't find $MAVEN_WRAPPER_JAR, downloading it ..."
  if command -v wget > /dev/null; then
    log "Found wget ... using wget"
    [ "$MVNW_VERBOSE" = true ] && VERBOSE_OPT="" || VERBOSE_OPT="--quiet"
    if [ -z "$MVNW_USERNAME" ] || [ -z "$MVNW_PASSWORD" ]; then
      wget $VERBOSE_OPT "$wrapperUrl" -O "$MAVEN_WRAPPER_JAR" || rm -f "$MAVEN_WRAPPER_JAR"
    else
      wget $VERBOSE_OPT --http-user="$MVNW_USERNAME" --http-password="$MVNW_PASSWORD" "$wrapperUrl" -O "$MAVEN_WRAPPER_JAR" || rm -f "$MAVEN_WRAPPER_JAR"
    fi
  elif command -v curl > /dev/null; then
    log "Found curl ... using curl"
    [ "$MVNW_VERBOSE" = true ] && VERBOSE_OPT="" || VERBOSE_OPT="--silent"
    if [ -z "$MVNW_USERNAME" ] || [ -z "$MVNW_PASSWORD" ]; then
      curl $VERBOSE_OPT -o "$MAVEN_WRAPPER_JAR" "$wrapperUrl" -f || rm -f "$MAVEN_WRAPPER_JAR"
    else
      curl $VERBOSE_OPT --user "$MVNW_USERNAME:$MVNW_PASSWORD" -o "$MAVEN_WRAPPER_JAR" "$wrapperUrl" -f || rm -f "$MAVEN_WRAPPER_JAR"
    fi
  else
    echo "Couldn't find wget or curl to download $wrapperUrl" 1>&2
    exit 1
  fi
fi

# Determine Java executable
if [ -n "$JAVA_HOME" ]; then
  if [ -x "$JAVA_HOME/jre/sh/java" ]; then
    JAVACMD="$JAVA_HOME/jre/sh/java"
  else
    JAVACMD="$JAVA_HOME/bin/java"
  fi
  if [ ! -x "$JAVACMD" ]; then
    echo "The JAVA_HOME environment variable is not defined correctly." 1>&2
    echo "($JAVA_HOME/bin/java is not executable)" 1>&2
    exit 1
  fi
else
  JAVACMD="java"
  if ! command -v java > /dev/null 2>&1; then
    echo "The JAVA_HOME environment variable is not defined and java is not in the PATH." 1>&2
    exit 1
  fi
fi

# Exec the wrapper
exec "$JAVACMD" \
  $MAVEN_OPTS \
  $MAVEN_DEBUG_OPTS \
  -classpath "$MAVEN_WRAPPER_JAR" \
  "-Dmaven.multiModuleProjectDirectory=$MAVEN_PROJECTBASEDIR" \
  org.apache.maven.wrapper.MavenWrapperMain "$@"
