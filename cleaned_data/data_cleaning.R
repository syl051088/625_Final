# ================================================
# Heart Disease Datasets Cleanup Script
# ================================================

# Author: Yana Xu
# Date: 10/29/2024
# Description: This script cleans four heart disease datasets
#              (Cleveland, Hungarian, Switzerland, Long Beach VA)
#              by removing embedded NUL characters, handling
#              missing values, and assigning meaningful column names.

# load library
library(dplyr)

# Path
data_folder <- "~/Desktop/625_Final/Heart+Disease/"

# List dataset
dataset_names <- list(
  Cleveland = "cleveland.data",
  Hungarian = "hungarian.data",
  Switzerland = "switzerland.data",
  Long_Beach_VA = "long-beach-va.data"
)

# Create full file paths
full_file_paths <- lapply(dataset_names, function(filename) {
  file.path(data_folder, filename)
})

# Cleaning Function
clean_dataset <- function(file_path, dataset_label) {
  
  cat("Starting to process:", dataset_label, "dataset.\n")
  
  # Read lines from the current dataset file
  raw_lines <- readLines(file_path)
  
  # Create list to store each patient's data
  patient_records <- list()
  current_patient <- c()
  
  # Group lines belonging to the same patient into a single record
  for(line in raw_lines){
    if(grepl("name", line, ignore.case = TRUE)){
      # Split the line into individual data points, removing the word 'name'
      data_points <- strsplit(line, "\\s+")[[1]]
      data_points <- data_points[data_points != "name"]
      
      # Combine with the existing data for the current patient
      current_patient <- c(current_patient, data_points)
      
      # Add the complete patient record to the list
      patient_records <- append(patient_records, list(current_patient))
      
      # Reset for the next patient
      current_patient <- c()
    } else {
      # Split the line into individual data points
      data_points <- strsplit(line, "\\s+")[[1]]
      
      # Add to the current patient's data
      current_patient <- c(current_patient, data_points)
    }
  }
  
  # Convert patient's data to numeric
  # Solve missing values
  numeric_records <- lapply(patient_records, function(record) {
    # Replace '-9' and '-9.0' with NA to indicate missing data
    record[record %in% c("-9", "-9.0")] <- NA
    
    # Convert all data points to numeric values, ignoring non-numeric entries like 'name'
    numeric_data <- suppressWarnings(as.numeric(record))
    
    return(numeric_data)
  })
  
  # Find the maximum number of data points in any patient record
  max_data_length <- max(sapply(numeric_records, length))
  
  # Ensure all patient records have the same length by padding with NA
  uniform_records <- lapply(numeric_records, function(record) {
    length(record) <- max_data_length
    return(record)
  })
  
  # Combine all patient records into a single data frame
  data_frame <- do.call(rbind, uniform_records)
  data_frame <- as.data.frame(data_frame, stringsAsFactors = FALSE)
  
  # Name the columns as V1 to V76
  # 76 attributes
  total_attributes <- 76
  current_columns <- ncol(data_frame)
  
  if (current_columns < total_attributes) {
    warning(paste("Dataset", dataset_label, "has fewer columns (", current_columns, 
                  ") than expected (", total_attributes, "). Filling missing columns with NA.", sep = " "))
    # Add empty columns filled with NA
    data_frame[(current_columns + 1):total_attributes] <- NA
  } else if (current_columns > total_attributes) {
    warning(paste("Dataset", dataset_label, "has more columns (", current_columns, 
                  ") than expected (", total_attributes, "). Extra columns will be removed.", sep = " "))
    # Remove extra columns beyond the 76th
    data_frame <- data_frame[, 1:total_attributes]
  }
  
  # Assign column names V1 to V76
  colnames(data_frame) <- paste0("V", 1:total_attributes)
  
  # Keep the 14 important columns based on readme
  important_columns <- c(3, 4, 9, 10, 12, 16, 19, 32, 38, 40, 41, 44, 51, 58)
  data_subset <- data_frame[, important_columns]
  
  # Rename the columns to meaningful names
  colnames(data_subset) <- c(
    "age", "sex", "chest_pain_type", "resting_bp", "cholesterol",
    "fasting_blood_sugar", "resting_ecg", "max_heart_rate", "exercise_induced_angina",
    "st_depression", "st_slope", "num_major_vessels", "thalassemia", "num_diagnosis"
  )
  
  # Convert specific columns to categorical factors
  categorical_columns <- c("sex", "chest_pain_type", "fasting_blood_sugar", 
                           "resting_ecg", "exercise_induced_angina", "st_slope", 
                           "num_major_vessels", "thalassemia")
  data_subset[categorical_columns] <- lapply(data_subset[categorical_columns], factor)
  
  # Handle missing values
  # For numeric columns, replace NA with the column's mean
  numeric_columns <- setdiff(colnames(data_subset), categorical_columns)
  data_subset[numeric_columns] <- lapply(data_subset[numeric_columns], function(column) {
    replace(column, is.na(column), mean(column, na.rm = TRUE))
  })
  
  # For categorical columns, replace NA with 'Unknown'
  data_subset[categorical_columns] <- lapply(data_subset[categorical_columns], function(column) {
    levels(column) <- c(levels(column), "Unknown")
    replace(column, is.na(column), "Unknown")
  })
  
  # Recode categorical variables to have descriptive labels
  # Recode 'sex' from 0 and 1 to 'female' and 'male'
  data_subset$sex <- factor(data_subset$sex,
                            levels = c("0", "1", "Unknown"),
                            labels = c("female", "male", "Unknown"))
  
  # Recode 'chest_pain_type' to descriptive names
  data_subset$chest_pain_type <- factor(data_subset$chest_pain_type,
                                        levels = c("1", "2", "3", "4", "Unknown"),
                                        labels = c("typical angina", "atypical angina",
                                                   "non-anginal pain", "asymptomatic",
                                                   "Unknown"))
  
  # Recode 'fasting_blood_sugar' to 'False' and 'True'
  data_subset$fasting_blood_sugar <- factor(data_subset$fasting_blood_sugar,
                                            levels = c("0", "1", "Unknown"),
                                            labels = c("False", "True", "Unknown"))
  
  # Recode 'resting_ecg' to descriptive names
  data_subset$resting_ecg <- factor(data_subset$resting_ecg,
                                    levels = c("0", "1", "2", "Unknown"),
                                    labels = c("Normal", "ST-T wave abnormality",
                                               "Left ventricular hypertrophy", "Unknown"))
  
  # Recode 'exercise_induced_angina' to 'No' and 'Yes'
  data_subset$exercise_induced_angina <- factor(data_subset$exercise_induced_angina,
                                                levels = c("0", "1", "Unknown"),
                                                labels = c("No", "Yes", "Unknown"))
  
  # Recode 'st_slope' to descriptive names
  data_subset$st_slope <- factor(data_subset$st_slope,
                                 levels = c("1", "2", "3", "Unknown"),
                                 labels = c("upsloping", "flat", "downsloping", "Unknown"))
  
  # Recode 'num_major_vessels' to include 'Unknown'
  data_subset$num_major_vessels <- factor(data_subset$num_major_vessels,
                                          levels = c("0", "1", "2", "3", "Unknown"),
                                          labels = c("0", "1", "2", "3", "Unknown"))
  
  # Recode 'thalassemia' to descriptive names
  data_subset$thalassemia <- factor(data_subset$thalassemia,
                                    levels = c("3", "6", "7", "Unknown"),
                                    labels = c("normal", "fixed defect", "reversible defect", "Unknown"))
  
  # Read summary
  cat("Summary of", dataset_label, "dataset:\n")
  print(summary(data_subset))
  cat("\nStructure of", dataset_label, "dataset:\n")
  print(str(data_subset))
  
  # Save the cleaned data to CSV
  cleaned_csv <- file.path(data_folder, paste0(dataset_label, "_cleaned.csv"))
  
  # Save as CSV
  write.csv(data_subset, cleaned_csv, row.names = FALSE)
  
  # Return the cleaned data frame
  return(data_subset)
}

# Initialize a list to store all cleaned datasets
all_cleaned_data <- list()

# Loop through each dataset and clean it using the function
for(name in names(full_file_paths)) {
  path <- full_file_paths[[name]]
  cleaned_data <- clean_dataset(file_path = path, dataset_label = name)
  all_cleaned_data[[name]] <- cleaned_data
}
