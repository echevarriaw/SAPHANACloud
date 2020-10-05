CREATE SCHEMA travel;

CREATE COLUMN TABLE travel."Customers" (
  id INTEGER,
  name VARCHAR(30) NOT NULL,
  "City" NVARCHAR(100),
  gender CHAR(6),
  number_of_trips SMALLINT,
  loyalty_member BOOLEAN DEFAULT false,
  balance NUMERIC(6,2),
  PRIMARY KEY (id)
  )
 ;

INSERT INTO travel."Customers" VALUES (1, 'Jamie',  'Vancouver',     'Male',   8, false, 12.31);
INSERT INTO travel."Customers" VALUES (2, 'Julie',  'Portland',      'Female', 6, true,  23.23);
INSERT INTO travel."Customers" VALUES (3, 'Bob',    'New York',      'Male',   9, false, 34.15);
INSERT INTO travel."Customers" VALUES (4, 'Denys',  'Den Bosch',     'Male',   4, true,  45.99);
INSERT INTO travel."Customers" VALUES (5, 'Philip', 'Nantes',        'Male',   5, false, 56.84);
INSERT INTO travel."Customers" VALUES (6, 'Joe',    'San Francisco', 'Male',   7, true,  67.43);

SELECT * FROM travel."Customers";

CREATE VIEW travel.LOYAL_CUSTOMERS AS
  SELECT id, name, "City", number_of_trips as trips, balance
    FROM travel."Customers"
    WHERE loyalty_member = true
  ;

SELECT * FROM travel.LOYAL_CUSTOMERS
  ORDER BY balance DESC;
