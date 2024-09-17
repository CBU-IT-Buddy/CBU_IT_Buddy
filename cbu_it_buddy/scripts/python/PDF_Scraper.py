import os
import PyPDF2

def extract_text_from_pdf(pdf_path):
    """Extracts text from a PDF file and saves it to a text file with the same name.

    Args:
        pdf_path (str): The path to the PDF file.
    """

    with open(pdf_path, 'rb') as pdf_file: 
        pdf_reader = PyPDF2.PdfReader(pdf_file)
        text = ''
        for page_num in range(len(pdf_reader.pages)):
            page = pdf_reader.pages[page_num]
            text += page.extract_text()

    output_file = pdf_path.replace('.pdf', '.txt')
    with open(output_file, 'w') as txt_file:
        txt_file.write(text)

def extract_text_from_pdf_folder(folder_path):
    """
    Extracts text from all PDF files in a given folder and saves it to separate text files.

    Args:
        folder_path (str): The path to the folder containing the PDF files.
    """

    for filename in os.listdir(folder_path):
        if filename.endswith('.pdf'):
            pdf_path = os.path.join(folder_path, filename)
            extract_text_from_pdf(pdf_path) 


# Example usage:
folder_path = 'path/to/your/folder/with/pdfs'
extract_text_from_pdf_folder(folder_path)

# Example usage:
pdf_file = 'your_pdf_file.pdf'
extract_text_from_pdf(pdf_file)