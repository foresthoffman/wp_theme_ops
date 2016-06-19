# This file is meant to go with the theme_zip.sh script. If it's missing
# go grab it at "https://github.com/foresthoffman/wp_theme_ops"...Otherwise, 
# this script is essentially useless.
#
# theme_zip.sh has instructions included at the top of the file, make sure to read them
# if this all seems unclear.

import re
import sys
import os.path

if len( sys.argv ) > 1:
	themeName = None
	themeVersion = None
	nameRegex = re.compile( "^Theme Name:\s?([^\n]*)$" )
	versionRegex = re.compile( "^Version:\s?([^\n]*)$" )
	filePath = sys.argv[1] + "/style.css"
	if os.path.isfile( filePath ):
		with open( filePath ) as f:
			for line in f:
				nameMatch = nameRegex.match( line )
				if nameMatch is not None:
					themeName = nameMatch.group( 1 )
				versionMatch = versionRegex.match( line )
				if versionMatch is not None:
					themeVersion = versionMatch.group( 1 )

	if ( themeName is not None and themeVersion is not None ):
		print themeName + ";" + themeVersion