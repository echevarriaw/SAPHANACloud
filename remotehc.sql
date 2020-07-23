-- setup data
CREATE SCHEMA MYDATA;
SET SCHEMA MYDATA;

CREATE COLUMN TABLE SALES (
    ID INTEGER NOT NULL,
    REGION NVARCHAR(100),
    COUNTRY NVARCHAR(100),
    AMOUNT INTEGER,
    PRIMARY KEY (ID)
);

INSERT INTO SALES VALUES (1, 'Europe', 'France', 123);
INSERT INTO SALES VALUES (2, 'Europe', 'UK', 323);
INSERT INTO SALES VALUES (3, 'Europe', 'Germany', 413);
INSERT INTO SALES VALUES (4, 'Europe', 'Italy', 143);
INSERT INTO SALES VALUES (5, 'Europe', 'Finland', 521);
INSERT INTO SALES VALUES (6, 'Europe', 'Ireland', 253);
INSERT INTO SALES VALUES (7, 'Europe', 'Spain', 273);
INSERT INTO SALES VALUES (8, 'Europe', 'Portugal', 190);
INSERT INTO SALES VALUES (9, 'North America', 'USA', 763);
INSERT INTO SALES VALUES (10, 'North America', 'Mexico', 465);
INSERT INTO SALES VALUES (11, 'North America', 'Canada', 349);
INSERT INTO SALES VALUES (12, 'Asia', 'Japan', 732);
INSERT INTO SALES VALUES (13, 'Asia', 'Malaysia', 233);
INSERT INTO SALES VALUES (14, 'Asia', 'China', 821);
INSERT INTO SALES VALUES (15, 'Asia', 'India', 692);

SELECT * FROM SALES;

-- technical user
CREATE USER MYUSER PASSWORD <password> NO FORCE_FIRST_PASSWORD_CHANGE;
GRANT SELECT ON SCHEMA MYDATA TO MYUSER;

-- download root certificate 
-- https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem

-- create remote source
CREATE REMOTE SOURCE "hana1" ADAPTER hanaodbc 
 CONFIGURATION 'Driver=libodbcHDB.so;ServerNode=<endpoint>;dml_mode=readonly;encrypt=true;'
 WITH CREDENTIAL TYPE 'PASSWORD' USING 'user=<user>;password=<password>'
 ;

CREATE SCHEMA MYDATA;

-- virtual table
CREATE VIRTUAL TABLE MYDATA."v_SALES" AT "hana1"."<null>"."MYDATA"."SALES";

-- linked database (generated objects are stored in _SYS_LDB schema)
SELECT * FROM "hana1"."MYDATA"."SALES";

-- synonym
CREATE SYNONYM MYDATA."s_SALES" FOR "hana1"."MYDATA"."SALES";

-- refresh linked database
ALTER REMOTE SOURCE "hana1" REFRESH LINKED OBJECTS;

-- delete linked database
ALTER REMOTE SOURCE "hana1" DROP LINKED OBJECTS CASCADE;

-- useful system views
SELECT * FROM M_REMOTE_STATEMENTS;
SELECT * FROM M_EXPENSIVE_STATEMENTS;

-- replica table
ALTER VIRTUAL TABLE MYDATA."v_SALES" ADD SHARED SNAPSHOT REPLICA;

UPDATE SALES SET AMOUNT=900 WHERE COUNTRY='India';

-- refresh replica table
ALTER VIRTUAL TABLE MYDATA."v_SALES" REFRESH SNAPSHOT REPLICA;

-- useful system views
SELECT * FROM M_VIRTUAL_TABLE_REPLICAS;
SELECT * FROM VIRTUAL_TABLE_REPLICAS;

-- delete replica table
ALTER VIRTUAL TABLE MYDATA."v_SALES" DROP REPLICA;

-- delete remote source
DROP REMOTE SOURCE "hana1" CASCADE;
