import os
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore


# Initialize Firestore

##########################################################
# Update API JSON path
##########################################################
cred = credentials.Certificate(".json")
firebase_admin.initialize_app(cred)


# Initialize Firestore client
db = firestore.Client()

# Reference the collection
solutions_collection = db.collection('solutions')

# Method to print amount of documents in the collection
def print_collection_size():

    # Count the number of documents in the collection
    docs = solutions_collection.stream()
    doc_count = sum(1 for _ in docs)
    print(f"Number of documents in the collection: {doc_count}")

# Loop through the text folder
text_folder = 'scripts/java/PDFProcessor/text'
for filename in os.listdir(text_folder):
    if filename.endswith('.txt'):
        file_path = os.path.join(text_folder, filename)
        with open(file_path, 'r') as file:

            # Read the content of the file
            content = file.read()
            link = ''
            for line in content.splitlines():

                # Check if the line contains a link
                if 'https://' in line:

                    # Extract the link from the line which removes characters after
                    link = line.split(' ')[0]
                    break

            # If no https link is found, set link to an empty string
            if not link:
                link = ''
            
            # Format the title of the document
            title = filename.replace(' _ Knowledge Base _ California Baptist University_formatted.txt', '')

            document_data = {
                "content": content,
                "link": link,
                "summary": "",
                "title": filename
            }

            # Check if a document with the same title already exists
            existing_docs = solutions_collection.where('title', '==', filename).stream()
            
            # If a document with the same title exists
            if any(existing_docs):
                print(f"Document with title {filename} already exists.")
            else:

                # Add the document to the collection
                try:
                    solutions_collection.add(document_data)
                    print(f"Document for {filename} uploaded successfully.")
                except Exception as e:
                    print(f"Failed to upload document for {filename}: {e}")

# Print the number of documents in the collection
print_collection_size()