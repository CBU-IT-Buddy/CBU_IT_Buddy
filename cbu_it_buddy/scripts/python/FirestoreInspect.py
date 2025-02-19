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
    print("")
    print("##########################################################")
    print("")

# Method to print all the titles in the collection
def print_all_titles(collection):
    print_separator()

    if (collection.id != "user_feedback"):
        # Loop through the documents in the collection
        for doc in collection.stream():
            doc_dict = doc.to_dict() # Convert the document to a dictionary
            print(doc_dict['title']) # Print the title of the document
    else:
        print("User feedback collection does not have titles.")

    print_separator()

# Method to print amount of documents in the collection
def print_collection_size(collection):
    print_separator()
    doc_count = sum(1 for _ in collection.stream())
    print(f"Number of documents in the collection: {doc_count}")
    print_separator()

# Method to return any field from a document given a word in the title
def get_field_from_title(collection, title_word, field):
    matching_docs = check_document_exists(collection, title_word)
    
    selected_index = int(input(f"Enter the number of the document you would like to retrieve the {field}: ")) - 1
    if 0 <= selected_index < len(matching_docs):

        # Return the field of the selected document
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
    print("Select a collection:")
    for i, collection_name in enumerate(collections.keys()):
        print(f"{i + 1}. {collection_name}")

    choice = int(input("Enter your choice (1/2/3/4): ")) - 1

    # Check if the choice is valid
    if 0 <= choice < len(collections):
        return list(collections.keys())[choice]
    else:
        print("Invalid choice. Please try again.")
        print_separator()
        return select_collection() # Recursive call

# Method to check if a document exists given an inputted title
def check_document_exists(collection, title_word):
    print_separator()

    # Initialize an empty list to store the matching documents
    matching_docs = []

    # Loop through the documents in the collection
    for doc in collections[collection].stream():
        doc_dict = doc.to_dict()

        # Check if the title word is in the title of the document
        if title_word.lower() in doc_dict['title'].lower():
            matching_docs.append(doc_dict)
    
    if not matching_docs:
        print("No documents found with the given title word.")
        print_separator()
        return None
    
    print("Documents found:")

    # Loop through the matching documents
    for i, doc in enumerate(matching_docs):
        print(f"{i + 1}: {doc['title']}")
    
    return matching_docs

# Method to get a valid field from the user
def get_valid_field(collection):

    # Get the available fields from the first document in the collection
    sample_doc = next(collections[collection].stream()).to_dict()
    available_fields = list(sample_doc.keys())

    # Loop until a valid field is entered
    while True:
        field = input(f"Enter the field you would like to retrieve (Available fields: {available_fields}): ")
        if field in available_fields:
            return field
        else:
            print(f"The field '{field}' does not exist. Please choose from the available fields.")

# Print the document selection loop
def print_document_selection_loop():
    print_separator()
    print("Select an option:")
    print("1. Print all titles")
    print("2. Get field from a document")
    print("3. Check if document exists")
    print("4. Return to collection selection")
    print("5. Exit")

# Main method
def main():
    while True: # Collection selection loop
        collection = select_collection()
        # print(collection)

        while True: # Document selection loop
            print_document_selection_loop()
            choice = input("Enter your choice (1/2/3/4/5): ")
            
            # Print all titles
            if choice == '1': 
                print_all_titles(collections[collection])

            # Get field from document
            elif choice == '2': 
                title_word = get_user_input_title()
                field = get_valid_field(collection)
                result = get_field_from_title(collection, title_word, field)
                if result:
                    print(result)
                    
            # Check if document exists
            elif choice == '3': 
                title = get_user_input_title()
                check_document_exists(collection, title)

            # Return to collection selection
            elif choice == '4': 
                print_separator()
                break

            # Exit
            elif choice == '5': 
                print_separator()
                print("Exited program.")
                return
            
            else:
                print("Invalid choice. Please try again.")
                print_separator()

if __name__ == "__main__":
    main()
