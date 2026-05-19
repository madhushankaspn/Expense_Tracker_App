import pandas as pd
import pyodbc
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
import numpy as np
from datetime import timedelta
import datetime # <-- මෙන්න මේකයි අඩුවෙලා තිබ්බේ!

# 1. Database එකට Connect වීම
conn_str = (
    r'Driver={ODBC Driver 17 for SQL Server};'
    r'Server=(localdb)\MSSQLLocalDB;'
    r'Database=ExpenseTrackerDB;'
    r'Trusted_Connection=yes;'
)
conn = pyodbc.connect(conn_str)

# 2. Database එකෙන් වියදම් කරපු දත්ත ටික ගැනීම
query = "SELECT ExpenseDate, Amount FROM Expense ORDER BY ExpenseDate"
df = pd.read_sql(query, conn)

# 3. Data ටික Machine Learning වලට ගැලපෙන විදියට හදාගැනීම
df_grouped = df.groupby('ExpenseDate').sum().reset_index()

# දිනය (Date) එක Machine learning වලට තේරෙන්නේ නැති නිසා ඒක අංකයක් (Ordinal) කරනවා
df_grouped['DateOrdinal'] = pd.to_datetime(df_grouped['ExpenseDate']).map(datetime.datetime.toordinal)

X = df_grouped[['DateOrdinal']] # x-axis (දින)
y = df_grouped['Amount']        # y-axis (වියදම් කරපු ගාන)

# 4. Machine Learning Model එක Train කිරීම (Linear Regression)
model = LinearRegression()
model.fit(X, y)

# 5. ඊළඟ දවස් 7 ට කොහොම වියදම් වෙයිද කියලා Predict කිරීම (Forecast)
last_date = pd.to_datetime(df_grouped['ExpenseDate'].max())
future_dates = [last_date + timedelta(days=i) for i in range(1, 8)]
future_ordinals = np.array([d.toordinal() for d in future_dates]).reshape(-1, 1)

# අනාගත වියදම් අනුමාන කිරීම
predicted_amounts = model.predict(future_ordinals)

# 6. ප්‍රතිඵල Print කිරීම සහ Graph එකක් ඇඳීම (Report එකට දාන්න)
print("--- NEXT 7 DAYS SPENDING FORECAST ---")
for i in range(len(future_dates)):
    print(f"Date: {future_dates[i].strftime('%Y-%m-%d')} -> Predicted Spend: ${predicted_amounts[i]:.2f}")

# Graph එක ඇඳීම
plt.figure(figsize=(10, 5))
plt.plot(df_grouped['ExpenseDate'], df_grouped['Amount'], marker='o', label='Actual Expenses (Past)')
plt.plot(future_dates, predicted_amounts, marker='x', linestyle='--', color='red', label='Predicted Expenses (Future)')

plt.title('Spending Forecast using Machine Learning')
plt.xlabel('Date')
plt.ylabel('Expense Amount ($)')
plt.legend()
plt.grid(True)
plt.show()

# Connection එක close කිරීම
conn.close()