# Inspired by https://towardsdatascience.com/using-gitlabs-ci-for-periodic-data-mining-b3cc314ecd85


import logging
import requests
import xmltodict
import time
import sys

from tinydb import TinyDB

RSS_FEED_URL  = "http://feeds.reuters.com/reuters/businessNews"

logging.basicConfig(stream=sys.stdout, level=logging.INFO)
logger = logging.getLogger(__name__)

def fetch_news(*, db_path):
	logger.info("Fetching news...")

	rss_content = requests.get(RSS_FEED_URL).text
	parsed_feed = xmltodict.parse(rss_content)

	logger.info('Found %d items in RSS feed.' % (len(parsed_feed['rss']['channel']['item'])))

	db = TinyDB(db_path)
	for item in parsed_feed['rss']['channel']['item']:
		db.insert(item)
	
	logger.info('Stored %d items in DB.' % (len(parsed_feed['rss']['channel']['item'])))

def get_stored_news(*, db_path):
	return TinyDB(db_path).all()

if __name__ == '__main__':
	fetch_news(db_path="news_{}.json".format(int(time.time())))