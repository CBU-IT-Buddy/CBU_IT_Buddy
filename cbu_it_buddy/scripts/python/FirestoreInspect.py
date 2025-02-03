import os
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

##########################################################
# HOW TO USE THIS SCRIPT
# 1. Select a collection
# 2. Input keyword for title
# 3. Input field to retrieve
# 4. Select document from list
##########################################################

# Initialize Firestore
cred = credentials.Certificate("keys/cbu-it-buddy-2d42e936a39c.json")
firebase_admin.initialize_app(cred)

# Initialize Firestore client
db = firestore.Client()

# Reference the collections
collections = {
    'solutions': db.collection('solutions'),
    'bibleverse': db.collection('bibleverse'),
    'user_feedback': db.collection('user_feedback'),
    'faq': db.collection('faq')
}

# Method to print a separator
def print_separator():
    print()
    print("##########################################################")

# Method to print all the titles in the collection
def print_all_titles(collection):
    print_separator()
    for doc in collection.stream():
        doc_dict = doc.to_dict()
        print(doc_dict['title'])
    print_separator()

# Method to print amount of documents in the collection
def print_collection_size(collection):
    print_separator()
    doc_count = sum(1 for _ in collection.stream())
    print(f"Number of documents in the collection: {doc_count}")
    print_separator()

# Method to return any field from a document given a word in the title
def get_field_from_title(collection, title_word, field):
    print_separator()
    matching_docs = []
    for doc in collection.stream():
        doc_dict = doc.to_dict()
        if title_word in doc_dict['title']:
            matching_docs.append(doc_dict)
    
    if not matching_docs:
        print("No documents found with the given title word.")
        print_separator()
        return None
    
    print("Multiple documents found:")
    for i, doc in enumerate(matching_docs):
        print(f"{i + 1}: {doc['title']}")
    
    selected_index = int(input(f"Enter the number of the document you would like to retrieve the {field}: ")) - 1
    if 0 <= selected_index < len(matching_docs):
        result = matching_docs[selected_index][field]
        print_separator()
        return result
    else:
        print("Invalid selection.")
        print_separator()
        return None

# Method to gain input from the user to select document title word and field
def get_user_input_title():
    title_word = input("Enter a word in the title of the document: ")
    return title_word

# Method to select a collection
def select_collection():
    print_separator()
    print("Select a collection:")
    for i, key in enumerate(collections.keys()):
        print(f"{i + 1}. {key}")
    choice = int(input("Enter your choice: ")) - 1
    if 0 <= choice < len(collections):
        print_separator()
        return list(collections.values())[choice]
    else:
        print("Invalid choice. Please try again.")
        print_separator()
        return select_collection()

# Method to get a valid field from the user
def get_valid_field(collection):
    sample_doc = next(collection.stream()).to_dict()
    available_fields = list(sample_doc.keys())
    while True:
        field = input(f"Enter the field you would like to retrieve (Available fields: {available_fields}): ")
        if field in available_fields:
            return field
        else:
            print(f"The field '{field}' does not exist. Please choose from the available fields.")

# Main method
def main():
    collection = select_collection()
    while True:
        print_separator()
        print("Select an option:")
        print("1. Print all titles")
        print("2. Get field from a document")
        print("3. Exit")
        choice = input("Enter your choice (1/2/3): ")
        
        if choice == '1':
            print_all_titles(collection)
        elif choice == '2':
            title_word = get_user_input_title()
            field = get_valid_field(collection)
            result = get_field_from_title(collection, title_word, field)
            if result:
                print(result)
        elif choice == '3':
            print_separator()
            break
        else:
            print("Invalid choice. Please try again.")
            print_separator()

if __name__ == "__main__":
    main()
