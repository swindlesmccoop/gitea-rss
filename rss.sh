#!/bin/sh


if [ -f rss.xml ]; then
	while true; do
		sleep 60
		USERNAME=swindlesmccoop
		curl -o "$USERNAME".html "https://git.cbps.xyz/$USERNAME?tab=activity"
	done
	else
		read -p "Blog name: " BLOGNAME
		read -p "Description of blog: " BLOGDESC
		read -p "Blog language (if you don't know, enter 'en-us'): " BLOGLANG
		printf '<?xml version="1.0" encoding="utf-8"?>\n<?xml-stylesheet type="text/css" href="rss.css" ?>\n<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">\n\n<channel>\n<title>"$BLOGNAME"'
fi
