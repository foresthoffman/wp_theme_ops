Simple Dev-ops Tools (for WordPress Themes)
===========================

# How to use:

1. Stick this script and it's corresponding python script (get_theme_info.py) in the wp-content/themes/ directory in your WordPress installation.
2. Create the theme. The style.css file should be present, in the theme, and contain the name of the theme and it's version. The name and version number will be used to name the themes zips in the adjacent dist/ directory.
3. Create a dist/ directory in wp-content/themes/, on the same level as your theme.
4. Make any changes you want to your theme and then run this script, providing the name of the theme's directory as an argument.
	
``` bash
# for example
source theme_zip.sh super_cool_theme
```
	
Make sure that this file is executable. If it isn't, run the following:

NOTE: This will give __everyone__ (the user and group that owns the file, and the public) the ability to execute the file. __BE CAREFUL__ when running the following command on remote server files. See more information on Unix file permissions [here](https://help.ubuntu.com/community/FilePermissions).

``` bash
# by modifying the [[u|g|o][+|-][w|r|x]] option, the file's access can be restricted safely.
sudo chmod +x theme_zip.sh
```