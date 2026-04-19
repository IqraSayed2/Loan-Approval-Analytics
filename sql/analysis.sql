-- Approval Rate

SELECT 
    Loan_Status,
    COUNT(*) AS count
FROM loan_clean
GROUP BY Loan_Status;


-- Credit History Impact

SELECT 
    Credit_History,
    Loan_Status,
    COUNT(*) AS count
FROM loan_clean
GROUP BY Credit_History, Loan_Status;


-- Income vs Approval

SELECT 
    Loan_Status,
    AVG(Total_Income) AS avg_income
FROM loan_clean
GROUP BY Loan_Status;


-- Property Area Analysis

SELECT 
    Property_Area,
    Loan_Status,
    COUNT(*) 
FROM loan_clean
GROUP BY Property_Area, Loan_Status;