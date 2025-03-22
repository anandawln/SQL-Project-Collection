CREATE TABLE kf_dataset.kf_analisis AS
SELECT 
    f.transaction_id,
    f.date, 
    f.branch_id, 
    k.branch_name, 
    k.kota,
    k.provinsi,
    k.rating AS rating_cabang, 
    f.customer_name, 
    f.product_id, 
    p.product_name, 
    p.price AS actual_price, 
    f.discount_percentage,
    CASE
        WHEN p.price <= 50000 THEN 0.1
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.2
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        WHEN p.price > 500000 THEN 0.3
    END AS persentase_gross_laba,
    p.price * (1 - (f.discount_percentage / 100)) AS nett_sales,
    (p.price * (1 - (f.discount_percentage / 100))) * (
        CASE
            WHEN p.price <= 50000 THEN 0.1
            WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
            WHEN p.price > 100000 AND p.price <= 300000 THEN 0.2
            WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
            WHEN p.price > 500000 THEN 0.3
        END) AS nett_profit,
    f.rating AS rating_transaksi
FROM 
    kf_dataset.kf_final_transaction AS f
LEFT JOIN kf_dataset.kf_kantor_cabang AS k
    ON f.branch_id = k.branch_id
LEFT JOIN kf_dataset.kf_product AS p
    ON f.product_id = p.product_id;