
# RESUMIQ - Resume Screening and Job Matching Web Application
# Algorithm: Cosine Similarity 

library(shiny)


# BACKEND LOGIC 


# Text Preprocessing

preprocess_text <- function(text) {
  text <- tolower(text)
  text <- gsub("[^a-z0-9 ]", " ", text)
  text <- gsub("\\s+", " ", text)
  text <- trimws(text)
  return(text)
}


#  Manual Stopword Removal

get_stopwords <- function() {
  stopwords <- c(
    # --- Original core stopwords ---
    "a", "an", "the", "and", "or", "but", "in", "on", "at", "to", "for",
    "of", "with", "by", "from", "is", "are", "was", "were", "be", "been",
    "being", "have", "has", "had", "do", "does", "did", "will", "would",
    "could", "should", "may", "might", "shall", "can", "need", "dare",
    "ought", "used", "this", "that", "these", "those", "i", "me", "my",
    "we", "our", "you", "your", "he", "his", "she", "her", "it", "its",
    "they", "their", "them", "what", "which", "who", "whom", "whose",
    "when", "where", "why", "how", "all", "each", "every", "both", "few",
    "more", "most", "other", "some", "such", "no", "not", "only", "same",
    "so", "than", "too", "very", "just", "about", "above", "after",
    "before", "between", "during", "if", "then", "as", "also", "any",
    "into", "through", "up", "out", "over", "under", "again", "further",
    "while", "s", "t", "re", "ve", "ll", "d", "m", "am", "well", "like",
    "able", "get", "got", "one", "two", "three", "new", "good", "us",
    
    # --- [NEW] Generic Job Description filler words ---
    # These appear in almost every JD regardless of domain and add noise.
    # Removing them keeps only domain-specific, meaningful keywords.
    "looking", "seek", "seeking", "candidate", "candidates", "require",
    "required", "requirements", "requirement", "responsibility",
    "responsibilities", "role", "position", "job", "work", "working",
    "team", "join", "must", "strong", "excellent", "preferred",
    "preferably", "plus", "bonus", "including", "include", "includes",
    "following", "please", "apply", "application", "applicants",
    "applicant", "employer", "employee", "company", "organization",
    "office", "location", "department", "years", "year", "experience",
    "experienced", "minimum", "least", "ensure", "handle", "handles",
    "handling", "manage", "manages", "management", "manager", "lead",
    "leads", "leading", "support", "supports", "supporting", "assist",
    "assisting", "provide", "provides", "providing", "develop",
    "develops", "developing", "maintain", "maintains", "maintaining",
    "implement", "implements", "implementing", "knowledge",
    "understanding", "familiarity", "familiar", "ability", "communicate",
    "communication", "skill", "skills", "proficiency", "proficient",
    "basis", "day", "tasks", "task", "perform", "performing", "key",
    "core", "primary", "secondary", "additional", "various", "related",
    "relevant", "high", "level", "levels", "type", "types", "across",
    "within", "without", "per", "etc", "eg", "ie", "nbsp", "ref",
    "number", "numbers", "time", "full", "part", "contract", "permanent"
  )
  return(stopwords)
}


#  Tokenize and Remove Stopwords

tokenize_and_filter <- function(text) {
  words     <- strsplit(text, " ")[[1]]
  stop_words <- get_stopwords()
  filtered  <- c()
  for (word in words) {
    if (!(word %in% stop_words) && nchar(word) > 1) {
      filtered <- c(filtered, word)
    }
  }
  return(filtered)
}


filter_resume_by_job_keywords <- function(resume_tokens, job_keywords) {
  # Keep only resume words that exist in the job keyword set.
  # This ensures the resume vector is built on relevant dimensions only.
  filtered_resume <- c()
  for (token in resume_tokens) {
    if (token %in% job_keywords) {
      filtered_resume <- c(filtered_resume, token)
    }
  }
  return(filtered_resume)
}

build_vocabulary <- function(tokens1, tokens2) {
  vocabulary <- sort(unique(tokens2))
  return(vocabulary)
}


