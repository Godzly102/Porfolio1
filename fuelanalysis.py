import pandas as pd

# Load the dataset
df = pd.read_csv('fuel.csv')


# Drop rows with NaN values across all columns
# Drop rows with NaN values only if they have less than a certain number of non-NaN values
df.dropna(thresh=3, inplace=True)  # Adjust '3' as needed


# Verify the changes
df.head()


# Check for missing values
missing_values = df.isnull().sum()
print("Missing Values:\n", missing_values)

# Drop rows with missing values
df = df.dropna()

# Check for duplicate rows
duplicate_rows = df.duplicated().sum()
print("\nDuplicate Rows:", duplicate_rows)

# Drop duplicate rows
df = df.drop_duplicates()

# Reset the index
df = df.reset_index(drop=True)

# Display the cleaned dataframe
df.head()


df

# Check for columns with all NaN values
all_nan_columns = df.columns[df.isnull().all()]

# Display columns with all NaN values
print("Columns with all NaN values:", all_nan_columns)


# Check the number of columns with all NaN values
num_all_nan_columns = len(all_nan_columns)

# Display the number of columns with all NaN values
print("Number of columns with all NaN values:", num_all_nan_columns)


# Count NaN values for each column
nan_counts = df.isnull().sum()

# Display NaN counts for each column
print("NaN counts for each column:")
print(nan_counts)


# Filter columns with NaN values
nan_columns = nan_counts[nan_counts > 0]

# Display columns with NaN values
print("Columns with NaN values:")
print(nan_columns)


# Total number of values for each column
total_values_per_column = df.count()

# Display total values for each column
print("Total values for each column:")
print(total_values_per_column)


# Filter columns with NaN values equal to the total number of rows
columns_to_drop = nan_columns[nan_columns == len(df)]

# Drop columns with all NaN values
df.drop(columns=columns_to_drop.index, inplace=True)

# Write the modified dataframe back to CSV
df.to_csv('cleaned_fuel.csv', index=False)


df

# Define threshold for NaN values
threshold = 15000

# Filter columns to drop based on NaN counts
columns_to_drop = nan_columns[(nan_columns > threshold) | (nan_columns.index.isin(['engine_descriptor', 'transmission_type']))]

# Drop columns with more than 15,000 NaN values and 'engine_descriptor', 'transmission_type'
df.drop(columns=columns_to_drop.index, inplace=True)

# Write the modified dataframe back to CSV
df.to_csv('cleaned_fuel.csv', index=False)


df

# Define threshold for NaN values
threshold = 15000

# Define columns to drop
columns_to_drop = ['engine_descriptor', 'transmission_type', 'supercharger', 'fuel_type_2', 'start_stop_technology', 'electric_motor', 'manufacturer_code', 'vehicle_charger', 'alternate_charger', 'range_ft2']

# Filter columns to drop based on NaN counts and existence in dataframe
columns_to_drop = [col for col in columns_to_drop if col in df.columns and (nan_counts[col] > threshold)]

# Drop columns with more than 15,000 NaN values and the specified columns
df.drop(columns=columns_to_drop, inplace=True)

# Write the modified dataframe back to CSV
df.to_csv('cleaned_fuel.csv', index=False)


df

# Compute summary statistics for fuel economy columns
summary_statistics_fuel_economy = df[['composite_city_mpg', 'composite_highway_mpg', 'composite_combined_mpg']].describe()

# Display summary statistics
print("Summary Statistics for Fuel Economy:")
print(summary_statistics_fuel_economy)


# Filter rows where fuel economy values are greater than zero
df = df[(df['composite_city_mpg'] > 0) & (df['composite_highway_mpg'] > 0) & (df['composite_combined_mpg'] > 0)]

# Reset index after filtering
df.reset_index(drop=True, inplace=True)

# Verify the changes
print(df.head())


df
