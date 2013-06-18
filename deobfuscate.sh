#!/bin/bash

###############################################################################
#
# PHP Code De-Obfuscator
#
# Usage: bash deobfuscate.sh /path/to/obfuscated/php/script.php
#
###############################################################################
#
# Tools that need to be pre-installed:
#
#	* php5-cli
#
# 	* ltrace
# 
###############################################################################
# 
# This software is published under the BSD licence 3.0
# 
# Copyright (c) 2013, Tobias Baldauf
# All rights reserved.
#
# Mail: kontakt@tobias-baldauf.de
# Web: http://who.tobias.is/
# Twitter: @tbaldauf
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#	* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#
#	* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
#	* Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
###############################################################################



###############################################################################
# Configuration
###############################################################################

# Accept the obfuscated PHP script as input parameter
INPUTFILE="$1"

# If the script cannot find the php commandline tool, define its name here 
# Possible values: autodetect, php5-cgi, php-cli etc.
# Default: autodetect
PHP5="autodetect"

# If the script cannot find ltrace, define its CLI name here 
# Possible values: autodetect, ltrace etc.
# Default: autodetect
LTRACE="autodetect"



###############################################################################
# MAIN PROGRAM
###############################################################################

# Wrapping the main program to allow defering function definitions
main() {

	# In case this deobfuscator is called without a script to process,
	# remind people how to use it & quit
	if  [ ! -f "$INPUTFILE" ]; then
		echo "Missing an input file. Call this script like this: $0 /path/to/obfuscated/php/script.php"
		exit 1
	fi

	# Use our findcommandlinetool function to find the a handle for PHP
	findcommandlinetool PHP5 $PHP5 php5 php
	PHP5=${COMMANDLINETOOL}

	# Use our findcommandlinetool function to find a proper handle for ltrace
	findcommandlinetool LTrace $LTRACE ltrace
	LTRACE=${COMMANDLINETOOL}

	# Launch the actual deobfuscation process
	deobfuscate
}




###############################################################################
# FUNCTIONS
###############################################################################

# Find the proper callname for the required commandline tool
findcommandlinetool () {
	# Take the parameters given at function call as input
	NAME="$1"
	shift
	# For each possible name input of the tool, test if its actually available
	for i in "$@"; do
		COMMANDLINETOOL=$(type -p $i)
		# If 'type -p' returned something, we now have our proper handle
		if [ "$COMMANDLINETOOL" ]; then
			break
		fi
	done
	# In case none of the given inputs works, apologize & quit
	if [ ! "$COMMANDLINETOOL" ]; then
		echo "Unable to find ${NAME}. Please ensure that it is installed, set its CLI name in the configuration section of this script and then retry."
		exit 1
	fi
}

# Deobfuscate an obfuscated PHP code block by retrieving its unobfuscated state from memory during runtime
deobfuscate () {
	# Use ltrace with a sufficiently large buffer to grab the memory block of PHP during its runtime and retrieve its deobfuscated state
	echo -e "$(${LTRACE} -e memcpy -s 524288 ${PHP5} ${INPUTFILE} 2>&1 > /dev/null | grep ', "[?%]><[?%]' | head -1 | sed 's/^memcpy([^"]*".>//; s/"[^"]*$//')" | sed 's/\r$//' > ${INPUTFILE}.decoded.php
	# Give a nice human-readable success notification
	echo "Successfully deobfuscated the script and saved the result as ${INPUTFILE}.decoded.php."
}

# Finally, launch the main program
main



###############################################################################
# EOF
###############################################################################
