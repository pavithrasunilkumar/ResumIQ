# RESUMIQ – Resume Screening and Job Matching System

![R](https://img.shields.io/badge/Language-R-blue?style=for-the-badge&logo=r)
![Shiny](https://img.shields.io/badge/Framework-Shiny-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)
![Algorithm](https://img.shields.io/badge/Algorithm-Cosine%20Similarity-purple?style=for-the-badge)
![Implementation](https://img.shields.io/badge/Implementation-From%20Scratch-red?style=for-the-badge)
![License](https://img.shields.io/badge/License-Academic-lightgrey?style=for-the-badge)

---

## Overview

RESUMIQ is a resume screening web application that compares a candidate’s resume with a job description and calculates a match score using Cosine Similarity implemented from scratch.

The system is built using R and the Shiny framework, demonstrating core Natural Language Processing concepts without relying on external machine learning libraries.

---

## Key Features

- Resume and job description comparison  
- Match score with suitability classification  
- Keyword analysis (matched and missing keywords)  
- Fully algorithm-based implementation  
- Interactive web interface  

---

## How It Works

### Step 1: Text Preprocessing
- Convert text to lowercase  
- Remove stopwords  
- Perform tokenization  

### Step 2: Vocabulary Creation
- Combine unique words from both inputs  

### Step 3: Vectorization
- Convert text into numerical vectors  

### Step 4: Similarity Calculation

\[
\text{cos(θ)} = \frac{A \cdot B}{|A| \times |B|}
\]

### Step 5: Decision Logic
- ≥ 80% → Highly Suitable  
- ≥ 60% → Moderately Suitable  
- < 60% → Low Match  

---

## Project Structure

```
RESUMIQ/
│
├── app.R          # Main Shiny Application
├── README.txt     # Setup Instructions
└── report.docx    # Academic Report
```

---

## Installation and Setup

### Requirements
- R (version 4.0 or higher)  
- RStudio  
- Shiny package  

### Install Dependencies

```r
install.packages("shiny")
```

---

## Run the Application

### Method 1
Click "Run App" in RStudio  

### Method 2

```r
shiny::runApp("app.R")
```

---

## Usage

1. Paste resume text  
2. Paste job description  
3. Click "Analyze Resume"  
4. View results:
   - Match score  
   - Suitability decision  
   - Matched keywords  
   - Missing keywords  

---

## Example Test Case

Resume:
Python, Machine Learning, TensorFlow, SQL, NLP, AWS, Docker  

Job Description:
Python, Machine Learning, TensorFlow, SQL, NLP, Cloud, Docker  

Expected Output: Approximately 75–85% match score  

---

## Highlights

- No external NLP or machine learning libraries used  
- Complete algorithm implementation from scratch  
- Suitable for academic and practical demonstration  
- Easy to extend and modify  

---

## Future Enhancements

- Add TF-IDF weighting  
- Resume upload with PDF parsing  
- Machine learning-based recommendation system  
- Deployment using Shiny Server or cloud platforms  

---

## Author

Pavithra Sunilkumar  

---

## Support

If you find this project useful, consider giving it a star on GitHub.