# Build Term Frequency Vector
 
build_tf_vector <- function(tokens, vocabulary) {
  vector <- numeric(length(vocabulary))
  for (i in 1:length(vocabulary)) {
    count <- 0
    for (token in tokens) {
      if (token == vocabulary[i]) {
        count <- count + 1
      }
    }
    vector[i] <- count
  }
  return(vector)
}


# Compute Dot Product (Manual)


compute_dot_product <- function(vec1, vec2) {
  dot_product <- 0
  for (i in 1:length(vec1)) {
    dot_product <- dot_product + (vec1[i] * vec2[i])
  }
  return(dot_product)
}


#  Compute Magnitude (Manual)


compute_magnitude <- function(vec) {
  sum_of_squares <- 0
  for (val in vec) {
    sum_of_squares <- sum_of_squares + (val * val)
  }
  magnitude <- sqrt(sum_of_squares)
  return(magnitude)
}


#  Compute Cosine Similarity (From Scratch)
# Formula: cos(theta) = (A . B) / (|A| x |B|)


compute_cosine_similarity <- function(vec1, vec2) {
  dot  <- compute_dot_product(vec1, vec2)
  mag1 <- compute_magnitude(vec1)
  mag2 <- compute_magnitude(vec2)
  
  # Avoid division by zero if either vector is all zeros
  if (mag1 == 0 || mag2 == 0) {
    return(0)
  }
  
  similarity <- dot / (mag1 * mag2)
  return(similarity)
}


#  Identify Matched and Missing Skills


find_skills <- function(resume_tokens, job_keywords) {
  
  resume_words <- unique(resume_tokens)
  job_words    <- unique(job_keywords)
  
  matched <- c()
  for (word in job_words) {
    if (word %in% resume_words) {
      matched <- c(matched, word)
    }
  }
  
  missing <- c()
  for (word in job_words) {
    if (!(word %in% resume_words)) {
      missing <- c(missing, word)
    }
  }
  
  return(list(matched = matched, missing = missing))
}


#  Generate Decision Based on Match Percentage

get_decision <- function(percentage) {
  if (percentage >= 80) {
    return(list(label = "Highly Suitable",     color = "#27ae60", bg = "#eafaf1", icon = "target"))
  } else if (percentage >= 60) {
    return(list(label = "Moderately Suitable", color = "#f39c12", bg = "#fef9e7", icon = "clipboard"))
  } else {
    return(list(label = "Low Match",           color = "#e74c3c", bg = "#fdedec", icon = "chart"))
  }
}


# MASTER FUNCTION: Run the full resume screening pipeline


analyze_resume <- function(resume_text, job_text) {
  
  
  clean_resume <- preprocess_text(resume_text)
  clean_job    <- preprocess_text(job_text)
  
 
  resume_tokens_raw <- tokenize_and_filter(clean_resume)
  job_tokens_raw    <- tokenize_and_filter(clean_job)
  
  
  if (length(resume_tokens_raw) == 0 || length(job_tokens_raw) == 0) {
    return(list(error = "Please enter meaningful text in both fields."))
  }
  
  #  Dynamic Job Keyword Extraction

  job_keywords <- unique(job_tokens_raw)
  resume_tokens_filtered <- filter_resume_by_job_keywords(resume_tokens_raw, job_keywords)
  vocab <- build_vocabulary(resume_tokens_filtered, job_keywords)
  
  #  Build Term Frequency Vectors 
  resume_vector <- build_tf_vector(resume_tokens_filtered, vocab)
  job_vector    <- build_tf_vector(job_tokens_raw,         vocab)
  
  # Cosine Similarity 
  similarity  <- compute_cosine_similarity(resume_vector, job_vector)
  percentage  <- round(similarity * 100, 2)
  skills <- find_skills(resume_tokens_raw, job_keywords)
  decision <- get_decision(percentage)
  
  return(list(
    percentage = percentage,
    decision   = decision,
    matched    = skills$matched,
    missing    = skills$missing,
    error      = NULL
  ))
}



