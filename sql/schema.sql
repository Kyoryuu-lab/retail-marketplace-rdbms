-- ============================================================================
-- Project:     Retail Marketplace RDBMS
-- File:        sql/schema.sql
-- Description: DDL schema definition for smartphone retail and order management.
-- ============================================================================

CREATE TABLE IF NOT EXISTS firm (
    id_firm INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(45) NOT NULL,
    producing_country VARCHAR(45) NOT NULL
);

CREATE TABLE IF NOT EXISTS provider (
    id_provider INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(45) NOT NULL,
    address VARCHAR(150) NOT NULL,
    phone_number VARCHAR(45) NOT NULL,
    fax VARCHAR(45) NOT NULL
);

CREATE TABLE IF NOT EXISTS phone (
    id_phone INTEGER PRIMARY KEY AUTOINCREMENT,
    id_firm INTEGER NOT NULL,
    model VARCHAR(45) NOT NULL,
    colour VARCHAR(45) NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL,
    quantity INTEGER NOT NULL,
    id_provider INTEGER NOT NULL,
    purchase_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_firm) REFERENCES firm (id_firm) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_provider) REFERENCES provider (id_provider) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS employee (
    id_employee INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(45) NOT NULL,
    surname VARCHAR(45) NOT NULL,
    patronymic VARCHAR(45) NOT NULL,
    position VARCHAR(45) NOT NULL,
    address VARCHAR(150) NOT NULL,
    phone_number VARCHAR(45) NOT NULL
);

CREATE TABLE IF NOT EXISTS shopper (
    id_shopper INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(45) NOT NULL,
    surname VARCHAR(45) NOT NULL,
    patronymic VARCHAR(45) NOT NULL,
    phone_number VARCHAR(45) NOT NULL,
    address VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS discount (
    id_discount INTEGER PRIMARY KEY AUTOINCREMENT,
    percent INTEGER NOT NULL,
    discount_card INTEGER NOT NULL,
    id_shopper INTEGER NOT NULL,
    FOREIGN KEY (id_shopper) REFERENCES shopper (id_shopper) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS guarantee (
    id_guarantee INTEGER PRIMARY KEY AUTOINCREMENT,
    price DECIMAL(10,2) NOT NULL,
    validity DATETIME NOT NULL
);

CREATE TABLE IF NOT EXISTS "order" (
    id_order INTEGER PRIMARY KEY AUTOINCREMENT,
    id_phone INTEGER NOT NULL,
    id_discount INTEGER NULL,
    quantity INTEGER NOT NULL,
    id_guarantee INTEGER NULL,
    FOREIGN KEY (id_phone) REFERENCES phone (id_phone) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_discount) REFERENCES discount (id_discount) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_guarantee) REFERENCES guarantee (id_guarantee) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS market (
    id_market INTEGER PRIMARY KEY AUTOINCREMENT,
    country VARCHAR(45) NOT NULL,
    address VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS sales (
    id_sales INTEGER PRIMARY KEY AUTOINCREMENT,
    id_order INTEGER NOT NULL,
    id_employee INTEGER NOT NULL,
    id_market INTEGER NOT NULL,
    FOREIGN KEY (id_order) REFERENCES "order" (id_order) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_employee) REFERENCES employee (id_employee) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_market) REFERENCES market (id_market) ON DELETE CASCADE ON UPDATE CASCADE
);
