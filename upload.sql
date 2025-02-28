
INSERT INTO Municipality (name, population, hasLibrary)
SELECT DISTINCT TOWN, POPULATION, HAS_LIBRARY
FROM fsdb.busstops;

INSERT INTO Library (CIF, name, foundationDate, municipality, address, email, phone)
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
SELECT DISTINCT NULL, NULL, NULL, NULL, NULL, CONT_START, CONT_END, 'Not on route' -- Missing driver data, cannot be imported
FROM fsdb.busstops;

INSERT INTO Book (title, mainAuthor, country, originalLanguage, alternativeTitle, otherAuthors, subject, contentNotes, awards)
SELECT DISTINCT TITLE, MAIN_AUTHOR, PUB_COUNTRY, ORIGINAL_LANGUAGE, ALT_TITLE, OTHER_AUTHORS, TOPIC, CONTENT_NOTES, AWARDS
FROM fsdb.acervus;

INSERT INTO Edition (ISBN, bookID, publicationDate, mainLanguage, otherLanguages, edition, publisher, length, series, legalDeposit, publicationPlace, dimensions, physicalFeatures, ancillaryMaterial, notes, URL)
SELECT DISTINCT ISBN, (SELECT bookID FROM Book WHERE title = fsdb.acervus.TITLE AND mainAuthor = fsdb.acervus.MAIN_AUTHOR), PUB_DATE, MAIN_LANGUAGE, OTHER_LANGUAGES, EDITION, PUBLISHER, EXTENSION, SERIES, COPYRIGHT, PUB_PLACE, DIMENSIONS, PHYSICAL_FEATURES, ATTACHED_MATERIALS, NOTES, URL
FROM fsdb.acervus;

INSERT INTO Copy (signature, ISBN, condition, comments, deregisteredDate)
SELECT DISTINCT SIGNATURE, ISBN, 'Good', NULL, NULL
FROM fsdb.acervus;

INSERT INTO User (passport, name, surname1, surname2, birthDate, municipality, address, email, phone)
SELECT DISTINCT PASSPORT, NAME, SURNAME1, SURNAME2, BIRTHDATE, TOWN, ADDRESS, EMAIL, PHONE
FROM fsdb.loans;

INSERT INTO Loan (signature, passport, loanDate, returnDate)
SELECT DISTINCT SIGNATURE, PASSPORT, DATE_TIME, RETURN
FROM fsdb.loans;

INSERT INTO Reservation (signature, passport, assignmentID, reservationDate)
SELECT DISTINCT SIGNATURE, PASSPORT, (SELECT assignmentID FROM Assignment WHERE stopDate = fsdb.busstops.STOPDATE AND plate = fsdb.busstops.PLATE AND routeID = fsdb.busstops.ROUTE_ID), NULL -- Reservation date missing in source data
FROM fsdb.loans;

INSERT INTO Comment (passport, bookID, date, text, likes, dislikes)
SELECT DISTINCT PASSPORT, (SELECT bookID FROM Book WHERE title = fsdb.acervus.TITLE AND mainAuthor = fsdb.acervus.MAIN_AUTHOR), POST_DATE, POST, LIKES, DISLIKES
FROM fsdb.loans;
