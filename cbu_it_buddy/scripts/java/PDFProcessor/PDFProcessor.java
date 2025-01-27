import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.pdfbox.text.TextPosition;
import org.apache.pdfbox.pdmodel.PDDocumentInformation;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

public class PDFProcessor {
    // Custom class to extract text with formatting (font size, font name, and style)
    static class CustomPDFTextStripper extends PDFTextStripper {
        public CustomPDFTextStripper() throws IOException {}

        @Override
        protected void writeString(String text, List<TextPosition> textPositions) throws IOException {
            for (TextPosition textPosition : textPositions) {
                // Get the font name and size for each piece of text
                String font = textPosition.getFont().getName();
                float fontSize = textPosition.getFontSizeInPt();
                // System.out.println("Text: " + textPosition.getUnicode() +
                                //    ", Font: " + font + 
                                //    ", Size: " + fontSize);
            }
            super.writeString(text, textPositions);
        }
    }

    // Extracts text from a PDF file with formatting information and saves it to a text file
    public static void extractText(String pdfPath) throws IOException {
        File pdfFile = new File(pdfPath);
        if (!pdfFile.exists()) {
            System.out.println("The PDF file does not exist.");
            return;
        }

        try (PDDocument document = Loader.loadPDF(pdfFile)) {
            CustomPDFTextStripper pdfStripper = new CustomPDFTextStripper();
            String text = pdfStripper.getText(document); // .getText() is from Apache PDFBox lib

            // Create the text folder if it doesn't exist
            File textFolder = new File("text");
            if (!textFolder.exists()) {
                textFolder.mkdirs();
            }

            // Save the output file in the text folder
            String outputFile = "text/" + pdfFile.getName().replace(".pdf", ".txt");
            try (FileWriter writer = new FileWriter(outputFile)) {
                writer.write(text);
            }
            System.out.println("Text with formatting extracted and saved to: " + outputFile);
        }
    }

    // Extract metadata from the PDF file and save it to a metadata text file
    public static void extractPDFMetadata(String pdfPath) throws IOException {
        File pdfFile = new File(pdfPath);
        if (!pdfFile.exists()) {
            System.out.println("The PDF file does not exist.");
            return;
        }

        try (PDDocument document = Loader.loadPDF(pdfFile)) {
            PDDocumentInformation info = document.getDocumentInformation();

            // Prepare the metadata output file
            String metadataFile = pdfPath.replace(".pdf", "_metadata.txt");
            try (FileWriter writer = new FileWriter(metadataFile)) {
                writer.write("Title: " + info.getTitle() + "\n");
                writer.write("Author: " + info.getAuthor() + "\n");
                writer.write("Subject: " + info.getSubject() + "\n");
                writer.write("Keywords: " + info.getKeywords() + "\n");
                writer.write("Creation Date: " + info.getCreationDate() + "\n");
                writer.write("Modification Date: " + info.getModificationDate() + "\n");
            }
            System.out.println("Metadata extracted and saved to: " + metadataFile);
        }
    }

    // Extracts text from all PDF files in a given folder and saves them to separate text files
    public static void extractTextFromPDFFolder(String folderPath) throws IOException {
        File folder = new File(folderPath);
        if (!folder.isDirectory()) {
            System.out.println("The provided folder path is not a directory.");
            return;
        }

        File[] files = folder.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.isFile() && file.getName().endsWith(".pdf")) {
                    extractText(file.getAbsolutePath());  // Extract text with formatting
                    // extractPDFMetadata(file.getAbsolutePath());  // Extract metadata and save it
                }
            }
        }
    }
    
    public static void main(String[] args) {
        ///////////////////////////////////////////////////
        // Select folder path
        ///////////////////////////////////////////////////
        String folderPath = "scripts/java/PDFProcessor/pdf";
        // String pdfPath = "";
        try {
            extractTextFromPDFFolder(folderPath);  // Scan all PDFs in the folder
            // extractTextWithFormatting(pdfPath);
            // extractPDFMetadata(pdfPath);
        } catch (IOException e) {
            System.err.println("An error occurred while processing the PDF files: " + e.getMessage());
        }
    }
}