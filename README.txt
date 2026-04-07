================================================================
  RESUMIQ - Resume Screening and Job Matching Web Application
  Algorithm: Cosine Similarity (From Scratch in R)
  Framework: R Shiny
================================================================

PROJECT STRUCTURE
-----------------
RESUMIQ/
  ├── app.R          → Main Shiny application (UI + Server logic)
  ├── README.txt     → This file (setup and run instructions)
  └── report.docx    → Academic assignment report

================================================================
SYSTEM REQUIREMENTS
================================================================
  - R (version 4.0 or higher)
  - RStudio (recommended IDE)
  - R package: shiny

================================================================
STEP-BY-STEP INSTRUCTIONS TO RUN THE APP
================================================================

STEP 1: Install R and RStudio
  - Download R from: https://cran.r-project.org/
  - Download RStudio from: https://posit.co/download/rstudio-desktop/

STEP 2: Install the Required Package
  Open RStudio → Console panel → Type and press Enter:
  
    install.packages("shiny")

STEP 3: Open the Project
  Option A (Recommended):
    - File → Open File → Navigate to RESUMIQ folder → Select app.R

  Option B:
    - File → Open Project → Select RESUMIQ folder

STEP 4: Run the Application
  Method 1: Click the "Run App" button at the top-right of the editor
  Method 2: In the Console, type:
    
    shiny::runApp("app.R")

STEP 5: Use the Application
  The app will open in your browser (or RStudio viewer).
  
  1. Paste your Resume text in the left text box
  2. Paste the Job Description text in the right text box
  3. Click "Analyze Resume"
  4. View your Match Score, Decision, Matched Keywords, and Missing Keywords

================================================================
HOW TO CREATE A ZIP FILE
================================================================

Windows:
  1. Right-click the RESUMIQ folder
  2. Select "Send to" → "Compressed (zipped) folder"
  3. Submit RESUMIQ.zip

Mac:
  1. Right-click the RESUMIQ folder
  2. Select "Compress RESUMIQ"
  3. Submit RESUMIQ.zip

Linux:
  zip -r RESUMIQ.zip RESUMIQ/

================================================================
EXAMPLE TEST INPUT
================================================================

RESUME TEXT (paste into left box):
---
Experienced Python developer with 3 years in machine learning 
and data analysis. Proficient in SQL, TensorFlow, scikit-learn, 
and data visualization using Matplotlib and Seaborn. Strong 
knowledge of deep learning, neural networks, and NLP. Worked 
on classification and regression models. Familiar with 
cloud computing on AWS and Docker.
---

JOB DESCRIPTION TEXT (paste into right box):
---
We are looking for a Python developer with experience in 
machine learning, TensorFlow, and SQL. Must have strong skills 
in data analysis, deep learning, and NLP. Knowledge of neural 
networks, classification models, and cloud computing is required. 
Experience with Docker and AWS is a plus.
---

Expected Result: ~75-85% Match Score

================================================================
ALGORITHM EXPLANATION (Simplified)
================================================================

1. TEXT PREPROCESSING:
   - Convert all text to lowercase
   - Remove punctuation and special characters
   - Remove common English stopwords (the, is, a, and, etc.)
   - Split remaining text into individual words (tokens)

2. VOCABULARY BUILDING:
   - Combine all unique words from both resume and job description
   - This forms the "vocabulary" (a shared word universe)

3. VECTOR CREATION:
   - For each document, count how many times each vocabulary word appears
   - This creates a numerical vector representing the document

4. COSINE SIMILARITY FORMULA:
   
   cos(θ) = (Resume_Vector · Job_Vector) / (|Resume_Vector| × |Job_Vector|)
   
   Where:
   - · is the dot product (sum of element-wise products)
   - |V| is the magnitude = sqrt(sum of squares of all elements)

5. DECISION:
   - ≥ 80% → Highly Suitable
   - ≥ 60% → Moderately Suitable
   - < 60% → Low Match

================================================================
IMPORTANT NOTES
================================================================
  - No machine learning libraries are used
  - No NLP packages are used
  - All algorithms (cosine similarity, tokenization, 
    stopword removal, vectorization) are built from scratch
    using basic R and loops
  - This satisfies the constraint of pure algorithmic implementation

================================================================
CONTACT / CREDITS
================================================================
  Project: RESUMIQ v1.0
  Assignment: Add-on Assignment - NLP / Text Processing
  Platform: RStudio + R Shiny Framework
================================================================
