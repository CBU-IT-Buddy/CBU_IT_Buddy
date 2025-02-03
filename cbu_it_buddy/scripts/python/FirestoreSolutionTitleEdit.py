import os
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Initialize Firestore
cred = credentials.Certificate("keys/cbu-it-buddy-2d42e936a39c.json")
firebase_admin.initialize_app(cred)

# Initialize Firestore client
db = firestore.Client()

# Reference the collection
solutions_collection = db.collection('solutions')

# String to remove from the title
string_to_remove = " _ Knowledge Base _ California Baptist University_formatted.txt"

# Get all documents in the collection
docs = solutions_collection.stream()

# Update each document
for doc in docs:
    doc_dict = doc.to_dict()
    if 'title' in doc_dict:
        new_title = doc_dict['title'].replace(string_to_remove, '')
        solutions_collection.document(doc.id).update({'title': new_title})
        print(f"Updated document {doc.id}: {doc_dict['title']} -> {new_title}")
    else:
        print(f"Document {doc.id} does not have {string_to_remove} in the title field.")

print("Title update complete.")