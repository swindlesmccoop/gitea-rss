# Gitea-RSS
My goal with this project is to bring general user activity to RSS feed readers. Other sites let you make feeds for issue trackers and repo commits, but none let you make a feed for all user activity shown on a user profile. Hence, this project.

## TODO
The problem with getting this part done is that sed and grep have limited capabilities, making it hard to actually get data from the raw HTML. I may be able to use the API or Webhooks or something to get it done, but until then, all I can do is create a skeleton RSS files based on the HTML. If you have any ideas on how to get the data I need from the raw HTML, please submit a PR or an Issue and I will try to tend to it as quick as possible.

The things I want to include in the RSS feed:

### Title
swindlesmccoop pushed to master at swindlesmccoop/gitea-rss

### Description
2c20ffebe4: Initial commit
### Date
Wed, 23 Feb 2022 14:26:27 +0000
### Commit link
https://git.cbps.xyz/swindlesmccoop/gitea-rss/commit/2c20ffebe4b555a3460fd361a8a5e89e31c157d0

It would pretty much look like this in the end:
```
<item>
<title>swindlesmccoop pushed to master at swindlesmccoop/gitea-rss</title>
<guid>https://git.cbps.xyz/swindlesmccoop/gitea-rss/commit/2c20ffebe4b555a3460fd361a8a5e89e31c157d0</guid>
<pubDate>Wed, 23 Feb 2022 14:26:27 +0000</pubDate><description><![CDATA[
<p>2c20ffebe4: Initial commit</p>
]]></description>
</item>
```
