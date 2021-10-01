# -*- coding: utf-8 -*-
"""
Created on Wed Jul 15 23:54:49 2020

@author: Andres Angeles Albores
"""

import os

basedir = os.path.abspath(os.path.dirname(__file__))

class Config(object):
    # Prevent CSRF attack on web forms
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'you-will-never-guess'
    
    # Define the location of the app's database
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
    'sqlite:///' + os.path.join(basedir, 'app.db')
    
    SQLALCHEMY_TRACK_MODIFICATIONS = False