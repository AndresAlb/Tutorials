"""
Created on Wed Jul 15 18:45:40 2020

@author: Andres Angeles Albores

App initializer
"""

from flask import Flask 
from config import Config
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import LoginManager
import logging
from logging.handlers import SMTPHandler, RotatingFileHandler
import os
from flask_mail import Mail
from flask_bootstrap import Bootstrap
from flask_moment import Moment

app = Flask(__name__)
app.config.from_object(Config)

# Initialize the database & the migration engine objects
db = SQLAlchemy(app)
migrate = Migrate(app, db)

# Initialize the login manager to let the application
# remember user logins
login = LoginManager(app)
login.login_view = 'login'

# Initialize a Mail instance
# Launch Python simulated email server: 
# > set MAIL_SERVER = localhost
# > set MAIL_PORT = 8025
# Launch a new terminal and launch the server
# > python -m smtpd -n -c DebuggingServer localhost:8025
mail = Mail(app)

# Configure an SMTPHandler to send emails to an 
# admins. email account
if not (app.debug):
    if app.config['MAIL_SERVER']:
        auth = None
        if app.config['MAIL_USERNAME'] or app.config['MAIL_PASSWORD']:
            auth = (app.config['MAIL_USERNAME'], app.config['MAIL_PASSWORD'])
        secure = None
        if app.config['MAIL_USE_TLS']:
            secure = ()
        mail_handler = SMTPHandler(
            mailhost = (app.config['MAIL_SERVER'], app.config['MAIL_PORT']),
            fromaddr = 'no-reply@' + app.config['MAIL_SERVER'],
            toaddrs = app.config['ADMINS'], subject = 'Hello World Failure',
            credentials = auth, secure = secure)
        mail_handler.setLevel(logging.ERROR)
        app.logger.addHandler(mail_handler)
    if not os.path.exists('logs'):
        os.mkdir('logs')
    file_handler = RotatingFileHandler('logs/helloworldblog.log', maxBytes = 10240, backupCount = 10)
    file_handler.setFormatter(logging.Formatter('%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]'))
    file_handler.setLevel(logging.INFO)
    app.logger.addHandler(file_handler)

    app.logger.setLevel(logging.INFO)
    app.logger.info('Hello World startup')

# Initialize an instance of the Bootstrap extension
bootstrap = Bootstrap(app)

# Initialize an instance of the flask_moment date-time 
# extension. 
moment = Moment(app) 

# The models module will define the structure of the database
from app import routes, models, errors
