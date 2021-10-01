# -*- coding: utf-8 -*-
"""
Created on Wed Jul 15 18:45:40 2020

@author: Andres Angeles Albores

App initializer
"""

from flask import Flask 
from config import Config
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

app = Flask(__name__)
app.config.from_object(Config)

# Initialize the database & the migration engine objects
db = SQLAlchemy(app)
migrate = Migrate(app, db)

# The models module will define the structure of the database
from app import routes, models
