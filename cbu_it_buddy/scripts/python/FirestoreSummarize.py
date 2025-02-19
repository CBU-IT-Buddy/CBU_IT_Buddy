import os
import firebase_admin
from firebase_admin import credentials, firestore
from together import Together  # Import Together AI client

# Initialize Firebase
cred = credentials.Certificate("keys/cbu-it-buddy-2d42e936a39c.json")
firebase_admin.initialize_app(cred)

# Initialize Firestore client
db = firestore.client()

# Together AI API Key (Replace with your actual API key)
TOGETHER_API_KEY = "9f6e9a6b9e6e9b557e03a24132aea6b528449152e02dd8bcc3d541157686a592"

# Initialize Together AI client
client = Together(api_key=TOGETHER_API_KEY)

# Function to generate a summary using Together AI (Llama Model)
def generate_summary(content):
    try:
        response = client.chat.completions.create(
            model="meta-llama/Llama-3.3-70B-Instruct-Turbo",
            messages=[
                {"role": "system", "content": "Summarize the following IT support information in exactly three concise sentences."},
                {"role": "user", "content": content}
            ],
            max_tokens=100  # Limit response length
        )

        summary = response.choices[0].message.content.strip()
        return summary
    except Exception as e:
        print(f"❌ Error generating summary: {e}")
        return "Summary not available"

# Function to update Firestore with generated summaries
def update_firestore_summaries():
    print("Updating Firestore documents with summaries...")
    solutions_collection = db.collection('solutions')
    docs = solutions_collection.stream()

    for doc in docs:
        data = doc.to_dict()
        print("Checking document:", data.get("title", "No Title"))

        # Only process documents that have a "content" field and an empty "summary"
        if "content" in data and data.get("summary") == "Summary not available":
            content = data["content"]
            summary = generate_summary(content)

            # Update the Firestore document with the new summary
            doc_ref = solutions_collection.document(doc.id)
            doc_ref.update({"summary": summary})

            print(f"✅ Updated document {doc.id} with summary: {summary}")

# Run the function to update summaries
update_firestore_summaries()
