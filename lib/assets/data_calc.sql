/* DISBURSEMENTS */
SELECT 
    DATE_TRUNC('year', created_at) AS disbursement_year,
    SUM(net_amount) AS total_net_amount,
	 SUM(collected_fee) AS total_fee
FROM 
    disbursements
GROUP BY 
    disbursement_year

/* FEES */
SELECT 
    DATE_TRUNC('year', created_at) AS fee_year,
	 SUM(fee) AS total_fee
FROM 
    remaining_monthly_fees
GROUP BY 
    fee_year