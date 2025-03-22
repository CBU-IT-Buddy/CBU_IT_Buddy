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

# Function to generate a bullet point summary using Together AI (Llama Model)
def generate_bullet_summary(content):
    try:
        response = client.chat.completions.create(
            model="meta-llama/Llama-3.3-70B-Instruct-Turbo",
            messages=[
                {"role": "system", "content": "Summarize the following IT support information into a maximum of 5 concise bullet points. Keep only the core content. Do not include any introductory phrases."},
                {"role": "user", "content": content}
            ],
            max_tokens=150  # Allow space for bullet points
        )

        # Format the summary as bullet points
        summary = response.choices[0].message.content.strip()
        summary_lines = summary.split('\n')
        bullet_points = ["* {}".format(line.strip()) for line in summary_lines if line.strip()]


        # Join the bullet points into a single string
        bullet_summary = "\n".join(bullet_points)
        return bullet_summary
    except Exception as e:
        print("Error generating bullet points: {}".format(e))
        return "Summary not available"

# Function to update Firestore with bullet-pointed summaries
def update_firestore_summaries():
    print("Updating Firestore documents with bullet-pointed summaries...")
    solutions_collection = db.collection('solutions')
    docs = solutions_collection.stream()

    for doc in docs:
        data = doc.to_dict()
        print("Checking document:", data.get("title", "No Title"))

        # Only process documents that have a "content" field
        if "content" in data:
            content = data["content"]

            # Generate bullet-pointed summary
            bullet_summary = generate_bullet_summary(content)

            # Update the Firestore document with the new bullet-pointed summary
            doc_ref = solutions_collection.document(doc.id)
            doc_ref.update({
                "summary": bullet_summary  # Bullet points in summary
            })

            print("Updated document {} with bullet-pointed summary.".format(doc.id))

# Run the function to update summaries
update_firestore_summaries()
