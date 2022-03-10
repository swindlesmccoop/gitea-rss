#!/bin/sh

#fill out your information here
USERNAME="swindlesmccoop"
GITSITE="https://git.cbps.xyz"

#how many posts to show at a time
POSTNUM=10

#cooldown between updates (in seconds)
UPDATEINTERVAL=10

FULLURL="$GITSITE"/"$USERNAME"
USERAGENT="Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36"

make_rss () {
	BLOGNAME="$USERNAME at $(echo $GITSITE | sed "s|https://||g")"
	BLOGDESC="$(curl -A "$USERAGENT" -sL $FULLURL?tab=activity | grep -o -P '(?<=<meta property="og:description" content=").*(?=">)')"
	printf '<?xml version="1.0" encoding="utf-8"?>\n<?xml-stylesheet type="text/css" href="rss.css" ?>\n<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">\n\n<channel>\n<title>' > rss.xml
	printf "$BLOGNAME" >> rss.xml
	printf '</title>\n<description>' >> rss.xml
	printf "$BLOGDESC" >> rss.xml
	printf '</description>\n<language>en-us</language>\n<link>' >> rss.xml
	printf "$FULLURL" >> rss.xml
	printf '</link>\n\n<!-- Activity -->\n\n' >> rss.xml
}	

update_rss () {
	make_rss
	curl -A "$USERAGENT" -sLo "$USERNAME".html "$FULLURL?tab=activity"
	SEQNUM=1
	#EVER TRY PARSING HTML WITH PLAIN COREUTILS?? NOT FUN!!!!!!
	for i in $(seq $POSTNUM); do
		TITLE=$(awk "/push news/{i++}i==$SEQNUM" "$USERNAME.html" | grep -A 7 "push news" | sed "1,7d" | sed "s/				//g" | sed 's/<a href=\"[^"]*\" rel="nofollow">//g' | sed 's/<\/a>//g' | sed 's/^./\u&/')
		PUBDATE=$(grep -o -P '(?<=<span class="time-since" title=").*(?= UTC)' "$USERNAME.html" | sed -n "$SEQNUM"p)
		DESCRIPTION="$(grep -A 1 '<span class="text truncate light grey">' $USERNAME.html -m $SEQNUM | tail -n 1 | sed "s/	//g" | sed "s/&#39;/'/g" | sed 's/<a href=\"[^"]*//g' | sed 's/<\/a>//g' | sed 's/ " class="link"//g' | sed 's/>/ /g')"
		URL="$(grep -o 'mr-2" href=".*' $USERNAME.html -m $SEQNUM | tail -n 1 | sed "s/\///" | sed 's/mr-2" href="//g' | sed "s/\">.*<\/a>//g")"
		printf "<item>\n<title>$TITLE</title>\n<guid>$GITSITE/$URL</guid>\n<pubDate>$PUBDATE +0000</pubDate><description><![CDATA[\n<p>$DESCRIPTION</p>\n]]></description>\n</item>\n\n"
		SEQNUM=$(expr $SEQNUM + 1)
	done
}

if [ -f rss.xml ]; then
	read -r -p "Would you like to upload the RSS feed to an FTP server for the duration you run this script? (y/n) " FTP
	if [ $FTP = y ]; then
		read -r -p "Username: " FTPUSERNAME
		stty -echo
		read -r -p "Password: " FTPPASSWORD
		stty echo
		echo ""
		read -r -p "Endpoint: " ENDPOINT
	fi
	while true; do
		update_rss >> rss.xml
		if [ $FTP = y ]; then
			lftp "$ENDPOINT" <<EOF
			user "$FTPUSERNAME" "$FTPPASSWORD"
			put rss.xml
			exit
EOF
		fi
		echo "Updated RSS feed!"
		sleep $UPDATEINTERVAL
	done
	else
		make_rss
		echo "RSS feed created! Please run the script again to start updating it."
fi
