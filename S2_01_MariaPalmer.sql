-- SPRINT 2 - NIVELL 1
-- S2.N1.01 A partir dels documents adjunts (estructura_dades i dades_introduir), importa les dues taules. 
-- Mostra les característiques principals de l'esquema creat i explica les diferents taules i variables que existeixen. 
-- Assegura't d'incloure un diagrama que il·lustri la relació entre les diferents taules i variables.
    -- Creamos la base de datos
    CREATE DATABASE IF NOT EXISTS transactions;
    USE transactions;

    -- Creamos la tabla company
    CREATE TABLE IF NOT EXISTS company (
        id VARCHAR(15) PRIMARY KEY,
        company_name VARCHAR(255),
        phone VARCHAR(15),
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255)
    );

    -- Creamos la tabla transaction
    CREATE TABLE IF NOT EXISTS transaction (
        id VARCHAR(255) PRIMARY KEY,
        credit_card_id VARCHAR(15),
        company_id VARCHAR(20), 
        user_id INT,
        lat FLOAT,
        longitude FLOAT,
        timestamp TIMESTAMP,
        amount DECIMAL(10, 2),
        declined BOOLEAN,
        FOREIGN KEY (company_id) REFERENCES company(id) 
    );
-- S2.N1.02 Utilitzant `JOIN` realitzaràs les següents consultes:
-- Llistat dels països que estan generant vendes.

SELECT country AS countries_selling
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id
WHERE t.company_id IS NOT null AND c.country IS NOT null AND t.declined = 0
GROUP BY country;

-- Des de quants països es generen les vendes.
SELECT COUNT(DISTINCT country) AS total_countries_selling
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id
WHERE t.company_id IS NOT null AND c.country IS NOT null AND t.declined = 0;

-- Identifica la companyia amb la mitjana més gran de vendes.
SELECT company_name, ROUND(AVG(amount), 2) AS top_ventas
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id
WHERE declined = 0
GROUP BY company_name
ORDER BY 2 DESC
LIMIT 1;

-- S2.N1.03 Utilitzant només subconsultes (sense utilitzar `JOIN`):
-- Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT *
FROM transaction
WHERE company_id IN (
SELECT id
FROM company
WHERE country = "Germany") AND declined = 0;

-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT company_id, (SELECT company_name
					FROM company c
					WHERE t.company_id = c.id) AS nombre_empresa  
FROM transaction t
WHERE amount > (SELECT AVG(amount)
FROM transaction) AND declined = 0
GROUP BY company_id;


-- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

SELECT id, company_name AS empresa_sin_transacciones
FROM company
WHERE id NOT IN (SELECT company_id
FROM transaction
WHERE company_id IS NOT NULL);

-- S2.N1.04 La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. 
-- La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" 
-- i "company"). Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". 
-- Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.

DROP TABLE IF EXISTS credit_card;

CREATE TABLE IF NOT EXISTS credit_card (
        id VARCHAR(15) PRIMARY KEY,
        IBAN VARCHAR(35),
        pan VARCHAR(20), 
        pin VARCHAR(4),
        cvv VARCHAR(3),
        expiring_date VARCHAR(10)
        );
        
ALTER TABLE transaction
  ADD CONSTRAINT fk_transaction_credit_card
  FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);
  
-- S02.N1.05 El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit amb ID CcU-2938. 
-- La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. Recorda mostrar que el canvi es va realitzar.

UPDATE credit_card
SET IBAN = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

SELECT * 
FROM credit_card
WHERE id = "CcU-2938";

-- S02.N1.06 En la taula "transaction" ingressa una nova transacció amb la següent informació:

INSERT INTO company (id, company_name) 
VALUES ('b-9999', 'Pendiente de alta');

INSERT INTO credit_card (id, iban) 
VALUES ('CcU-9999', 'PENDIENTE');

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, 111.11, 0);

SELECT *
FROM transaction t
WHERE t.company_id = 'b-9999';

-- S02.N1.07 Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.

ALTER TABLE credit_card
DROP COLUMN pan;

SELECT *
FROM credit_card
LIMIT 1;

-- S2.N1.08 Estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, 
 -- almenys 4 taules de les quals puguis realitzar les següents consultes:
 
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;
    
CREATE TABLE IF NOT EXISTS users_csv (
    id VARCHAR(255) PRIMARY KEY,
    user_name VARCHAR(255) NULL,
    surname VARCHAR(255) NULL,
    phone VARCHAR(255) NULL,
    email VARCHAR (255) NULL,
    birth_date VARCHAR(255) NULL,
    country VARCHAR(255) NULL,
    city VARCHAR(255) NULL,
    postal_code VARCHAR (15) NULL,
    address VARCHAR (255) NULL,
    signup_date VARCHAR(15) NULL,
    user_segment VARCHAR(25) NULL,
    income_band VARCHAR(15) NULL
);

