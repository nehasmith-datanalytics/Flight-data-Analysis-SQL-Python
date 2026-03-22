

# ✈️ Flight Booking Data Analysis -SQL-Python

## 📌 Project Overview
This project focuses on analyzing flight booking data to extract meaningful insights and build a basic machine learning model for predicting **SSR (Special Service Request) codes**.

The workflow includes:
- Data Cleaning & Preprocessing
- Feature Engineering
- Exploratory Data Analysis (EDA)
- Visualization
- Machine Learning Preparation & Modeling

---

## 🎯 Objective
- Analyze passenger booking behavior and flight trends
- Understand patterns in **routes, delays, and SSR requests**
- Identify key factors influencing SSR codes
- Build a predictive model for SSR classification

---

## 📊 Key Features & Transformations

### 🔹 Data Cleaning
- Converted `booking_date` and `flight_date` to datetime format
- Handled missing values in passenger names

### 🔹 Feature Engineering
- Created `passenger_name` by combining first, middle, last names
- Extracted:
  - `source` and `destination` from route
  - `delay_hour` and `delay_min` from delay_minutes
- Generated:
  - `month`, `year`
  - `age` from DOB
  - `Routes` (source-destination pair)

---

## 📈 Exploratory Data Analysis (EDA)

### 1. Monthly Flight Distribution
- Analyzed how flight frequency varies across months and years
<img width="1041" height="482" alt="image" src="https://github.com/user-attachments/assets/9047c977-719b-4547-bd48-24265c2ecc3d" />

### 2. SSR Distribution
- Visualized proportion of SSR codes per year using pie charts
<img width="489" height="469" alt="image" src="https://github.com/user-attachments/assets/484c618f-5016-43d6-a722-aeee8c57f411" />

### 3. Top Routes Analysis
- Identified most frequent flight routes
- Compared top routes across different years
<img width="1093" height="365" alt="image" src="https://github.com/user-attachments/assets/800a8d9d-ed41-4140-ac08-4aeef00ce067" />

---

## 📌 KPIs (Key Performance Indicators)

- ✈️ **Total Flights per Month/Year**
- 🧭 **Top 10 Routes by Passenger Volume**
- ⏱️ **Average Delay (Hours & Minutes)**
- 🎫 **SSR Code Distribution**
- ❌ **Cancellation Rate**
- 💳 **Payment Method Usage**

---

## 🔍 Key Insights

- Certain routes consistently dominate passenger traffic
- Seasonal trends observed in monthly flight distribution
- Delay patterns vary across routes and airlines
- SSR requests show distinct yearly patterns
- Passenger demographics (age) influence SSR selection
- Payment method and delays may correlate with SSR types

---

## 🤖 Machine Learning

### Model Used:
- Random Forest Classifier

### Features:
- Age
- Route
- Airline Code
- Delay Hours
- Cancellation Status
- Payment Method Type

### Target:
- SSR Code
<img width="1072" height="321" alt="image" src="https://github.com/user-attachments/assets/f0f36aeb-8a0e-40db-85a4-48065aadbc28" />


<img width="676" height="380" alt="image" src="https://github.com/user-attachments/assets/588700ba-3236-4fd9-a8ad-efbf6cc22531" />

### Steps:
- Label Encoding for categorical variables
- Train-Test Split (80/20)
- Model Training & Evaluation using Classification Report

---

## 🛠️ Tech Stack

- **Python**
- **Pandas** – Data manipulation
- **NumPy** – Numerical operations
- **Matplotlib / Seaborn** – Visualization
- **Scikit-learn** – Machine Learning
