import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import re

cred = credentials.Certificate("keys/cbu-it-buddy-2d42e936a39c.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# Reference the solutions collection
solutions = db.collection('solutions')

def removeHeader():
    # Define regex pattern to remove everything before the desired phrase
    pattern = re.compile(r".*?(Viewing (?:published|draft) article(?: preview)?)", re.DOTALL)

    # Loop through collection and update content
    for doc in solutions.stream():
        doc_dict = doc.to_dict()
        content = doc_dict.get('content', '')
        
        # Search for the first occurrence of the target phrase
        match = pattern.search(content)
        
        if match:
            # Remove everything before the matched phrase and the line containing the phrase
            new_content = content[match.end():]
            doc_ref = solutions.document(doc.id)
            doc_ref.update({'content': new_content})
            print(f"Document {doc_dict.get('title', 'Untitled')} updated.")
        else:
            print(f"Document {doc_dict.get('title', 'Untitled')} does not contain the target phrase.")

def removeDivider():
    phrase = "| Knowledge Base | California Baptist University"
    
    # Loop through collection and update content
    for doc in solutions.stream():
        doc_dict = doc.to_dict()
        content = doc_dict.get('content', '')
        
        # Split content into lines
        lines = content.splitlines()
        new_lines = []
        skip_next = False
        
        for i, line in enumerate(lines):
            if skip_next:
                skip_next = False
                continue
            if phrase in line:
                skip_next = True  # Skip this line and the next one
            else:
                new_lines.append(line)
        
        new_content = "\n".join(new_lines)
        
        doc_ref = solutions.document(doc.id)
        doc_ref.update({'content': new_content})
        print(f"Document {doc_dict.get('title', 'Untitled')} updated.")

def main():
    removeHeader()
    removeDivider()

if __name__ == "__main__":
    main()