# FRONTEND - UI


ui <- fluidPage(
  
  tags$head(
    tags$meta(charset = "UTF-8"),
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1.0"),
    tags$title("RESUMIQ - Resume Screening Tool"),
    tags$style(HTML("

      @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

      * { box-sizing: border-box; margin: 0; padding: 0; }

      body {
        font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
        min-height: 100vh;
        padding: 20px 15px 40px 15px;
        color: #2d3436;
      }

      .app-wrapper { max-width: 1000px; margin: 0 auto; }

      .app-header { text-align: center; padding: 36px 20px 28px 20px; margin-bottom: 28px; }

      .app-logo {
        font-size: 3.2em; font-weight: 800; letter-spacing: 4px;
        background: linear-gradient(90deg, #00b4d8, #48cae4, #90e0ef);
        -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        background-clip: text; text-fill-color: transparent; margin-bottom: 6px;
      }

      .app-tagline { color: #b2d8e8; font-size: 1.0em; font-weight: 400; letter-spacing: 1px; }

      .algorithm-badge {
        display: inline-block;
        background: rgba(0,180,216,0.15); border: 1px solid rgba(0,180,216,0.4);
        color: #48cae4; padding: 4px 14px; border-radius: 20px;
        font-size: 0.78em; margin-top: 10px; letter-spacing: 0.5px;
      }

      .input-grid {
        display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 22px;
      }

      @media (max-width: 700px) { .input-grid { grid-template-columns: 1fr; } }

      .input-card {
        background: #ffffff; border-radius: 16px; padding: 24px;
        box-shadow: 0 4px 24px rgba(0,0,0,0.10); border: 1px solid #f0f0f0;
      }

      .input-label {
        font-size: 0.92em; font-weight: 600; color: #374151;
        margin-bottom: 10px; display: flex; align-items: center; gap: 6px;
      }

      .form-control {
        border: 2px solid #e5e7eb !important; border-radius: 10px !important;
        padding: 12px 14px !important; font-size: 0.88em !important;
        font-family: 'Inter', sans-serif !important; resize: vertical !important;
        transition: border-color 0.2s, box-shadow 0.2s !important;
        background: #fafafa !important; color: #374151 !important; line-height: 1.6 !important;
      }

      .form-control:focus {
        border-color: #00b4d8 !important;
        box-shadow: 0 0 0 3px rgba(0,180,216,0.15) !important;
        background: #fff !important; outline: none !important;
      }

      .btn-analyze-wrapper { text-align: center; margin: 6px 0 28px 0; }

      #analyze_btn {
        background: linear-gradient(135deg, #00b4d8, #0077b6) !important;
        color: #fff !important; font-weight: 700 !important; font-size: 1.05em !important;
        padding: 14px 52px !important; border: none !important; border-radius: 50px !important;
        cursor: pointer !important; letter-spacing: 1px !important;
        box-shadow: 0 6px 20px rgba(0,119,182,0.35) !important;
        transition: transform 0.18s, box-shadow 0.18s !important;
        font-family: 'Inter', sans-serif !important;
      }

      #analyze_btn:hover {
        transform: translateY(-2px) !important;
        box-shadow: 0 10px 28px rgba(0,119,182,0.45) !important;
      }

      #analyze_btn:active { transform: translateY(0px) !important; }

      .results-section { animation: fadeInUp 0.45s ease; }

      @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(20px); }
        to   { opacity: 1; transform: translateY(0); }
      }

      .score-card {
        background: #ffffff; border-radius: 16px; padding: 32px; text-align: center;
        box-shadow: 0 4px 24px rgba(0,0,0,0.10); border: 1px solid #f0f0f0; margin-bottom: 22px;
      }

      .score-label {
        font-size: 0.85em; font-weight: 600; color: #6b7280;
        text-transform: uppercase; letter-spacing: 1.5px; margin-bottom: 10px;
      }

      .score-value { font-size: 4.5em; font-weight: 800; line-height: 1; margin-bottom: 6px; }

      .score-percent { font-size: 1.8em; font-weight: 500; vertical-align: super; }

      .decision-badge {
        display: inline-block; padding: 10px 28px; border-radius: 50px;
        font-weight: 700; font-size: 1.05em; margin-top: 6px; letter-spacing: 0.5px;
      }

      .progress-bar-outer {
        background: #f3f4f6; border-radius: 8px; height: 12px;
        margin: 18px auto 0 auto; max-width: 360px; overflow: hidden;
      }

      .progress-bar-inner { height: 100%; border-radius: 8px; transition: width 0.8s ease; }

      .skills-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 22px; }

      @media (max-width: 600px) {
        .skills-grid { grid-template-columns: 1fr; }
        .score-value { font-size: 3.2em; }
      }

      .skills-card {
        background: #ffffff; border-radius: 16px; padding: 24px;
        box-shadow: 0 4px 24px rgba(0,0,0,0.10); border: 1px solid #f0f0f0;
      }

      .skills-title {
        font-size: 0.92em; font-weight: 700; margin-bottom: 14px;
        display: flex; align-items: center; gap: 7px; letter-spacing: 0.3px;
      }

      .skill-chip {
        display: inline-block; padding: 5px 13px; border-radius: 20px;
        font-size: 0.80em; font-weight: 500; margin: 4px 3px; letter-spacing: 0.2px;
      }

      .chip-matched { background: #d1fae5; color: #065f46; border: 1px solid #6ee7b7; }
      .chip-missing { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }
      .chip-none    { color: #9ca3af; font-style: italic; font-size: 0.85em; }

      .algo-card {
        background: linear-gradient(135deg, #0f2027, #203a43);
        border-radius: 16px; padding: 22px 28px; color: #b2d8e8;
        font-size: 0.82em; line-height: 1.7;
        box-shadow: 0 4px 24px rgba(0,0,0,0.2); margin-bottom: 22px;
      }

      .algo-card h4 {
        color: #48cae4; font-size: 0.95em; font-weight: 700;
        margin-bottom: 8px; letter-spacing: 0.5px;
      }

      .formula {
        font-family: 'Courier New', monospace; background: rgba(255,255,255,0.08);
        padding: 8px 16px; border-radius: 8px; display: inline-block; margin: 6px 0;
        color: #90e0ef; font-size: 0.95em; letter-spacing: 0.5px;
      }

      .app-footer {
        text-align: center; color: rgba(255,255,255,0.35);
        font-size: 0.78em; margin-top: 10px; letter-spacing: 0.5px;
      }

      .error-box {
        background: #fee2e2; border: 1px solid #fca5a5; color: #991b1b;
        border-radius: 12px; padding: 16px 20px; font-size: 0.92em; margin-bottom: 16px;
      }

      #analyze_btn.disabled, #analyze_btn[disabled] { opacity: 0.7 !important; }

    "))
  ),
  
  div(class = "app-wrapper",
      
      div(class = "app-header",
          div(class = "app-logo", "RESUMIQ"),
          div(class = "app-tagline", "Resume Screening & Job Matching Platform"),
          
      ),
      
      # [MODIFIED] Updated algo-card description to reflect dynamic filtering
      div(class = "algo-card",
          tags$h4("How it Works"),
          tags$p(
            "RESUMIQ extracts meaningful keywords directly from the job description, ",
            "filters your resume against those keywords, then computes cosine similarity."
          ),
          div(class = "formula", "cos(th) = (A . B) / (|A| x |B|)"),
          tags$p(style = "margin-top:6px;",
                 "Only job-relevant terms are compared - making scores accurate for any domain: IT, Finance, Law, and more."
          )
      ),
      
      div(class = "input-grid",
          
          div(class = "input-card",
              div(class = "input-label", "Resume Text"),
              textAreaInput(
                inputId     = "resume_input",
                label       = NULL,
                placeholder = "Paste your resume text here...\n\nExample:\nExperienced Python developer with 3 years in machine learning and data analysis. Proficient in SQL, TensorFlow, scikit-learn, and data visualization using Matplotlib...",
                height      = "260px",
                width       = "100%"
              )
          ),
          
          div(class = "input-card",
              div(class = "input-label", "Job Description Text"),
              textAreaInput(
                inputId     = "job_input",
                label       = NULL,
                placeholder = "Paste the job description here...\n\nExample:\nWe are looking for a Python developer with experience in machine learning, TensorFlow, and SQL. Must have strong skills in data analysis and visualization...",
                height      = "260px",
                width       = "100%"
              )
          )
      ),
      
      div(class = "btn-analyze-wrapper",
          actionButton(inputId = "analyze_btn", label = "Analyze Resume", class = "btn")
      ),
      
      uiOutput("results_ui"),
      
      div(class = "app-footer", "RESUMIQ v1.0 | College Assignment Project | Built with R Shiny")
  )
)



# BACKEND - SERVER LOGIC


server <- function(input, output, session) {
  
  analysis_result <- eventReactive(input$analyze_btn, {
    resume_text <- input$resume_input
    job_text    <- input$job_input
    
    if (is.null(resume_text) || trimws(resume_text) == "") {
      return(list(error = "Please enter your resume text."))
    }
    if (is.null(job_text) || trimws(job_text) == "") {
      return(list(error = "Please enter the job description text."))
    }
    
    result <- analyze_resume(resume_text, job_text)
    return(result)
  })
  
  output$results_ui <- renderUI({
    req(input$analyze_btn > 0)
    result <- analysis_result()
    
    if (!is.null(result$error)) {
      return(div(class = "error-box", result$error))
    }
    
    pct      <- result$percentage
    decision <- result$decision
    matched  <- result$matched
    missing  <- result$missing
    
    matched_chips <- if (length(matched) == 0) {
      tags$span(class = "chip-none", "No matching keywords found")
    } else {
      sorted_matched <- sort(matched)
      chip_tags <- lapply(sorted_matched, function(w) tags$span(class = "skill-chip chip-matched", w))
      do.call(tagList, chip_tags)
    }
    
    missing_chips <- if (length(missing) == 0) {
      tags$span(class = "chip-none", "All keywords matched!")
    } else {
      sorted_missing <- sort(missing)
      chip_tags <- lapply(sorted_missing, function(w) tags$span(class = "skill-chip chip-missing", w))
      do.call(tagList, chip_tags)
    }
    
    div(class = "results-section",
        
        div(class = "score-card",
            div(class = "score-label", "Match Score"),
            div(class = "score-value",
                style = paste0("color:", decision$color),
                pct,
                tags$span(class = "score-percent", style = paste0("color:", decision$color), "%")
            ),
            div(class = "decision-badge",
                style = paste0("background:", decision$bg, "; color:", decision$color,
                               "; border: 2px solid ", decision$color, ";"),
                decision$label
            ),
            div(class = "progress-bar-outer",
                div(class = "progress-bar-inner",
                    style = paste0("width:", min(pct, 100), "%;",
                                   "background: linear-gradient(90deg, ", decision$color,
                                   ", ", decision$color, "99);")
                )
            )
        ),
        
        div(class = "skills-grid",
            
            div(class = "skills-card",
                div(class = "skills-title", style = "color: #065f46;",
                    "Matched Keywords",
                    tags$span(
                      style = "background:#d1fae5; color:#065f46; border-radius:12px; padding:2px 10px; font-size:0.85em;",
                      length(matched)
                    )
                ),
                matched_chips
            ),
            
            div(class = "skills-card",
                div(class = "skills-title", style = "color: #991b1b;",
                    "Missing Keywords",
                    tags$span(
                      style = "background:#fee2e2; color:#991b1b; border-radius:12px; padding:2px 10px; font-size:0.85em;",
                      length(missing)
                    )
                ),
                missing_chips
            )
        )
    )
  })
}



# RUN APPLICATION 

app <- shinyApp(ui = ui, server = server)
runApp(app, launch.browser = TRUE)