PHP Code Deobfuscator
=====================

## Quick Start

* Remember: deobfuscate.sh is a **Linux commandline tool**
* Make sure you have "php-cli" and "ltrace" installed on your system
* Fetch a copy of [deobfuscate.sh](https://raw.github.com/technopagan/php-code-deobfuscator/master/deobfuscate.sh) and place it somewhere you deem a good place for 3rd party shellscripts, e.g. "/usr/local/bin". Make sure the location is in the PATH of the user(s) who will run deobfuscate.sh and ensure that the script is executable (chmod -x).
* You can now run "bash deobfuscate.sh /path/to/obfuscated/php/script.php" to retrieve the original, human-readable version of the PHP source code  

## Reasoning

As freelance web-developers, software engineers or web performance consultants we are often called to work on existing projects with a diverse code base. Sadly, sometimes this includes obfuscated PHP code: 

    <?php $_F=__FILE__;$_X='XYZABCDEFGHIJKLMNOPQRSTUVW123456789=='));?>

The reason is that some 3rd-party plugin developers fear that people might steal their code and thus ruin their business. While some of these developers can be contacted and asked for a human-readable version of their code in order for us to debug it, others are either not around anymore or refuse to cooperate because fear is not a thing to be reasoned with.

In order for us to still do our jobs of analyzing & optimizing code, I created this Bash script. 

## How It Works

Obfuscation simply makes PHP code less human-readable. It still needs to be parseable by PHP. So the first thing that happens in the background during runtime of an obfuscated script is its deobfuscation so it once again becomes plain PHP code that can be executed. During normal operation, this is a step that is not visible to the user as it happens in memory. Using ltrace, we can retrieve this unobfuscated state of the script from memory and save it as a file, thus enabling us to read & understand the actual code.
