# -*- coding: utf-8 -*-
"""
Created on Wed Jul 15 19:00:05 2020

@author: Andres Angeles Albores

View functions go here
"""

from flask import render_template, flash, redirect, url_for
from app import app
from app.forms import LoginForm

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
    return render_template('index.html', title = 'Home', user = user, posts = posts)

@app.route('/login', methods = ['GET', 'POST']) # App is able to handle GET & POST requests
def login():
    form = LoginForm()
    if form.validate_on_submit():
        # flash() stores the message we want to show the user. We have
        # to add some code to the HTML to be able to retrieve & display the message
        flash('Login requested for user {}, remember_me = {}'.format(form.username.data, form.remember_me.data))
        return redirect(url_for('index'))
    return render_template('login.html', title = 'Sign In', form = form)