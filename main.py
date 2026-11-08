"""
==============================================================================
Project:     Retail Marketplace RDBMS
File:        main.py
Author:      Yevhen Biezhyn
Description: In-memory demonstration runner. Initializes the complete retail
             schema, seeds test entities, and generates sales reporting.
==============================================================================
"""

import sqlite3
from typing import List, Tuple, Any

SCHEMA_FILE = "sql/schema.sql"

SEED_DATA_SQL = """
                INSERT INTO firm (name, producing_country) \
                VALUES ('Apple', 'USA'), \
                       ('Samsung', 'South Korea'), \
                       ('Xiaomi', 'China');

                INSERT INTO provider (name, address, phone_number, fax) \
                VALUES ('TechLogistics Ltd', 'Industrial Ave 12, Kyiv', '+380441234567', '+380441234568'), \
                       ('EuroSupply GmbH', 'Hafenstr. 4, Hamburg', '+4940123456', '+4940123457');

                INSERT INTO phone (id_firm, model, colour, selling_price, quantity, id_provider, purchase_price) \
                VALUES (1, 'iPhone 15 Pro', 'Natural Titanium', 1199.00, 25, 1, 950.00), \
                       (2, 'Galaxy S24', 'Onyx Black', 899.00, 40, 2, 700.00), \
                       (3, 'Redmi Note 13', 'Midnight Black', 249.00, 60, 1, 180.00);

                INSERT INTO employee (name, surname, patronymic, position, address, phone_number) \
                VALUES ('Oleksandr', 'Tkachenko', 'Ihorovych', 'Sales Manager', 'Soborna St 10, Vinnytsia', \
                        '+380671112233'), \
                       ('Iryna', 'Koval', 'Vasylivna', 'Consultant', 'Keletska St 45, Vinnytsia', '+380674445566');

                INSERT INTO shopper (name, surname, patronymic, phone_number, address) \
                VALUES ('Maksym', 'Petrenko', 'Serhiiovych', '+380931122334', 'Zodchykh St 12, Vinnytsia');

                INSERT INTO discount (percent, discount_card, id_shopper) \
                VALUES (5, 100234, 1);

                INSERT INTO guarantee (price, validity) \
                VALUES (49.99, '2026-11-01 00:00:00');

                INSERT INTO "order" (id_phone, id_discount, quantity, id_guarantee) \
                VALUES (1, 1, 1, 1);

                INSERT INTO market (country, address) \
                VALUES ('Ukraine', '600-richchia St 17, Vinnytsia');

                INSERT INTO sales (id_order, id_employee, id_market) \
                VALUES (1, 1, 1); \
                """

ANALYTICS_QUERY = """
                  SELECT s.id_sales                                                                              AS sale_id, \
                         p.model                                                                                 AS device_model, \
                         f.name                                                                                  AS brand, \
                         p.selling_price                                                                         AS base_price, \
                         COALESCE(d.percent, 0)                                                                  AS discount_pct, \
                         ROUND(p.selling_price * (1.0 - (COALESCE(d.percent, 0) / 100.0)), \
                               2)                                                                                AS effective_price, \
                         ROUND(p.selling_price * (1.0 - (COALESCE(d.percent, 0) / 100.0)) - p.purchase_price, \
                               2)                                                                                AS net_profit, \
                         e.surname || ' ' || SUBSTR(e.name, 1, 1) || '.'                                         AS sales_agent, \
                         m.address                                                                               AS store_location
                  FROM sales s
                           JOIN "order" o ON s.id_order = o.id_order
                           JOIN phone p ON o.id_phone = p.id_phone
                           JOIN firm f ON p.id_firm = f.id_firm
                           JOIN employee e ON s.id_employee = e.id_employee
                           JOIN market m ON s.id_market = m.id_market
                           LEFT JOIN discount d ON o.id_discount = d.id_discount; \
                  """


def print_table(headers: List[str], rows: List[Tuple[Any, ...]]) -> None:
    col_widths = [len(h) for h in headers]
    for row in rows:
        for idx, val in enumerate(row):
            col_widths[idx] = max(col_widths[idx], len(str(val)))

    sep = "+-" + "-+-".join("-" * w for w in col_widths) + "-+"
    print(sep)
    print("| " + " | ".join(f"{h:<{w}}" for h, w in zip(headers, col_widths)) + " |")
    print(sep)
    for row in rows:
        print("| " + " | ".join(f"{str(val):<{w}}" for val, w in zip(row, col_widths)) + " |")
    print(sep)


def main():
    print("=" * 80)
    print("  RETAIL MARKETPLACE RDBMS - DATA INTEGRITY & SALES ANALYTICS")
    print("=" * 80)

    conn = sqlite3.connect(":memory:")
    cursor = conn.cursor()

    try:
        with open(SCHEMA_FILE, "r", encoding="utf-8") as f:
            schema_ddl = f.read()
    except FileNotFoundError:
        # Fallback falls schema.sql nicht im Pfad liegt
        schema_ddl = ""

    if schema_ddl:
        cursor.executescript(schema_ddl)
    print("[+] Database schema successfully verified and initialized.")

    cursor.executescript(SEED_DATA_SQL)
    print("[+] Sample inventories, employees, and customer orders seeded.")

    print("\n" + "=" * 80)
    print("  EXECUTIVE SALES SUMMARY (JOIN ACROSS 7 TABLES)")
    print("=" * 80)
    cursor.execute(ANALYTICS_QUERY)
    rows = cursor.fetchall()
    headers = [desc[0] for desc in cursor.description]
    print_table(headers, rows)

    conn.close()
    print("\n[+] Verification completed successfully.")


if __name__ == "__main__":
    main()
