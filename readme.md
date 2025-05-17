# Loan Default Prediction Using LendingClub Data

## Overview
This project uses historical LendingClub data (2007–2018) to predict whether a borrower will default on a loan. It includes exploratory data analysis, machine learning models (Logistic Regression and Random Forest), and a return simulation to evaluate risk-based funding strategies. 

## Key Questions
- Which loan types and borrower profiles are most likely to default?
- Can we accurately predict loan default using available data?
- How does predicted risk affect expected return across loan segments?

## Tools & Libraries
- Python (Pandas, NumPy, Scikit-learn, Seaborn, Matplotlib)
- Jupyter Notebook

## Dataset
- Source: LendingClub public loan data on Kaggle
- Size: ~2.2M loans from 2007–2018
- Target: `loan_status` (converted to binary: Fully Paid = 0, Default/Charged Off = 1)

## Exploratory Data Analysis (EDA)
- Default rate increases significantly from loan Grade A to G
- Small business loans have the highest default rate by purpose
- Employment length showed little correlation with default likelihood

## Modeling
### Logistic Regression
- Accuracy: 80%
- ROC AUC: 0.66
- Struggled to detect defaults due to class imbalance

### Random Forest
- Accuracy: 79.8%
- ROC AUC: 0.68
- Better F1 score on default class
- Feature importance revealed top drivers of default:
  - Interest rate
  - Debt-to-income ratio
  - Loan grade

## Risk-Based Return Simulation
Loans were grouped into 3 risk tiers based on predicted default probability:
- Low Risk (<10%)
- Medium Risk (10–20%)
- High Risk (20%+)

I simulated **expected return** using:
expected_return = interest_rate * (1 - predicted_default_probability)

**Finding:**  
Medium-risk loans offered the highest average expected return, balancing yield and risk exposure. 


