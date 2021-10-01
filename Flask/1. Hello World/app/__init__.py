# -*- coding: utf-8 -*-
"""
Created on Wed Jul 15 18:45:40 2020

@author: Andres Angeles Albores

App initializer
"""

from flask import Flask 

app = Flask(__name__)

from app import routes
