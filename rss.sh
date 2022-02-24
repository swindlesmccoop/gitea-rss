#!/bin/sh
USERNAME=swindlesmccoop
GITSITE="https://git.cbps.xyz"
FULLURL="$GITSITE"/"$USERNAME"
POSTNUM=20

update_rss () {
	curl -A "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36" -sLo "$USERNAME".html "$GITSITE/$USERNAME?tab=activity"
	for i in $(seq $POSTNUM); do
		echo "Not implemented"
	done
}

if [ -f rss.xml ]; then
	while true; do
		update_rss
		sleep 60
	done
	else
		#create rss feed skeleton
		BLOGNAME="$USERNAME at $(echo $GITSITE | sed "s|https://||g")"
		BLOGDESC="$(curl -A "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36" -sL $FULLURL?tab=activity | grep -o -P '(?<=<meta property="og:description" content=").*(?=">)')"
		printf '<?xml version="1.0" encoding="utf-8"?>\n<?xml-stylesheet type="text/css" href="rss.css" ?>\n<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">\n\n<channel>\n<title>' > rss.xml
		printf "$BLOGNAME" >> rss.xml
		printf '</title>\n<description>' >> rss.xml
		printf "$BLOGDESC" >> rss.xml
		printf '</description>\n<language>en-us</language>\n<link>' >> rss.xml
		printf "$FULLURL" >> rss.xml
		printf '</link>\n\n<!-- Activity -->\n\n' >> rss.xml
fi
