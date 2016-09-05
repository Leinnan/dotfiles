#!/usr/bin/python3

#-*- coding: utf-8 -*-
from bs4 import BeautifulSoup
import urllib.request
import os, random


def get_newest_wallpaper():
	resp = urllib.request.urlopen("http://www.wykop.pl/tag/jdfoto/")
	soup = BeautifulSoup(resp, "html.parser")
	for link in soup.find_all('div'):
		if not (link.get('class') is None):
			if link.get('class')[0] in "media-content":
				return link.a.get('href')

def get_random_wallpaper():
	resp = urllib.request.urlopen("http://www.wykop.pl/tag/jdfoto/")
	soup = BeautifulSoup(resp, "html.parser")
	wallpaper_array = []

	for link in soup.find_all('div'):
		if not (link.get('class') is None):
			if link.get('class')[0] in "media-content":
				wallpaper_array.append(link.a.get('href'))
	if len(wallpaper_array) > 0:
		return random.choice(wallpaper_array)




os.system("wget " + get_newest_wallpaper() + " -O /home/piotr/.wykop_wallpaper.jpg")
#os.system("wget " + get_random_wallpaper() + " -O /home/piotr/.wykop_wallpaper.jpg")
os.system("feh --bg-scale /home/piotr/.wykop_wallpaper.jpg")
