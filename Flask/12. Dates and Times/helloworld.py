# -*- coding: utf-8 -*-
"""
Created on Wed Jul 15 19:04:11 2020

@author: Andres Angeles Albores
"""

from app import app, db
from app.models import User, Post

# Create a shell context that adds the database instance and models 
# to the shell session so we do not have to import db, User, Post, etc.
# everytime we launch a new Python interpreter
@app.shell_context_processor
def make_shell_context():
    return {'db': db, 'User': User, 'Post': Post}