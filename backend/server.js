const express = require('express');
const sql = require('mssql/msnodesqlv8');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

// මීටර් එක කතිරෙටම වැඩ කරන Connection String එක
const dbConfig = {
    connectionString: "Driver={ODBC Driver 17 for SQL Server};Server=(localdb)\\MSSQLLocalDB;Database=ExpenseTrackerDB;Trusted_Connection=yes;"
};

// 1. පරණ Expenses ඇතුලත් කරන API එක (එහෙමම තියෙනවා)
app.post('/api/expenses', async (req, res) => {
    console.log("==> Request received from Flutter:", req.body); 
    try {
        const { userId, categoryId, amount, expenseDate, description } = req.body;

        let pool = await sql.connect(dbConfig);

        let result = await pool.request()
            .input('UserID', sql.Int, userId)
            .input('CategoryID', sql.Int, categoryId)
            .input('Amount', sql.Decimal(18, 2), amount) 
            .input('ExpenseDate', sql.Date, expenseDate)
            .input('Description', sql.NVarChar(255), description)
            .query(`
                INSERT INTO Expense (UserID, CategoryID, Amount, ExpenseDate, Description) 
                VALUES (@UserID, @CategoryID, @Amount, @ExpenseDate, @Description)
            `);

        console.log("==> Saved to Database successfully!");
        res.status(201).json({ success: true, message: 'Expense added successfully!' });

    } catch (err) {
        console.error('Database query error:', err);
        res.status(500).json({ success: false, message: 'Failed to add expense', error: err.message });
    }
});

// ====================================================================
// 👇 මෙන්න පියවර 2: ML FORECAST එක ඇප් එකට ලබාදෙන අලුත්ම API එක 👇
// ====================================================================
app.get('/api/forecast/2', async (req, res) => {
    console.log("==> Flutter requested ML Forecast value...");
    try {
        let pool = await sql.connect(dbConfig);
        let result = await pool.request()
            .query("SELECT MonthlyLimit FROM UserBudget WHERE UserID = 2 AND CategoryID = 1");
        
        if (result.recordset.length > 0) {
            let forecastVal = result.recordset[0].MonthlyLimit;
            console.log(`==> Sending ML Forecast to Flutter: $${forecastVal}`);
            res.json({ forecast: forecastVal });
        } else {
            console.log("==> No database values found, sending default values.");
            res.json({ forecast: 4850.00 }); // ඩේටාබේස් එකේ මුකුත් නැත්නම් default එකක්
        }
    } catch (err) {
        console.error('Database forecast query error:', err);
        res.status(500).json({ success: false, message: 'Failed to fetch forecast', error: err.message });
    }
});
// ====================================================================

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});