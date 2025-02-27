INSERT INTO Municipality(name, population, hasLibrary)
SELECT TOWN, POPULATION, HAS_LIBRARY FROM fsdb.busstops;

INSERT INTO Library(CIF, name, foundationDate, municipality, address, email, phone)
SELECT LIB_PASSPORT, LIB_FULLNAME, LIB_BIRTHDATE, TOWN, LIB_ADDRESS, LIB_EMAIL, LIB_PHONE
FROM fsdb.busstops;

INSERT INTO Bibus(plate,status)
SELECT PLATE, ; /* Need to create a new data for status */ 

