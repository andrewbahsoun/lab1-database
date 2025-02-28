
INSERT INTO Municipality (name, population, hasLibrary)
SELECT DISTINCT TOWN, POPULATION, HAS_LIBRARY
FROM fsdb.busstops;

INSERT INTO Library(CIF, name, foundationDate, municipality, address, email, phone)
SELECT DISTINCT LIB_PASSPORT, LIB_FULLNAME, LIB_BIRTHDATE, TOWN, LIB_ADDRESS, LIB_EMAIL, LIB_PHONE
FROM fsdb.busstops;


INSERT INTO Bibus (plate, status)
SELECT DISTINCT PLATE, 'Available'
FROM fsdb.busstops;

INSERT INTO RouteStop (routeID, municipality, stopTime)
SELECT DISTINCT ROUTE_ID, TOWN, STOPTIME
FROM fsdb.busstops;

INSERT INTO Assignment (stopDate, plate, routeID, driverPassport)
SELECT DISTINCT STOPDATE, PLATE, ROUTE_ID, NULL -- Missing driver data, cannot be imported
FROM fsdb.busstops;

INSERT INTO Driver (passport, name, surname, phone, email, contractStart, contractEnd, status)
SELECT DISTINCT 
    NVL(LIB_PASSPORT, 'UNKNOWN_' || ROWNUM), -- Generate unique placeholders because driver data is missing
    NVL(LIB_FULLNAME, 'Unknown'),
    NULL, NULL, NULL, CONT_START, CONT_END, 'Not on route'
FROM fsdb.busstops;


MERGE INTO Book b
USING (
    SELECT DISTINCT TITLE, MAIN_AUTHOR, PUB_COUNTRY, ORIGINAL_LANGUAGE, ALT_TITLE, OTHER_AUTHORS, TOPIC, CONTENT_NOTES, AWARDS 
    FROM fsdb.acervus
) a
ON (b.title = a.TITLE AND b.mainAuthor = a.MAIN_AUTHOR)  -- Match existing books
WHEN NOT MATCHED THEN
INSERT (title, mainAuthor, country, originalLanguage, alternativeTitle, otherAuthors, subject, contentNotes, awards)
VALUES (a.TITLE, a.MAIN_AUTHOR, a.PUB_COUNTRY, a.ORIGINAL_LANGUAGE, a.ALT_TITLE, a.OTHER_AUTHORS, a.TOPIC, a.CONTENT_NOTES, a.AWARDS);


INSERT INTO Edition (ISBN, bookID, publicationDate, mainLanguage, otherLanguages, edition, publisher, length, series, legalDeposit, publicationPlace, dimensions, physicalFeatures, ancillaryMaterial, notes, URL)
SELECT DISTINCT 
    ISBN,
    (SELECT MIN(b.bookID) FROM Book b WHERE b.title = a.TITLE AND b.mainAuthor = a.MAIN_AUTHOR),
    PUB_DATE, MAIN_LANGUAGE, OTHER_LANGUAGES, EDITION, PUBLISHER, EXTENSION, SERIES, COPYRIGHT,
    PUB_PLACE, DIMENSIONS, PHYSICAL_FEATURES, ATTACHED_MATERIALS, NOTES, URL
FROM fsdb.acervus a;

INSERT INTO Copy (signature, ISBN, condition, comments, deregisteredDate)
SELECT DISTINCT SIGNATURE, ISBN, 'good', NULL, NULL
FROM fsdb.acervus
WHERE ISBN IN (SELECT ISBN FROM Edition);  -- Ensure valid ISBN reference


INSERT INTO Municipality (name, population, hasLibrary) -- Inserting missing municipalities (without a library but with users from these municipalities)
SELECT DISTINCT TOWN, NULL, '0'
FROM fsdb.loans 
WHERE TOWN NOT IN (SELECT name FROM Municipality);

INSERT INTO Users (passport, name, surname1, surname2, birthDate, municipality, address, email, phone)
SELECT DISTINCT PASSPORT, NAME, SURNAME1, SURNAME2, BIRTHDATE, TOWN, ADDRESS, EMAIL, PHONE
FROM fsdb.loans
WHERE TOWN IN (SELECT name FROM Municipality)
AND PASSPORT NOT IN (SELECT passport FROM Users);


INSERT INTO Loan (signature, passport, loanDate, returnDate)
SELECT DISTINCT SIGNATURE, PASSPORT, DATE_TIME, RETURN
FROM fsdb.loans
WHERE PASSPORT IN (SELECT passport FROM Users);


INSERT INTO Reservation (signature, passport, assignmentID, reservationDate)
SELECT DISTINCT
    l.SIGNATURE,
    l.PASSPORT,
    (SELECT a.assignmentID
     FROM Assignment a
     WHERE a.stopDate = b.STOPDATE
     AND a.plate = b.PLATE
     AND a.routeID = b.ROUTE_ID),
    NULL  -- Reservation date missing in source data
FROM fsdb.loans l
JOIN fsdb.busstops b ON l.TOWN = b.TOWN;  -- Ensures correct route matching



INSERT INTO Comments (passport, bookID, postDate, postText, likes, dislikes)
SELECT DISTINCT l.PASSPORT,
    (SELECT MIN(b.bookID) FROM Book b WHERE b.title = a.TITLE AND b.mainAuthor = a.MAIN_AUTHOR),
    l.POST_DATE, l.POST, l.LIKES, l.DISLIKES
FROM fsdb.loans l
JOIN fsdb.acervus a ON l.SIGNATURE = a.SIGNATURE
WHERE EXISTS (
    SELECT 1 FROM Loan lo
    WHERE lo.passport = l.PASSPORT 
    AND lo.signature IN (SELECT c.signature FROM Copy c WHERE c.ISBN = a.ISBN)
);

