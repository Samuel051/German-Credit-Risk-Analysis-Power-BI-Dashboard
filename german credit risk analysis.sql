SELECT current_database();
CREATE TABLE credit_risk (
    customer_id SERIAL PRIMARY KEY,
    age INT,
    sex VARCHAR(10),
    job INT,
    housing VARCHAR(20),
    saving_accounts VARCHAR(30),
    checking_account VARCHAR(30),
    credit_amount INT,
    duration INT,
    purpose VARCHAR(50),
    risk VARCHAR(10)
);

select *
from credit_risk
limit 15;

--- Portfolio Summary

CREATE VIEW vw_portfolio_kpis AS
SELECT
    COUNT(*) AS total_borrowers,
    SUM(credit_amount) AS total_exposure,
    ROUND(AVG(credit_amount),2) AS avg_credit_amount,
    MAX(credit_amount) AS max_credit_amount,
    MIN(credit_amount) AS min_credit_amount,
    ROUND(AVG(duration),2) AS avg_duration,
    MAX(duration) AS max_duration,
    MIN(duration) AS min_duration,
    SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END) AS bad_borrowers,
    SUM(CASE WHEN risk = 'good' THEN 1 ELSE 0 END) AS good_borrowers,
    ROUND(
        100.0 * SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS portfolio_default_rate,
    SUM(
        CASE WHEN risk = 'bad'
THEN credit_amount
             ELSE 0
        END
    ) AS total_risky_exposure,
    ROUND(
        100.0 *
        SUM(CASE WHEN risk = 'bad'
                 THEN credit_amount
                 ELSE 0
            END)
        / SUM(credit_amount),
    2) AS risky_exposure_ratio
FROM credit_risk;


select *
from vw_portfolio_kpis;

---- Risk Distribution
select risk, count(*) as borrowers
from credit_risk
group by risk;

--- Loan purpose analysis
SELECT 
    purpose,
    COUNT(*) AS total_loans,
    AVG(credit_amount) AS avg_credit
FROM credit_risk
GROUP BY purpose
ORDER BY total_loans DESC;


--- Age Group Analysis
CREATE VIEW vw_age_analysis AS
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25 Young Adults'
        WHEN age BETWEEN 26 AND 35 THEN '26-35 Early Career'
        WHEN age BETWEEN 36 AND 50 THEN '36-50 Mid Career'
        WHEN age BETWEEN 51 AND 65 THEN '51-65 Mature Adults'
        ELSE '66+ Senior Customers'
    END AS age_group,
    COUNT(*) AS total_borrowers,
    ROUND(AVG(credit_amount),2) AS avg_credit_amount,
    ROUND(AVG(duration),2) AS avg_duration,
    SUM(CASE WHEN risk = 'good' THEN 1 ELSE 0 END) AS good_risk,
    SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END) AS bad_risk,
    ROUND(
        100.0 * SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS default_rate
FROM credit_risk
GROUP BY age_group;



--- Age Group + Loan Purpose Analysis
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25 Young Adults'
        WHEN age BETWEEN 26 AND 35 THEN '26-35 Early Career'
        WHEN age BETWEEN 36 AND 50 THEN '36-50 Mid Career'
        WHEN age BETWEEN 51 AND 65 THEN '51-65 Mature Adults'
        ELSE '66+ Senior Customers'
    END AS age_group,
    purpose,
    COUNT(*) AS total_loans,
    ROUND(AVG(credit_amount),2) AS avg_credit
FROM credit_risk
GROUP BY age_group, purpose
ORDER BY age_group, total_loans DESC;


----- Gender Analysis
create view vw_gender_analysis as
SELECT
    sex,
    COUNT(*) AS total_borrowers,
    ROUND(AVG(credit_amount),2) AS avg_credit_amount,
    ROUND(AVG(duration),2) AS avg_duration,
    SUM(CASE WHEN risk = 'good' THEN 1 ELSE 0 END) AS good_risk,
    SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END) AS bad_risk,
    ROUND(
        100.0 * SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS default_rate
FROM credit_risk
GROUP BY sex;



--- Gender + Loan Purpose Analysis
SELECT
    sex,
    purpose,
    COUNT(*) AS total_loans,
    ROUND(AVG(credit_amount),2) AS avg_credit_amount,
    ROUND(AVG(duration),2) AS avg_duration
FROM credit_risk
GROUP BY sex, purpose
ORDER BY sex, total_loans DESC;


--- Job Risk Analytics
create view vw_job_analysis as
SELECT
    CASE
        WHEN job = 0 THEN 'Unskilled Non-Resident'
        WHEN job = 1 THEN 'Unskilled Resident'
        WHEN job = 2 THEN 'Skilled'
        WHEN job = 3 THEN 'Highly Skilled'
    END AS job_category,
    COUNT(*) AS total_borrowers,
    ROUND(AVG(credit_amount),2) AS avg_credit_amount,
    ROUND(AVG(duration),2) AS avg_duration,
    SUM(CASE WHEN risk = 'good' THEN 1 ELSE 0 END) AS good_risk,
    SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END) AS bad_risk,
    ROUND(
        100.0 * SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS default_rate
FROM credit_risk
GROUP BY job_category;



---- Job Category + Loan Purpose
SELECT
    CASE
        WHEN job = 0 THEN 'Unskilled Non-Resident'
        WHEN job = 1 THEN 'Unskilled Resident'
        WHEN job = 2 THEN 'Skilled'
        WHEN job = 3 THEN 'Highly Skilled'
		END AS job_category,
    purpose,
    COUNT(*) AS total_loans,
    ROUND(AVG(credit_amount),2) AS avg_credit_amount
FROM credit_risk
GROUP BY job_category, purpose
ORDER BY job_category, total_loans DESC;

--- Housing Risk Analysis
CREATE VIEW vw_housing_analysis AS
SELECT
    housing,
    COUNT(*) AS total_borrowers,
    ROUND(AVG(credit_amount),2) AS avg_credit_amount,
    ROUND(AVG(duration),2) AS avg_duration,
    SUM(CASE WHEN risk = 'good' THEN 1 ELSE 0 END) AS good_risk,
    SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END) AS bad_risk,
    ROUND(
        100.0 * SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS default_rate
FROM credit_risk
GROUP BY housing
;




--- Saving Accounts Risk Analysis
create view vw_savings_analysis as
SELECT
    saving_accounts,
    COUNT(*) AS total_borrowers,
    ROUND(AVG(credit_amount),2) AS avg_credit_amount,
    ROUND(AVG(duration),2) AS avg_duration,
    SUM(CASE WHEN risk = 'good' THEN 1 ELSE 0 END) AS good_risk,
    SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END) AS bad_risk,
    ROUND(
        100.0 * SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS default_rate
FROM credit_risk
GROUP BY saving_accounts
;


--- Checking Account Risk Analysis
create view vw_checking_analysis as
SELECT
    checking_account,
    COUNT(*) AS total_borrowers,
    ROUND(AVG(credit_amount),2) AS avg_credit_amount,
    ROUND(AVG(duration),2) AS avg_duration,
    SUM(CASE WHEN risk = 'good' THEN 1 ELSE 0 END) AS good_risk,
    SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END) AS bad_risk,
    ROUND(
        100.0 * SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS default_rate
FROM credit_risk
GROUP BY checking_account
;




--- Purpose Risk Analysis
create view vw_purpose_analysis as
SELECT
    purpose,
    COUNT(*) AS total_borrowers,
    ROUND(AVG(credit_amount),2) AS avg_credit_amount,
    ROUND(AVG(duration),2) AS avg_duration,
    SUM(CASE WHEN risk = 'good' THEN 1 ELSE 0 END) AS good_risk,
    SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END) AS bad_risk,
    ROUND(
        100.0 * SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS default_rate
FROM credit_risk
GROUP BY purpose
;


---- Loan Exposure Analysis

-----Age-Group loan exposure
create view vw_age_loan_exp as
WITH age_segmentation AS (
    SELECT
        CASE
            WHEN age BETWEEN 18 AND 25 THEN '18-25 Young Adults'
            WHEN age BETWEEN 26 AND 35 THEN '26-35 Early Career'
            WHEN age BETWEEN 36 AND 50 THEN '36-50 Mid Career'
            WHEN age BETWEEN 51 AND 65 THEN '51-65 Mature Adults'
            ELSE '66+ Senior Customers'
        END AS age_group,
        credit_amount,
        duration,
        risk
    FROM credit_risk
),
portfolio_total AS (
    SELECT
        SUM(credit_amount) AS total_portfolio_exposure
    FROM age_segmentation
)
SELECT
    a.age_group,
    COUNT(*) AS total_borrowers,
    SUM(a.credit_amount) AS total_exposure,
    ROUND(AVG(a.credit_amount),2) AS avg_credit_amount,
    ROUND(AVG(a.duration),2) AS avg_duration,
    SUM(CASE WHEN a.risk = 'bad' THEN 1 ELSE 0 END) AS bad_borrowers,
    ROUND(
        100.0 * SUM(CASE WHEN a.risk = 'bad' THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS default_rate,
    ROUND(
        100.0 * SUM(a.credit_amount)
        / p.total_portfolio_exposure,
    2) AS exposure_share_pct
FROM age_segmentation a
CROSS JOIN portfolio_total p
GROUP BY
    a.age_group,
    p.total_portfolio_exposure;



--- Job Segmentation loan exposure
create view vw_job_loan_exp as
WITH job_segmentation AS (
    SELECT
        CASE
            WHEN job = 0 THEN 'Unskilled Non-Resident'
            WHEN job = 1 THEN 'Unskilled Resident'
            WHEN job = 2 THEN 'Skilled'
            WHEN job = 3 THEN 'Highly Skilled'
        END AS job_category,
        credit_amount,
        duration,
        risk
    FROM credit_risk
),
portfolio_total AS (
    SELECT
        SUM(credit_amount) AS total_portfolio_exposure
    FROM job_segmentation
)
SELECT
    j.job_category,
    COUNT(*) AS total_borrowers,
    SUM(j.credit_amount) AS total_exposure,
    ROUND(AVG(j.credit_amount),2) AS avg_credit_amount,
    ROUND(AVG(j.duration),2) AS avg_duration,
    SUM(CASE WHEN j.risk = 'bad' THEN 1 ELSE 0 END) AS bad_borrowers,
    ROUND(
        100.0 * SUM(CASE WHEN j.risk = 'bad' THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS default_rate,
    ROUND(
        100.0 * SUM(j.credit_amount)
        / p.total_portfolio_exposure,
    2) AS exposure_share_pct
FROM job_segmentation j
CROSS JOIN portfolio_total p
GROUP BY
    j.job_category,
    p.total_portfolio_exposure;




--- Housing loan exposure
create view vw_housing_loan_exp as
select 
      housing, count(*) as total_borrowers,
	  sum(credit_amount) as total_exposure,
	  round(avg(credit_amount),2) as avg_credit_amount,
	  round(avg(duration),2) as avg_duration,
	  sum(case when risk = 'bad' then 1 else 0 end) as bad_borrowers,
	  round(100.0 * sum(case when risk = 'bad' then 1 else 0 end)
	   / count(*),2) as default_rate,
	   round(100.0 * sum(credit_amount)/
	   (select sum(credit_amount)
	    from credit_risk),2) as esposure_share_pct
		from credit_risk
group by housing;	

--- Loan Purpose exposure
create view vw_purpose_loan_exp as
SELECT 
    purpose,
    COUNT(*) AS total_borrowers,
    SUM(credit_amount) AS total_exposure,
    ROUND(AVG(credit_amount),2) AS avg_credit_amount,
    ROUND(AVG(duration),2) AS avg_duration,
    SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END) AS bad_borrowers,
    ROUND(
        100.0 * SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS default_rate,
    ROUND(
        100.0 * SUM(credit_amount) /
        (SELECT SUM(credit_amount)
         FROM credit_risk),
    2) AS exposure_share_pct
FROM credit_risk
GROUP BY purpose;



---- Gender Loan Exposure Analysis
create view vw_gender_loan_exp as
SELECT 
    sex,
    COUNT(*) AS total_borrowers,
    SUM(credit_amount) AS total_exposure,
    ROUND(AVG(credit_amount),2) AS avg_credit_amount,
    ROUND(AVG(duration),2) AS avg_duration,
    SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END) AS bad_borrowers,
    ROUND(
        100.0 * SUM(CASE WHEN risk = 'bad' THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS default_rate,
    ROUND(
        100.0 * SUM(credit_amount)
        / (SELECT SUM(credit_amount)
           FROM credit_risk),
    2) AS exposure_share_pct
FROM credit_risk
GROUP BY sex;


---- Risky Loan Exposure / Concentration Analysis
-----Age Group Risky Exposure Analysis
CREATE VIEW vw_age_risk_exp as
WITH risky_loans AS (
 SELECT
        CASE
            WHEN age BETWEEN 18 AND 25 THEN '18-25 Young Adults'
            WHEN age BETWEEN 26 AND 35 THEN '26-35 Early Career'
            WHEN age BETWEEN 36 AND 50 THEN '36-50 Mid Career'
            WHEN age BETWEEN 51 AND 65 THEN '51-65 Mature Adults'
            ELSE '66+ Senior Customers'
        END AS age_group,
        credit_amount,
        duration
    FROM credit_risk
    WHERE risk = 'bad'
),
total_risky_exposure AS (
    SELECT
        SUM(credit_amount) AS total_bad_exposure
    FROM risky_loans
)
SELECT
    r.age_group,
    COUNT(*) AS bad_borrowers,
    SUM(r.credit_amount) AS risky_exposure,
    ROUND(AVG(r.credit_amount),2) AS avg_risky_loan,
    ROUND(AVG(r.duration),2) AS avg_risky_duration,
    ROUND(
        100.0 * SUM(r.credit_amount)
        / t.total_bad_exposure,
    2) AS risky_exposure_share_pct
FROM risky_loans r
CROSS JOIN total_risky_exposure t
GROUP BY
    r.age_group,
    t.total_bad_exposure;


--- Job Category Risky Exposure Analysis
CREATE VIEW vw_job_risk_exp as
WITH risky_loans AS (
    SELECT
        CASE
            WHEN job = 0 THEN 'Unskilled Non-Resident'
            WHEN job = 1 THEN 'Unskilled Resident'
            WHEN job = 2 THEN 'Skilled'
            WHEN job = 3 THEN 'Highly Skilled'
        END AS job_category,
        credit_amount,
        duration
    FROM credit_risk
    WHERE risk = 'bad'
),
total_risky_exposure AS (
    SELECT
        SUM(credit_amount) AS total_bad_exposure
    FROM risky_loans
)
SELECT
    r.job_category,
    COUNT(*) AS bad_borrowers,
    SUM(r.credit_amount) AS risky_exposure,
    ROUND(AVG(r.credit_amount),2) AS avg_risky_loan,
    ROUND(AVG(r.duration),2) AS avg_risky_duration,
    ROUND(
        100.0 * SUM(r.credit_amount)
        / t.total_bad_exposure,
    2) AS risky_exposure_share_pct
FROM risky_loans r
CROSS JOIN total_risky_exposure t
GROUP BY
    r.job_category,
    t.total_bad_exposure;



------ Housing Risky Exposure Analysis
create view vw_housing_risk_exp as
WITH risky_loans AS (
    SELECT
        housing,
        credit_amount,
        duration
    FROM credit_risk
    WHERE risk = 'bad'
),
total_risky_exposure AS (
    SELECT
        SUM(credit_amount) AS total_bad_exposure
    FROM risky_loans
)
SELECT
    r.housing,
    COUNT(*) AS bad_borrowers,
    SUM(r.credit_amount) AS risky_exposure,
    ROUND(AVG(r.credit_amount),2) AS avg_risky_loan,
    ROUND(AVG(r.duration),2) AS avg_risky_duration,
    ROUND(
        100.0 * SUM(r.credit_amount)
        / t.total_bad_exposure,
    2) AS risky_exposure_share_pct
FROM risky_loans r
CROSS JOIN total_risky_exposure t
GROUP BY
    r.housing,
    t.total_bad_exposure;



--- Loan Purpose Risky Exposure Analysis
CREATE VIEW vw_purpose_risk_exp as
WITH risky_loans AS (
    SELECT
        purpose,
        credit_amount,
        duration
    FROM credit_risk
    WHERE risk = 'bad'
),
total_risky_exposure AS (
    SELECT
        SUM(credit_amount) AS total_bad_exposure
    FROM risky_loans
)
SELECT
    r.purpose,
    COUNT(*) AS bad_borrowers,
    SUM(r.credit_amount) AS risky_exposure,
    ROUND(AVG(r.credit_amount),2) AS avg_risky_loan,
    ROUND(AVG(r.duration),2) AS avg_risky_duration,
    ROUND(
        100.0 * SUM(r.credit_amount)
        / t.total_bad_exposure,
    2) AS risky_exposure_share_pct
FROM risky_loans r
CROSS JOIN total_risky_exposure t
GROUP BY
    r.purpose,
    t.total_bad_exposure;

--- Gender Risky Exposure
create view vw_gender_risk_exp as
WITH risky_loans AS (
    SELECT
        sex,
        credit_amount,
        duration
    FROM credit_risk
    WHERE risk = 'bad'
),
total_risky_exposure AS (
    SELECT
        SUM(credit_amount) AS total_bad_exposure
    FROM risky_loans
)
SELECT
    r.sex,
    COUNT(*) AS bad_borrowers,
    SUM(r.credit_amount) AS risky_exposure,
    ROUND(AVG(r.credit_amount),2) AS avg_risky_loan,
    ROUND(AVG(r.duration),2) AS avg_risky_duration,
    ROUND(
        100.0 * SUM(r.credit_amount)
        / t.total_bad_exposure,
    2) AS risky_exposure_share_pct
FROM risky_loans r
CROSS JOIN total_risky_exposure t
GROUP BY
    r.sex,
    t.total_bad_exposure;

--- Duration Band risk analysis

select min(duration) as min_duration,
       max(duration) as max_duration
from credit_risk;

select
      min(duration) as min_duration,
	  max(duration) as max_duration,
	  (max(duration)- min(duration))/4.0
as class_width
from credit_risk;

CREATE VIEW vw_duration_risk_exp as
with risky_loans as(
 select
     case
	     when duration between 4 and 21 then 'short_term'
		 when duration between 22 and 38 then 'medium_term'
		 when duration between 39 and 55 then 'long_term'
		 else 'very_long_term'
		 end as duration_band,
		 credit_amount
		 from credit_risk
		 where risk = 'bad'),
total_risk_exposure as
         (select sum(credit_amount)as total_bad_exposure
		  from risky_loans)
select
     r.duration_band,
	 count(*) as total_borrowers,
	 sum(r.credit_amount) as total_exposure,
	 avg(r.credit_amount) as avg_exposure,
	 round(100.0 *sum(r.credit_amount)/t.total_bad_exposure,2)
	 as risk_exposure_share_pct
from risky_loans r
cross join total_risk_exposure t
         group by r.duration_band,
		          t.total_bad_exposure;



-- credit band risk exposure
select min(credit_amount) as min_credit,
       max(credit_amount) as max_credit,
	   round((max(credit_amount)-min(credit_amount)),0)/4.0
from credit_risk;
   



CREATE VIEW vw_creditband_risk_exp as
WITH risky_loans AS (
    SELECT
        CASE
            WHEN credit_amount BETWEEN 250 AND 4794 THEN 'small_loans'
            WHEN credit_amount BETWEEN 4795 AND 9338 THEN 'medium_loans'
            WHEN credit_amount BETWEEN 9339 AND 13882 THEN 'large_loans'
            ELSE 'very_large_loans'
        END AS credit_band,
        credit_amount,
        duration
    FROM credit_risk
    WHERE risk = 'bad'
),
total_risk_exposure AS (
    SELECT
        SUM(credit_amount) AS total_bad_exposure
    FROM risky_loans
)
SELECT
    r.credit_band,
    COUNT(*) AS bad_borrowers,
    SUM(r.credit_amount) AS risky_exposure,
    ROUND(AVG(r.credit_amount),2) AS avg_risky_loan,
    ROUND(AVG(r.duration),2) AS avg_duration,
    ROUND(
        100.0 * SUM(r.credit_amount)
        / t.total_bad_exposure,
    2) AS risk_exposure_share_pct
FROM risky_loans r
CROSS JOIN total_risk_exposure t
GROUP BY
    r.credit_band,
    t.total_bad_exposure;







