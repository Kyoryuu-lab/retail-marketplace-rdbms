-- ============================================================================
-- Project:     Retail Marketplace RDBMS
-- File:        sql/queries.sql
-- Description: Analytical business SQL queries for retail intelligence:
--              profit margins, employee sales performance, inventory valuation,
--              and warranty cross-selling metrics.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Запрос 1: Детальный отчет по продажам с расчетом чистой прибыли (Net Margin)
-- Бизнес-цель: Объединяет 7 таблиц, учитывает персональную скидку покупателя
--              по дисконтной карте и рассчитывает фактическую чистую прибыль (Net Profit)
--              с каждой проданной позиции.
-- ----------------------------------------------------------------------------
SELECT
    s.id_sales AS sale_id,
    p.model AS device_model,
    f.name AS brand,
    p.selling_price AS base_price,
    COALESCE(d.percent, 0) AS discount_pct,
    ROUND(p.selling_price * (1.0 - (COALESCE(d.percent, 0) / 100.0)), 2) AS effective_price,
    ROUND((p.selling_price * (1.0 - (COALESCE(d.percent, 0) / 100.0))) - p.purchase_price, 2) AS net_profit_unit,
    ROUND(((p.selling_price * (1.0 - (COALESCE(d.percent, 0) / 100.0))) - p.purchase_price) * o.quantity, 2) AS total_order_profit,
    e.surname || ' ' || SUBSTR(e.name, 1, 1) || '.' AS sales_agent,
    m.address AS store_location
FROM sales s
JOIN "order" o     ON s.id_order = o.id_order
JOIN phone p       ON o.id_phone = p.id_phone
JOIN firm f        ON p.id_firm = f.id_firm
JOIN employee e    ON s.id_employee = e.id_employee
JOIN market m      ON s.id_market = m.id_market
LEFT JOIN discount d ON o.id_discount = d.id_discount
ORDER BY s.id_sales ASC;


-- ----------------------------------------------------------------------------
-- Запрос 2: Рейтинг брендов и моделей по выручке и количеству продаж
-- Бизнес-цель: Агрегирует проданные единицы и вычисляет валовую выручку (Gross Revenue),
--              чтобы выявить лидеров ассортимента (Best-Sellers).
-- ----------------------------------------------------------------------------
SELECT
    f.name AS brand,
    p.model AS phone_model,
    f.producing_country,
    SUM(o.quantity) AS total_units_sold,
    ROUND(SUM(p.selling_price * (1.0 - (COALESCE(d.percent, 0) / 100.0)) * o.quantity), 2) AS gross_revenue
FROM sales s
JOIN "order" o       ON s.id_order = o.id_order
JOIN phone p         ON o.id_phone = p.id_phone
JOIN firm f          ON p.id_firm = f.id_firm
LEFT JOIN discount d ON o.id_discount = d.id_discount
GROUP BY f.name, p.model, f.producing_country
ORDER BY gross_revenue DESC;


-- ----------------------------------------------------------------------------
-- Запрос 3: Оценка эффективности сотрудников (KPI & Performance)
-- Бизнес-цель: Считает общее количество успешных сделок, привлеченную выручку
--              и средний чек (Average Order Value) каждого менеджера по продажам.
-- ----------------------------------------------------------------------------
SELECT
    e.id_employee,
    e.surname || ' ' || e.name AS employee_name,
    e.position,
    COUNT(s.id_sales) AS deals_count,
    ROUND(SUM(p.selling_price * (1.0 - (COALESCE(d.percent, 0) / 100.0)) * o.quantity), 2) AS total_generated_revenue,
    ROUND(AVG(p.selling_price * (1.0 - (COALESCE(d.percent, 0) / 100.0)) * o.quantity), 2) AS average_order_value
FROM employee e
JOIN sales s         ON e.id_employee = s.id_employee
JOIN "order" o       ON s.id_order = o.id_order
JOIN phone p         ON o.id_phone = p.id_phone
LEFT JOIN discount d ON o.id_discount = d.id_discount
GROUP BY e.id_employee, e.surname, e.name, e.position
ORDER BY total_generated_revenue DESC;


-- ----------------------------------------------------------------------------
-- Запрос 4: Анализ складских запасов в разрезе поставщиков (Supply Chain Valuation)
-- Бизнес-цель: Оценивает финансовый объем застрявшего на складе капитала
--              (Capital Tied in Inventory) и потенциальную маржу при 100% распродаже.
-- ----------------------------------------------------------------------------
SELECT
    pr.name AS provider_name,
    pr.phone_number AS contact_phone,
    COUNT(p.id_phone) AS distinct_models_supplied,
    SUM(p.quantity) AS total_units_in_stock,
    ROUND(SUM(p.purchase_price * p.quantity), 2) AS total_inventory_cost,
    ROUND(SUM(p.selling_price * p.quantity), 2) AS potential_retail_revenue,
    ROUND(SUM((p.selling_price - p.purchase_price) * p.quantity), 2) AS projected_gross_margin
FROM provider pr
JOIN phone p ON pr.id_provider = p.id_provider
GROUP BY pr.id_provider, pr.name, pr.phone_number
ORDER BY total_inventory_cost DESC;


-- ----------------------------------------------------------------------------
-- Запрос 5: Cross-Selling аналитика: проникновение платных гарантий (Attachment Rate)
-- Бизнес-цель: Определяет процент заказов, к которым клиенты приобрели
--              дополнительную гарантию, и суммарный доход от сервисных услуг.
-- ----------------------------------------------------------------------------
SELECT
    COUNT(o.id_order) AS total_orders,
    SUM(CASE WHEN o.id_guarantee IS NOT NULL THEN 1 ELSE 0 END) AS orders_with_warranty,
    ROUND(
        (SUM(CASE WHEN o.id_guarantee IS NOT NULL THEN 1.0 ELSE 0.0 END) / COUNT(o.id_order)) * 100.0,
        2
    ) AS warranty_attachment_rate_pct,
    COALESCE(SUM(g.price), 0.00) AS total_warranty_service_revenue
FROM "order" o
LEFT JOIN guarantee g ON o.id_guarantee = g.id_guarantee;
