import pandas as pd
import pyodbc
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
import numpy as np
from datetime import timedelta
import datetime 




conn_str = (
    r'Driver={ODBC Driver 17 for SQL Server};'
    r'Server=(localdb)\MSSQLLocalDB;'
    r'Database=ExpenseTrackerDB;'
    r'Trusted_Connection=yes;'
)
conn = pyodbc.connect(conn_str)


query = "SELECT ExpenseDate, Amount FROM Expense ORDER BY ExpenseDate"
df = pd.read_sql(query, conn)


df_grouped = df.groupby('ExpenseDate').sum().reset_index()


df_grouped['DateOrdinal'] = pd.to_datetime(df_grouped['ExpenseDate']).map(datetime.datetime.toordinal)

X = df_grouped[['DateOrdinal']] 
y = df_grouped['Amount']       


model = LinearRegression()
model.fit(X, y)


last_date = pd.to_datetime(df_grouped['ExpenseDate'].max())
future_dates = [last_date + timedelta(days=i) for i in range(1, 8)]
future_ordinals = np.array([d.toordinal() for d in future_dates]).reshape(-1, 1)

predicted_amounts = model.predict(future_ordinals)


print("--- NEXT 7 DAYS SPENDING FORECAST ---")
for i in range(len(future_dates)):
    print(f"Date: {future_dates[i].strftime('%Y-%m-%d')} -> Predicted Spend: ${predicted_amounts[i]:.2f}")


plt.figure(figsize=(10, 5))
plt.plot(df_grouped['ExpenseDate'], df_grouped['Amount'], marker='o', label='Actual Expenses (Past)')
plt.plot(future_dates, predicted_amounts, marker='x', linestyle='--', color='red', label='Predicted Expenses (Future)')

plt.title('Spending Forecast using Machine Learning')
plt.xlabel('Date')
plt.ylabel('Expense Amount ($)')
plt.legend()
plt.grid(True)
plt.show()


# ---- අලුතින් එකතු කරන කෑල්ල: Prediction එක Database එකට යැවීම ----
total_predicted_next_month = float(np.sum(predicted_amounts) * 4) # සති 4ක එකතුව

cursor = conn.cursor()
# UserID 2 ගේ CategoryID 1 (Food) එකේ බජට් එක විදිහට මේ ML Forecast එක සේව් කරනවා
cursor.execute("""
    UPDATE UserBudget 
    SET MonthlyLimit = ? 
    WHERE UserID = 2 AND CategoryID = 1
""", (total_predicted_next_month,))
conn.commit()
print(f"Successfully saved ML Forecast (${total_predicted_next_month:.2f}) to Database!")
# -------------------------------------------------------------
# Connection එක close කිරීම
conn.close()