SET GLOBAL local_infile = 1;

LOAD DATA
LOCAL INFILE '/Users/laurea/Desktop/CURSO_FADD/1_Especialització/1.3_Sprints/Sprint_2/BBDD/N1-Ex.8__american_users.csv'
INTO TABLE users_csv 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

LOAD DATA
LOCAL INFILE '/Users/laurea/Desktop/CURSO_FADD/1_Especialització/1.3_Sprints/Sprint_2/BBDD/N1-Ex.8__european_users.csv'
INTO TABLE users_csv 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;


CREATE TABLE IF NOT EXISTS companies_csv (
    id VARCHAR(255) PRIMARY KEY,
    company_name VARCHAR(255) NULL,
    phone VARCHAR(30) NULL,
    email VARCHAR (255) NULL,
    country VARCHAR(50) NULL,
    website VARCHAR(255) NULL,
    merchant_category VARCHAR (30) NULL,
    merchant_price_position VARCHAR(30) NULL
);

LOAD DATA
LOCAL INFILE '/Users/laurea/Desktop/CURSO_FADD/1_Especialització/1.3_Sprints/Sprint_2/BBDD/N1-Ex.8__companies.csv'
INTO TABLE companies_csv 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS credit_cards_csv (
    id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255) NULL,
    iban VARCHAR(255) NULL,
    pan VARCHAR (255) NULL,
    pin VARCHAR(255) NULL,
    cvv VARCHAR(255) NULL,
    track1 VARCHAR (255) NULL,
    track2 VARCHAR(255) NULL,
    expiring_date VARCHAR(255) NULL,
    card_type VARCHAR(255) NULL,
    card_renewal_flag VARCHAR (255) NULL
);

LOAD DATA
LOCAL INFILE '/Users/laurea/Desktop/CURSO_FADD/1_Especialització/1.3_Sprints/Sprint_2/BBDD/N1-Ex.8__credit_cards.csv'
INTO TABLE credit_cards_csv 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS transactions_csv (
    id VARCHAR(255) PRIMARY KEY,
    card_id VARCHAR(255) NULL,
    business_id VARCHAR(255) NULL,
    timestamp VARCHAR(255) NULL,
    amount VARCHAR (255) NULL,
    declined VARCHAR(255) NULL,
    product_ids VARCHAR(255) NULL,
    user_id VARCHAR(255) NULL,
    lat VARCHAR (255) NULL,
    longitude VARCHAR(255) NULL,
    discount_amount VARCHAR(255) NULL,
    tax_amount VARCHAR(255) NULL,
    shipping_amount VARCHAR(255) NULL,
    channel VARCHAR(255) NULL,
    campaign_id VARCHAR(255) NULL,
    device_type VARCHAR (255) NULL,
    is_international VARCHAR(255) NULL,
    decline_reason VARCHAR(255) NULL,
    distance_km VARCHAR(255) NULL
);

LOAD DATA
LOCAL INFILE '/Users/laurea/Desktop/CURSO_FADD/1_Especialització/1.3_Sprints/Sprint_2/BBDD/N1-Ex.8__transactions.csv'
INTO TABLE transactions_csv 
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
IGNORE 1 ROWS;

-- ¿Transacciones con tarjeta que no existe en credit_cards_csv?
SELECT COUNT(*) 
FROM transactions_csv t
LEFT JOIN credit_cards_csv cc 
ON t.card_id = cc.id
WHERE cc.id IS NULL;

-- ¿Transacciones con tarjeta que no existe en companies_csv?
SELECT COUNT(*) 
FROM transactions_csv t
LEFT JOIN companies_csv c 
ON t.business_id = c.id
WHERE c.id IS NULL;

-- ¿Transacciones con tarjeta que no existe en users_csv?
SELECT COUNT(*) 
FROM transactions_csv t
LEFT JOIN users_csv u 
ON t.user_id = u.id
WHERE u.id IS NULL;

ALTER TABLE transactions_csv
  ADD CONSTRAINT fk_transactions_credit_cards
  FOREIGN KEY (card_id) REFERENCES credit_cards_csv(id);

ALTER TABLE transactions_csv
  ADD CONSTRAINT fk_transactions_companies
  FOREIGN KEY (business_id) REFERENCES companies_csv(id);
  
ALTER TABLE transactions_csv
  ADD CONSTRAINT fk_transactions_users
  FOREIGN KEY (user_id) REFERENCES users_csv(id);
  
-- S2.N1.09 Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.

SELECT user_id, (SELECT user_name
				FROM users_csv u
				WHERE t.user_id = u.id) AS name, COUNT(id) AS total_transactions
FROM transactions_csv t
WHERE declined = 0
GROUP BY 1
HAVING COUNT(id) > 80;

