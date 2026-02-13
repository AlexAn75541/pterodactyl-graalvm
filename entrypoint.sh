#!/bin/bash

#
# Copyright (c) 2021 Matthew Penner
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Set JAVA_HOME based on JVM_RUNTIME (default: temurin)
JVM_RUNTIME=${JVM_RUNTIME:-temurin}
export JAVA_HOME="/opt/java/${JVM_RUNTIME}"

# Check if the selected JVM runtime exists
if [ ! -d "${JAVA_HOME}" ]; then
    echo "ERROR: JVM runtime '${JVM_RUNTIME}' is not available in this image."
    echo "Available runtimes:"
    ls -1 /opt/java/ 2>/dev/null || echo "  (none found)"
    echo ""
    echo "Please set JVM_RUNTIME to one of the available options."
    exit 1
fi

export PATH="${JAVA_HOME}/bin:${PATH}"

# Switch to the container's working directory
cd /home/container || exit 1

# Some color shit

LIGHT_BLUE='\033[1;34m'
GREEN='\033[0;32m'
RESET_COLOR='\033[0m'

# Print Java version
printf "${LIGHT_BLUE}container@java-info~ ${RESET_COLOR}java -version\n"
java -version 2>&1 | cat
echo ""

# Convert all of the "{{VARIABLE}}" parts of the command into the expected shell
# variable format of "${VARIABLE}" before evaluating the string and automatically
# replacing the values.
PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")

# Display the command we're running in the output, and then execute it with the env
# from the container itself.
printf "${GREEN}container@game-panel-command~ ${RESET_COLOR}%s\n" "$PARSED"
# shellcheck disable=SC2086
eval ${PARSED}
