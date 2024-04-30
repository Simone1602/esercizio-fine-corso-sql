create database toysgroup;
use toysgroup;

CREATE TABLE Product (
    ID_prodotto INT PRIMARY KEY,
    Nome_prodotto VARCHAR(50));

CREATE TABLE Regioni (
    ID_regione INT PRIMARY KEY,
    Nome_regione VARCHAR(50));

CREATE TABLE Sales (
    ID_vendita INT PRIMARY KEY,
    ID_prodotto INT,
    ID_regione INT,
    Data DATE,
    Importo DECIMAL(10, 2),
    FOREIGN KEY (ID_prodotto) REFERENCES Product(ID_prodotto),
    FOREIGN KEY (ID_regione) REFERENCES Regioni(ID_regione)
);



INSERT INTO Product (ID_prodotto, Nome_prodotto) VALUES
(1, 'giorchi ps5 1 '),
(2, 'macchinine 2'),
(3, 'gormiti 3');

INSERT INTO Regioni (ID_regione, Nome_regione) VALUES
(1, 'Lazio'),
(2, 'Piemonte');

INSERT INTO Sales (ID_vendita, ID_prodotto, ID_regione, Data, Importo) VALUES
(1, 1, 1, '2024-01-01', 21.50),
(2, 2, 1, '2024-02-15', 16.75),
(3, 3, 2, '2024-03-10', 22.00),
(4, 1, 2, '2024-04-20', 28.20),
(5, 2, 2, '2024-04-25', 19.90);

--verifico che i campi definiti come pk siano univoci

SELECT COUNT(*) AS Numero_duplicati
FROM (
    SELECT ID_prodotto, COUNT(*) AS Num_occorrenze
    FROM Product
    GROUP BY ID_prodotto
    HAVING COUNT(*) > 1
) AS Duplicati;


--elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno:

SELECT p.Nome_prodotto, YEAR(s.Data) AS Anno, SUM(s.Importo) AS Fatturato_totale
FROM Product p
JOIN Sales s ON p.ID_prodotto = s.ID_prodotto
GROUP BY p.Nome_prodotto, YEAR(s.Data);


fatturato --totale per stato per anno. Ordina il risultato per data e per fatturato decrescente:


SELECT r.Nome_regione, YEAR(s.Data) AS Anno, SUM(s.Importo) AS Fatturato_totale
FROM Regioni r
JOIN Sales s ON r.ID_regione = s.ID_regione
GROUP BY r.Nome_regione, YEAR(s.Data)
ORDER BY YEAR(s.Data), SUM(s.Importo) DESC;


--categoria di articoli maggiormente richiesta dal mercato?


SELECT p.Nome_prodotto, COUNT(s.ID_vendita) AS Numero_transazioni
FROM Product p
JOIN Sales s ON p.ID_prodotto = s.ID_prodotto
GROUP BY p.Nome_prodotto
ORDER BY Numero_transazioni DESC
LIMIT 1;


--elenco dei prodotti la data di vendita più recente

SELECT p.Nome_prodotto, MAX(s.Data) AS Ultima_data_vendita
FROM Product p
LEFT JOIN Sales s ON p.ID_prodotto = s.ID_prodotto
GROUP BY p.Nome_prodotto;



--quali sono, se ci sono, i prodotti invenduti? Proponi due approcci differenti.

--approccio 1
SELECT p.*
FROM Product p
LEFT JOIN Sales s ON p.ID_prodotto = s.ID_prodotto
WHERE s.ID_vendita IS NULL;

--approccio 2 

SELECT *
FROM Product
WHERE ID_prodotto NOT IN (SELECT DISTINCT ID_prodotto FROM Sales);



