# -*- coding: utf-8 -*-
"""
Created on Mon Jul 20 19:52:59 2020

@author: Andres Angeles Albores

Database models go here
"""

from datetime import datetime
from app import db

# Alembic (the migration framework used by Flask-Migrate) allows us
# to make changes to the database structure in a way that does not 
# require the database to be recreated from scratch by mantaining a
# migration repository. To build the repository, you must type 
# a series of commands in the terminal:
# > set FLASK_APP = helloworld.py
# > flask db init
# > flask db migrate -m "optional comment"
# To apply or undo changes to the database, use the command 
# 'flask db upgrade' or 'flask db downgrade'

# You can add elements to a database from the python terminal in the
# context of a session, which can be accessed through the command 
# 'db.session'. You can make multiple changes in a single session and 
# you can write the changes with 'db.session.commit()'. The command
# 'db.session.rollback()' will abort the session and remove any changes
# stored in it.

# Learn how to make database queries by checking the Flask-SQLAlchemy docs: 
#       http://packages.python.org/Flask-SQLAlchemy/index.html


# The database consists of users. Every user will have
# an id (integer), a username (varchar), an email (varchar)
# and passowrd hash fields (varchar). For added security, 
# we do not store passwords in our database. Instead, we store
# password hash fields

class User(db.Model):
    id = db.Column(db.Integer, primary_key = True)
    username = db.Column(db.String(64), index = True, unique = True)
    email = db.Column(db.String(120), index = True, unique = True)
    password_hash = db.Column(db.String(128))
    posts = db.relationship('Post', backref = 'author', lazy = 'dynamic')
    
    def __repr__(self):
        return '<User {}>'.format(self.username)

# Every user can make many posts. Each post will have
# an id (integer), a body (varchar), a timestamp (DateTime)
# and the ID of the user that published the post (Foreign Key, integer)

class Post(db.Model):
    id = db.Column(db.Integer, primary_key = True)
    body = db.Column(db.String(140))
    timestamp = db.Column(db.DateTime, index = True, default = datetime.utcnow)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    
    def __repr__(self):
        return '<Post {}'.format(self.body)