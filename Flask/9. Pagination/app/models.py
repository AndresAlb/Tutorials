# -*- coding: utf-8 -*-
"""
Created on Mon Jul 20 19:52:59 2020

@author: Andres Angeles Albores

Database models go here
"""
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import UserMixin
from datetime import datetime
from app import db, login
from hashlib import md5

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

# Auxiliary table to associate users and
# their followers
followers = db.Table('followers',
    db.Column('follower_id', db.Integer, db.ForeignKey('user.id')),
    db.Column('followed_id', db.Integer, db.ForeignKey('user.id')))

class User(UserMixin, db.Model):
    #The Flask-Login extension works with the 
    # application's user model, and expects certain 
    # properties and methods to be implemented in it.
    # Flask-Login provides a mixin class called 
    # UserMixin that includes generic 
    # implementations that are appropriate for most 
    # user model classes

    id = db.Column(db.Integer, primary_key = True)
    username = db.Column(db.String(64), index = True, unique = True)
    email = db.Column(db.String(120), index = True, unique = True)
    password_hash = db.Column(db.String(128))
    posts = db.relationship('Post', backref = 'author', lazy = 'dynamic')
    about_me = db.Column(db.String(140))
    last_seen = db.Column(db.DateTime, default = datetime.utcnow)
    followed = db.relationship('User', secondary = followers, primaryjoin = (followers.c.follower_id == id), secondaryjoin = (followers.c.followed_id == id), backref = db.backref('followers', lazy = 'dynamic'), lazy = 'dynamic')

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def avatar(self, size):
        digest = md5(self.email.lower().encode('utf-8')).hexdigest()
        return 'https://www.gravatar.com/avatar/{}?d=identicon&s={}'.format(digest, size)

    def follow(self, user):
        if not self.is_following(user):
            self.followed.append(user)
    
    def unfollow(self, user):
        if self.is_following(user):
            self.followed.remove(user)

    def is_following(self, user):
        return self.followed.filter(followers.c.followed_id == user.id).count() > 0

    def followed_posts(self):
        followed = Post.query.join(
            followers, (followers.c.followed_id == Post.user_id)).filter(
                followers.c.follower_id == self.id)
        own = Post.query.filter_by(user_id=self.id)
        return followed.union(own).order_by(Post.timestamp.desc())

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

@login.user_loader
def load_user(id):
    return User.query.get(int(id))

