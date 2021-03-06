import requests, zipfile
import io
import json
import os

from progress.bar import Bar

class CONFIG:
	PROJECT_ID = "12031087"
	GITLAB_URL =  "https://gitlab.com/api/v4/"
	API_KEY = "cmEfYKMPqJVjhsWKc_9V"
	EXTRACT_DIR = "data/"

class NewsItem(object):
	def __init__(self, data):
		self.data = data
		self.id = data['title']
	
	def __hash__(self):
		return hash(self.id)

	def __eq__(self, other):
		return isinstance(other, NewsItem) and self.id == other.id

	def __repr__(self):
		return "NewsItem: {0}".format(self.id)

def get_finished_jobs():
	url = (CONFIG.GITLAB_URL+"projects/{0}/jobs?scope[]=success").format(CONFIG.PROJECT_ID)
	r = requests.get(url, headers={"PRIVATE-TOKEN":CONFIG.API_KEY}) 
	return json.loads(r.content)

def download_artifact(job_id, extract_dir):
	url = (CONFIG.GITLAB_URL+"projects/{0}/jobs/{1}/artifacts").format(CONFIG.PROJECT_ID, job_id)
	r = requests.get(url, headers={"PRIVATE-TOKEN": CONFIG.API_KEY}, stream=True)
	z = zipfile.ZipFile(io.BytesIO(r.content))
	if not os.path.exists(extract_dir):
		os.makedirs(extract_dir)
	z.extractall(extract_dir)

def download_all_artifacts(extract_dir):
	jobs = get_finished_jobs()
	bar = Bar('Downloading artifacts', max=len(jobs))
	for j in jobs:
		download_artifact(j['id'], extract_dir)
		bar.next()
	bar.finish()

def read_all_artifacts(extract_dir):
	all_news = set()
	for file in os.listdir(extract_dir):
		full_filename = "%s/%s" % (extract_dir, file)
		with open (full_filename, 'r') as fi:
			print(full_filename)
			artifact_news = json.load(fi)
			for n in artifact_news['_default'].values():
				all_news.add(NewsItem(n))
	return all_news
download_all_artifacts(CONFIG.EXTRACT_DIR)
print (len(read_all_artifacts(CONFIG.EXTRACT_DIR)))