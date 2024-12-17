## **Optimizing Machine Learning Models for Early Diabetes Detection Using a Large-Scale CDC Dataset**  

Welcome to the Healthcare Machine Learning repository！In this project collection, we leverage machine learning algorithms and data science techniques to develop accurate predictive models for various diabetes datasets, while also optimizing the efficiency of these machine learning methods.

---

## **Dataset Overview**  

The dataset used in this project is sourced from the CDC Diabetes Health Indicators dataset, accessible through the [UC Irvine Machine Learning Repository](https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators).

The dataset initially showed a significant imbalance between the diabetic (label 1) and non-diabetic (label 0) cases, prompting a rebalance to ensure equal representation of both classes. The rebalanced subset used for model construction contains approximately 70,000 samples.

- **Data Splitting**: The data is split into 80% for training and 20% for testing.  
- **sample size**:    
   - The training set: 56,000 samples (approximately)  
   - The testing set:  14,000 samples (approximately)  
- **features**: 20 clinical features

---

## **Clinical Features Overview**  

**Target variable**:   
- Diabetes_binary: Whether or not the individual has diabetes.(1: Yes, 0: No)  

**Input features**：  

| **Category**                  | **feature**                                   | **Description**                              |
|---------------------------|-------------------------------------------|--------------------------------------|
| **Health Conditions** | `HighBP`，`HighChol`，`Stroke`，`HeartDiseaseorAttack` | Conditions such as high blood pressure, high cholesterol, stroke, and history of heart disease |
| **Health Behaviors**   | `Smoker`，`HvyAlcoholConsump`，`PhysActivity`，`Fruits`，`Veggies` | Behaviors such as smoking, heavy alcohol consumption, physical activity, and fruit and vegetable intake    |
| **Healthcare Access** | `CholCheck`，`AnyHealthcare`，`NoDocbcCost`       | Cholesterol check, healthcare accessibility, and barriers to seeing a doctor due to cost  |
| **Self-Reported Health** | `GenHlth`，`MentHlth`，`PhysHlth`，`DiffWalk`    | General health status, mental health, physical health, and difficulty walking |
| **Demographics**      | `Sex`，`Age`                               | Gender and age group                      |
| **Physical Measurements** | `BMI`                                       | Body Mass Index (BMI)                        |

---

## **Main Content and Features**  

### **1. Diabetes Prediction Analysis Using Multiple Machine Learning Methods**  

- **Decision Tree Model**  
   - **Feature**: Simple and easy to interpret, achieving classification by recursively splitting features. 
   - **Advantages**: Easy to visualize, suitable for initial data exploration.  

- **Logistic Regression**  
   - **Feature**: A binary classification model based on linear regression that outputs probability values. 
   - **Advantages**: High computational efficiency, suitable for binary classification tasks. 

- **KNN Model**  
   - **Feature**: A non-parametric algorithm based on distance metrics, predicting results through nearest neighbors. 
   - **Advantages**: Intuitive and easy to understand, suitable for small datasets, but with high computational complexity.

- **Random Forest Model**  
   - **Feature**: Ensemble learning method that combines multiple decision trees for prediction.  
   - **Advantages**: Reduces overfitting and is suitable for high-dimensional data and nonlinear relationships.

- **XGBoost**  
   - **Feature**: A high-performance model based on gradient boosting. 
   - **Advantages**: Efficient and accurate, with strong generalization capability.

---

### **2. Optimization and Performance Enhancement of Machine Learning Algorithms**  

Due to the large sample size of the dataset, we attempted the following optimization methods: 

- **Parallel computing** and **Data partitioning**: Improve model performance efficiency.  
- **RCPP**: Implement complex computations using C++, with R for scheduling and organization.  
- **Dimensionality reduction**: Use PCA (Principal Component Analysis) and MCA (Multiple Correspondence Analysis) to reduce feature dimensionality and improve computational performance.

---

### **3. visualizations**  

Effective data visualization helps convey complex healthcare data and visually demonstrate the results and improvements of the algorithms. 

**The visualization includes**:   
1. **The ROC curves of various machine learning models.**  
2. **Comparison of runtime efficiency before and after model optimization.**(For example, using ggplot2 to create boxplots and bar charts) 

---

## **Project Highlights Summary**  
- **Multi-Model Analysis**: Diabetes prediction based on models such as KNN, Decision Trees, Random Forest, and XGBoost. 
- **Optimization of Algorithm Efficiency**: Achieving performance optimization through parallel computation, RCPP, and dimensionality reduction techniques. 
- **Visualization**: Provide intuitive visual results to facilitate the demonstration of model performance. 
- **Practical Significance**: Dedicated to assisting the healthcare sector by providing data-driven insights to predict the risk of diabetes. 

---

## License

This project is licensed under the [GNU General Public License Version 3 (GPL-3.0)](LICENSE).

By using, modifying, or distributing this software, you agree to the terms and conditions of the GPL-3.0. For more details, see the [full license text](https://www.gnu.org/licenses/gpl-3.0.html).

---