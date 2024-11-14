# Import necessary libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error


# Load data from a CSV file
data = pd.read_csv('AustinPyData.csv')

# Display the first few rows
data.head()


# looking at the data 
# Basic visualizations
plt.figure(figsize=(10, 6))
sns.histplot(data['latestPrice'], bins=50, kde=True)
plt.title('Distribution of Latest Prices')
plt.xlabel('Latest Price')
plt.ylabel('Frequency')
plt.show()


# Convert categorical variables to numeric
data['homeTypeEncoded'] = data['homeType'].map({
    'Single Family': 1, 
    'Condo': 2, 
    'Townhouse': 3, 
    'Multi Family': 4
}).fillna(0)



# Prediction of Market
# Prepare data for modeling
X = data[['norm_livingAreaSqFt', 'norm_numOfBedrooms', 'norm_numOfBathrooms', 'homeTypeEncoded']]
y = data['norm_latestPrice']

# Split data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train a linear regression model
model = LinearRegression()
model.fit(X_train, y_train)

# Make predictions
predictions = model.predict(X_test)

# Evaluate the model
mse = mean_squared_error(y_test, predictions)
print(f'Mean Squared Error: {mse}')


#Prediction of future values viz
import matplotlib.pyplot as plt
import seaborn as sns

# Plot the actual vs predicted values
plt.figure(figsize=(10, 6))
sns.scatterplot(x=y_test, y=predictions, alpha=0.6)
plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], color='red', linestyle='--')
plt.xlabel('Actual Values')
plt.ylabel('Predicted Values')
plt.title('Actual vs Predicted Values')
plt.show()


from sklearn.metrics import r2_score

# Calculate R² Score
r2 = r2_score(y_test, predictions)
print(f'R² Score: {r2}')

from sklearn.model_selection import cross_val_score

# Perform cross-validation
cv_scores = cross_val_score(model, X, y, cv=5, scoring='neg_mean_squared_error')
cv_mse = -cv_scores.mean()
print(f'Cross-Validated MSE: {cv_mse}')

# Calculate baseline MSE (mean predictor)
baseline_predictions = [y_train.mean()] * len(y_test)
baseline_mse = mean_squared_error(y_test, baseline_predictions)
print(f'Baseline MSE (mean predictor): {baseline_mse}')


from sklearn.model_selection import GridSearchCV
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error, r2_score
import matplotlib.pyplot as plt
import seaborn as sns

# Define the model
rf_model = RandomForestRegressor(random_state=42)

# Define parameter grid with extended ranges
param_grid = {
    'n_estimators': [200, 250, 300, 350, 400],
    'max_depth': [6, 8, 10, 12, 14],
    'min_samples_split': [5, 7, 9, 11, 13],
    'min_samples_leaf': [1, 2, 3, 4, 5]
}

# Perform grid search
grid_search = GridSearchCV(estimator=rf_model, param_grid=param_grid, cv=5, scoring='neg_mean_squared_error', n_jobs=-1)
grid_search.fit(X_train, y_train)

# Best parameters from grid search
best_params = grid_search.best_params_
print(f'Best Parameters: {best_params}')

# Train model with best parameters
best_rf_model = RandomForestRegressor(**best_params, random_state=42)
best_rf_model.fit(X_train, y_train)

# Make predictions
rf_predictions = best_rf_model.predict(X_test)

# Evaluate the model
rf_mse = mean_squared_error(y_test, rf_predictions)
rf_r2 = r2_score(y_test, rf_predictions)
print(f'Random Forest MSE: {rf_mse}')
print(f'Random Forest R² Score: {rf_r2}')

# Visualize the actual vs predicted values
plt.figure(figsize=(10, 6))
sns.scatterplot(x=y_test, y=rf_predictions, alpha=0.6)
plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], color='red', linestyle='--')
plt.xlabel('Actual Values')
plt.ylabel('Predicted Values')
plt.title('Actual vs Predicted Values (Random Forest)')
plt.show()

# Visualize the distribution of residuals
rf_residuals = y_test - rf_predictions
plt.figure(figsize=(10, 6))
sns.histplot(rf_residuals, bins=50, kde=True)
plt.title('Distribution of Residuals (Random Forest)')
plt.xlabel('Residual')
plt.ylabel('Frequency')
plt.show()


