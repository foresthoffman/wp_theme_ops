#!/bin/bash
######
#
# theme_zip.sh: Prepare the target theme for being zipped and store the zip file in a distribution
# 	directory, right next to the theme. Zip files pull theme info (name and version) from the
#	style.css file in the theme.
#
# by: Forest Hoffman (http://forest.stfhs.net/forest)
#
# How to use:
#
# 	1. Stick this script and it's corresponding python script (get_theme_info.py) in the
#		wp-content/themes/ directory in your WordPress installation.
#	2. Create the theme. The style.css file should be present, in the theme, and contain the
#		name of the theme and it's version. The name and version number will be used to name
#		the themes zips in the adjacent dist/ directory.
#	3. Create a dist/ directory in wp-content/themes/, on the same level as your theme.
#	4. Make any changes you want to your theme and then run this script, providing the name of the
#		theme's directory as an argument.
#		
#		e.g.
#		> source theme_zip.sh super_cool_theme
#	
#	Note: Make sure that this file is executable. If it isn't, run the following:
#	> sudo chmod +x theme_zip.sh
#	
#	This will give everyone (the user and group that owns the file, and the public) the ability to
#	execute the file. BE CAREFUL when running the above command on remote server files.
#
# Copyright (C) 2016 Forest J. Hoffman
# 	
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 	
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 	
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
######

targetPath=$1;

if [ -n "$targetPath" ] && [ -d $targetPath ]; then

	isValidResponse=false
	name=$(basename $targetPath);
	themeName='';
	themeVersion=0;
	scriptOutput='';

	# get the version number and the name of the theme from the theme's style.css file
	scriptOutput=$(python get_theme_info.py ./$name);

	while IFS=';' read -ra tempArray; do
		themeName=${tempArray[0]};
		themeVersion=${tempArray[1]};
	done <<< "$scriptOutput"

	echo "Found $themeVersion of $themeName in ./$name";

	read -r -p "Do you want to continue? [y/N] " response;
	if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
		echo "Okay, moving on.";
		isValidResponse=true;
	else
		while [[ -z "$response" || false = "$isValidResponse" ]]; do
			echo "Didn't catch that...";
			read -r -p "Do you want to continue? [y/N] " response;
			if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
				echo "Okay, moving on.";
				isValidResponse=true;
			elif [[ -n "$response" ]]; then
				echo "Alright, bye!";
				break;
			fi
		done
	fi

	# the rest of the program
	if [[ true = "$isValidResponse" ]]; then

		# copy the theme to the distribution directory
		echo "Copying ./$name to dist/$name";
		sudo cp -r ./$name dist/$name;

		# remove the unnecessary development files
		echo "Removing unnecessary files";
		sudo rm -r dist/$name/{.git,.gitignore,.DS_Store,*/.DS_Store,*/*/.DS_Store,sass,js/src} 2>/dev/null;
		
		# zip up the theme using the version number
		cd dist;
		echo "Zipping the theme up";
		zip -rq $name-$themeVersion.zip $name/;
		cd ..;
		
		echo "Removing theme copy in dist/ directory";
		sudo rm -r dist/$name;

		echo "All done. Version $themeVersion of $themeName is ready to be deployed";
	else
		echo "Nothing happened.";
	fi
else
	echo "Make sure the provided directory path exists in or below the current directory, the provided path was: \"$targetPath\"";
fi