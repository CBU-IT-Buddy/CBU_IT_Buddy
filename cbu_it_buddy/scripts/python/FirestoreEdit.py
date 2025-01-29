import os
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore


# Initialize Firestore

##########################################################
# Update API JSON path
##########################################################
cred = credentials.Certificate("/Users/dustie1/Documents/CBU/SP25/cbu-it-buddy-2d42e936a39c.json")
firebase_admin.initialize_app(cred)


# Initialize Firestore client
db = firestore.Client()

# Reference the collection
solutions_collection = db.collection('solutions')