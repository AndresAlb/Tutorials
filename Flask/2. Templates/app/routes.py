# -*- coding: utf-8 -*-
"""
Created on Wed Jul 15 19:00:05 2020

@author: Andres Angeles Albores

View function
"""

from flask import render_template
from app import app

@app.route('/')
@app.route('/index')
def index():
    user = {'username': 'Andres'}
    posts = [
        {
            'author': {'username': 'John'},
            'body': 'Beautiful day in Portland!'
        },
        {
            'author': {'username': 'Susan'},
            'body': 'The Avengers movie was so cool!'
        }
    ]
    return render_template('simplified_index.html', title = 'Home', user = user, posts = posts)