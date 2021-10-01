# -*- coding: utf-8 -*-
"""
Created on Wed Jul 15 23:54:49 2020

@author: Andres Angeles Albores
"""

import os

class Config(object):
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'you-will-never-guess'