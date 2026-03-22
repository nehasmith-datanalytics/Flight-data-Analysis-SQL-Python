"""
Flight Booking Data Processing & Analysis Script
Description:
This script performs data cleaning, feature engineering,
EDA (visualization), and basic ML preprocessing on flight booking data.
"""

# ==============================
# IMPORT LIBRARIES
# ==============================
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report


# ==============================
# DATA PREPROCESSING FUNCTIONS
# ==============================

def convert_dates(df):
    """
    Convert booking_date and flight_date to datetime format.
    """
    df['booking_date'] = pd.to_datetime(df['booking_date'])
    df['flight_date'] = pd.to_datetime(df['flight_date'])
    return df


def create_passenger_name(df):
    """
    Combine first, middle, and last names into a single passenger_name column.
    """
    df['passenger_name'] = (
        df[['first_name', 'middle_name', 'last_name']]
        .fillna('')
        .agg(' '.join, axis=1)
        .str.strip()
    )
    return df


def extract_route_info(df):
    """
    Extract source and destination from route column.
    """
    df['source'] = df['route'].str[:3]
    df['destination'] = df['route'].str[-3:]
    return df


def convert_delay(df):
    """
    Convert delay_minutes into hours and minutes.
    """
    df['delay_hour'] = df['delay_minutes'] // 60
    df['delay_min'] = df['delay_minutes'] % 60
    return df


def create_features(df):
    """
    Create additional features like month, year, age, and routes.
    """
    df['month'] = df['flight_date'].dt.month_name()
    df['year'] = df['flight_date'].dt.year

    # Calculate age
    df['age'] = (pd.to_datetime('today') - pd.to_datetime(df['DOB'])).dt.days // 365

    # Route combination
    df['Routes'] = df['source'] + "-" + df['destination']

    return df


# ==============================
# VISUALIZATION FUNCTIONS
# ==============================

def plot_monthly_distribution(df):
    """
    Plot flight distribution per month for each year.
    """
    month_order = ['January','February','March','April','May','June',
                   'July','August','September','October','November','December']

    for yr in sorted(df['year'].unique()):
        month_counts = (
            df[df['year'] == yr]['month']
            .value_counts()
            .reindex(month_order)
            .fillna(0)
        )

        plt.figure(figsize=(10,5))
        sns.barplot(x=month_counts.index, y=month_counts.values, palette="coolwarm")
        plt.title(f"Flight Distribution by Month ({yr})")
        plt.xticks(rotation=45)
        plt.tight_layout()
        plt.show()


def plot_ssr_distribution(df):
    """
    Plot SSR code distribution per year.
    """
    for yr in sorted(df['year'].unique()):
        ssr_counts = df[df['year'] == yr]['ssr_code'].value_counts()

        plt.figure(figsize=(5,5))
        plt.pie(ssr_counts.values, labels=ssr_counts.index,
                autopct='%1.1f%%', startangle=90)
        plt.title(f"SSR Distribution ({yr})")
        plt.tight_layout()
        plt.show()


def plot_top_routes(df):
    """
    Plot top 10 routes overall.
    """
    route_counts = df['Routes'].value_counts().head(10)

    plt.figure(figsize=(12,6))
    sns.barplot(x=route_counts.values, y=route_counts.index, palette='magma')
    plt.title("Top 10 Flight Routes")
    plt.tight_layout()
    plt.show()


def plot_top_routes_by_year(df):
    """
    Plot top 10 routes for each year using FacetGrid.
    """
    route_year_counts = df.groupby(['year','Routes']).size().reset_index(name='count')

    top_routes_by_year = route_year_counts.groupby('year').apply(
        lambda x: x.nlargest(10, 'count')
    ).reset_index(drop=True)

    g = sns.FacetGrid(top_routes_by_year, col="year", sharex=False, sharey=False)
    g.map_dataframe(sns.barplot, x="count", y="Routes", palette="magma")
    g.set_titles("Year: {col_name}")
    plt.tight_layout()
    plt.show()


# ==============================
# MACHINE LEARNING PREPARATION
# ==============================

def prepare_ml_data(df):
    """
    Prepare features and target variable for ML.
    """
    X = df[['age','Routes','airline_code','delay_hour','cancelled','payment_method_type']]
    y = df['ssr_code']

    return X, y


def encode_features(X):
    """
    Encode categorical variables using LabelEncoder.
    """
    le = LabelEncoder()

    for col in X.select_dtypes(include='object').columns:
        X[col] = le.fit_transform(X[col])

    return X


# ==============================
# MAIN FUNCTION
# ==============================

def main():
    """
    Main execution function.
    """

    # Load dataset (update path)
    df = pd.read_csv("booking_data.csv")

    # Data processing
    df = convert_dates(df)
    df = create_passenger_name(df)
    df = extract_route_info(df)
    df = convert_delay(df)
    df = create_features(df)

    # Visualizations
    plot_monthly_distribution(df)
    plot_ssr_distribution(df)
    plot_top_routes(df)
    plot_top_routes_by_year(df)

    # ML prep
    X, y = prepare_ml_data(df)
    X = encode_features(X)

    # Train-test split
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

    # Model training
    model = RandomForestClassifier()
    model.fit(X_train, y_train)

    # Predictions
    y_pred = model.predict(X_test)

    # Evaluation
    print(classification_report(y_test, y_pred))


# ==============================
# RUN SCRIPT
# ==============================
if __name__ == "__main__":
    main()