#!/bin/ksh

doas pkg_add gnome-themes-extra

# gtk2
if [ ! -f $HOME/.gtkrc-2.0 ]; then
	{
		print "[Settings]"
		print "gtk-icon-theme-name=\"Adwaita\""
		print "gtk-theme-name=\"Adwaita\""
		print "gtk-application-prefer-dark-theme=true"
	} >>$HOME/.gtkrc-2.0
fi

# gtk3
if [ ! -f $HOME/.config/gtk-3.0/settings.ini ]; then
	{
		print "[Settings]"
		print "gtk-icon-theme-name=Adwaita"
		print "gtk-theme-name=Adwaita"
		print "gtk-font-name=DejaVu Sans 11"
		print "gtk-application-prefer-dark-theme=true"
	} >>$HOME/.config/gtk-3.0/settings.ini
fi
