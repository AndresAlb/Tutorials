# -*- coding: utf-8 -*-
"""
Created on Wed Jul 15 19:00:05 2020

@author: Andres Angeles Albores

View function
"""

from app import app

@app.route('/')
@app.route('/index')
def index():
    return "Hello, World!"