-- S2.N1.10 Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.
SELECT iban, ROUND(AVG(amount), 2) AS avg_amount, company_name
FROM transactions_csv t
JOIN companies_csv c
ON t.business_id = c.id
JOIN credit_cards_csv cc
ON t.card_id = cc.id
WHERE c.company_name = 'Donec Ltd' AND declined = 0
GROUP BY 1;

-- ---------------------------------

-- SPRINT 2 - NIVELL 2
-- S2.N2.01 Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
-- Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT DATE(timestamp) AS fecha, ROUND(SUM(amount),2) AS top_amount
FROM transactions_csv
WHERE declined = 0
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- S2.N2.02 Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb 
-- un valor comprès entre 350 i 400 euros i en alguna d'aquestes dates: 29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. 
-- Ordena els resultats de major a menor quantitat.

SELECT company_name, phone, country, DATE(timestamp) AS date, amount
FROM companies_csv c
JOIN transactions_csv t
ON c.id = t.business_id
WHERE amount BETWEEN 350 AND 400 AND declined = 0
AND DATE(timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
ORDER BY amount DESC;

-- S2.N2.03 Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
-- per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
-- però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen igual o més de 400 transaccions o menys.

SELECT c.id, company_name, COUNT(t.id) AS num_transactions,
CASE
  WHEN COUNT(t.id) >= 400 THEN '400 or more'
  ELSE 'Less than 400'
END AS 'Transactions'
FROM companies_csv c
LEFT JOIN transactions_csv t
ON c.id = t.business_id
GROUP BY 1
ORDER BY 3 ASC;


-- S2.N2.04 Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

DELETE
FROM transactions_csv
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';


-- S2.N2.05 La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
-- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
-- Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: 
-- Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
-- Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE OR REPLACE VIEW vista_marketing AS
SELECT company_name, phone, country, AVG(amount) AS compra_media
FROM companies_csv c
LEFT JOIN transactions_csv t
ON c.id = t.business_id
GROUP BY company_name
ORDER BY AVG(amount) DESC;

-- -------------------------------
-- SPRINT 2 - NIVELL 3
-- S2.N3.01 Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les tres últimes transaccions han estat 
-- declinades aleshores és inactiu, si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon:

DROP TABLE IF EXISTS credit_card_status;

CREATE TABLE credit_card_status AS
SELECT card_id, SUM(declined) AS card_declined,
CASE
  WHEN SUM(declined) = 3 THEN 'Inactive'
  ELSE 'Active'
END AS 'card_status'
FROM (SELECT card_id, declined, timestamp AS fecha,
		ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS ranking1
		FROM transactions_csv t) AS window_cards
WHERE window_cards.ranking1 IN (1, 2, 3)
GROUP BY card_id;

-- Quantes targetes estan actives?
SELECT card_status, COUNT(card_status) AS total
FROM credit_card_status
GROUP BY card_status;
-- Estan actives 5000 tarjetes (totes les de la taula).

-- S2.N3.02 Crea una taula amb la qual puguem unir les dades de l'arxiu de products.csv amb la base de dades creada 
-- (ja que fins ara no podíem fer-ho), tenint en compte que des de transaction tens product_ids. Genera la següent consulta:

DROP TABLE IF EXISTS products_csv;

CREATE TABLE IF NOT EXISTS products_csv (
    id VARCHAR(255) PRIMARY KEY,
    product_name VARCHAR(255) NULL,
    price VARCHAR(255) NULL,
    colour VARCHAR(255) NULL,
    weight VARCHAR (255) NULL,
    warehouse_id VARCHAR(255) NULL,
    category VARCHAR(255) NULL,
    brand VARCHAR(255) NULL,
    cost VARCHAR (15) NULL,
    launch_date VARCHAR (255) NULL
);

LOAD DATA
LOCAL INFILE '/Users/laurea/Desktop/CURSO_FADD/1_Especialització/1.3_Sprints/Sprint_2/BBDD/N1-Ex.8__products.csv'
INTO TABLE products_csv 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

SELECT FIND_IN_SET('87', REPLACE('16, 26, 97, 87', ' ', ''));

DROP TABLE IF EXISTS transactions_products;

CREATE TABLE transactions_products AS
SELECT t.id AS transaction_id,
       p.id AS product_id
FROM transactions_csv t
JOIN products_csv p
  ON FIND_IN_SET(p.id, REPLACE(t.product_ids, ' ', '')) > 0;


--  Necessitem conèixer el nombre de vegades que s'ha venut cada producte.

SELECT pr.id,
       pr.product_name,
       COUNT(tp.product_id) AS purchase_amount
FROM products_csv pr
LEFT JOIN transactions_products tp
       ON tp.product_id = pr.id
GROUP BY pr.id, pr.product_name
ORDER BY purchase_amount DESC;

