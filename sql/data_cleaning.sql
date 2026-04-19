-- Loan Approval Analytics - Data Cleaning

USE loan_analytics;


-- STEP 1: Check Missing Values (Column-wise)

SELECT 
    COUNT(*) AS total_rows,
    
    COUNT(*) - COUNT(Gender) AS missing_gender,
    COUNT(*) - COUNT(Married) AS missing_married,
    COUNT(*) - COUNT(Dependents) AS missing_dependents,
    COUNT(*) - COUNT(Self_Employed) AS missing_self_employed,
    COUNT(*) - COUNT(LoanAmount) AS missing_loan_amount,
    COUNT(*) - COUNT(Credit_History) AS missing_credit_history

FROM loan_raw;


-- STEP 2: Disable Safe Update Mode

SET SQL_SAFE_UPDATES = 0;


-- STEP 3: Handle Missing Values (ONLY if exist)

-- Gender
UPDATE loan_raw
SET Gender = 'Not Specified'
WHERE Gender IS NULL;

-- Married
UPDATE loan_raw
SET Married = 'No'
WHERE Married IS NULL;

-- Dependents
UPDATE loan_raw
SET Dependents = '0'
WHERE Dependents IS NULL;

-- Self Employed
UPDATE loan_raw
SET Self_Employed = 'No'
WHERE Self_Employed IS NULL;

-- Loan Amount (use safe subquery method)
UPDATE loan_raw
SET LoanAmount = (
    SELECT avg_loan FROM (
        SELECT AVG(LoanAmount) AS avg_loan FROM loan_raw
    ) AS temp
)
WHERE LoanAmount IS NULL;

-- Credit History (important feature)
UPDATE loan_raw
SET Credit_History = 1
WHERE Credit_History IS NULL;


-- STEP 4: Re-enable Safe Update Mode

SET SQL_SAFE_UPDATES = 1;


-- STEP 5: Create Clean Table

DROP TABLE IF EXISTS loan_clean;

CREATE TABLE loan_clean AS
SELECT 
    Loan_ID,
    Gender,
    Married,
    Dependents,
    Education,
    Self_Employed,
    ApplicantIncome,
    CoapplicantIncome,
    (ApplicantIncome + CoapplicantIncome) AS Total_Income,
    LoanAmount,
    Loan_Amount_Term,
    Credit_History,
    Property_Area,
    Loan_Status
FROM loan_raw;


-- STEP 6: Final Validation

SELECT COUNT(*) AS total_rows_clean FROM loan_clean;

SELECT * FROM loan_clean LIMIT 10;



ALTER TABLE loan_clean
ADD COLUMN Income_to_Loan_Ratio FLOAT,
ADD COLUMN Loan_Status_Label VARCHAR(10);

UPDATE loan_clean
SET 
    Income_to_Loan_Ratio = Total_Income / LoanAmount,
    Loan_Status_Label = CASE 
        WHEN Loan_Status = 'Y' THEN 'Approved'
        ELSE 'Rejected'
    END;