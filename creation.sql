DROP TABLE Municipality;
DROP TABLE Library;
DROP TABLE Bibus;
DROP TABLE RouteStop;
DROP TABLE Assignment;
DROP TABLE Driver;
DROP TABLE Book;
DROP TABLE Edition; 
DROP TABLE Copy;
DROP TABLE User;
DROP TABLE Loan; 
DROP TABLE Reservation;
DROP TABLE Comment; 


CREATE TABLE Municipality (
    name CHAR(50) PRIMARY KEY,
    population CHAR(8),
    hasLibrary CHAR(1)
);

CREATE TABLE Library (
    CIF CHAR(20) PRIMARY KEY,
    name CHAR(80),
    foundationDate CHAR(10),
    municipality CHAR(50),
    address CHAR(100),
    email CHAR(100),
    phone CHAR(9),
    FOREIGN KEY (municipality) REFERENCES Municipality(name) ON DELETE NO ACTION
);

CREATE TABLE Bibus (
    plate CHAR(8) PRIMARY KEY,
    status CHAR(50)
);

CREATE TABLE RouteStop (
    routeID CHAR(5),
    municipality CHAR(50),
    stopTime CHAR(8),
    PRIMARY KEY (routeID, municipality),
    FOREIGN KEY (municipality) REFERENCES Municipality(name) ON DELETE CASCADE
);

CREATE TABLE Assignment (
    assignmentID INT AUTO_INCREMENT PRIMARY KEY,
    stopDate CHAR(10),
    plate CHAR(8),
    routeID CHAR(5),
    driverPassport CHAR(20),
    FOREIGN KEY (plate) REFERENCES Bibus(plate) ON DELETE NO ACTION,
    FOREIGN KEY (routeID) REFERENCES RouteStop(routeID) ON DELETE NO ACTION,
    FOREIGN KEY (driverPassport) REFERENCES Driver(passport) ON DELETE NO ACTION
);

CREATE TABLE Driver (
    passport CHAR(20) PRIMARY KEY,
    name CHAR(80),
    surname CHAR(80),
    phone CHAR(80),
    email CHAR(100),
    contractStart CHAR(10),
    contractEnd CHAR(10),
    status CHAR(50)
);

CREATE TABLE Book (
    bookID INT AUTO_INCREMENT PRIMARY KEY,
    title CHAR(200),
    mainAuthor CHAR(100),
    country CHAR(50),
    originalLanguage CHAR(50),
    alternativeTitle CHAR(200),
    otherAuthors CHAR(200),
    subject CHAR(200),
    contentNotes VARCHAR2(2500),
    awards CHAR(200)
);

CREATE TABLE Edition (
    ISBN CHAR(20) PRIMARY KEY,
    bookID INT,
    publicationDate CHAR(12),
    mainLanguage CHAR(50),
    otherLanguages CHAR(50),
    edition CHAR(50),
    publisher CHAR(100),
    length INT,
    series CHAR(50),
    legalDeposit CHAR(20),
    publicationPlace CHAR(50),
    dimensions CHAR(50),
    physicalFeatures CHAR(200),
    ancillaryMaterial CHAR(200),
    notes CHAR(500),
    URL CHAR(200),
    FOREIGN KEY (bookID) REFERENCES Book(bookID) ON DELETE CASCADE
);

CREATE TABLE Copy (
    signature CHAR(20) PRIMARY KEY,
    ISBN CHAR(20),
    condition CHAR(50),
    comments CHAR(500),
    deregisteredDate CHAR(12),
    FOREIGN KEY (ISBN) REFERENCES Edition(ISBN) ON DELETE CASCADE
);
/*updated values*/
CREATE TABLE User (
    passport CHAR(20) PRIMARY KEY,
    name CHAR(80),
    surname1 CHAR(80),
    surname2 CHAR(80),
    birthDate CHAR(10),
    municipality CHAR(50),
    address CHAR(150),
    email CHAR(100),
    phone CHAR(9),
    FOREIGN KEY (municipality) REFERENCES Municipality(name) ON DELETE NO ACTION
);
/**/
CREATE TABLE Loan (
    signature CHAR(20),
    passport CHAR(20),
    loanDate CHAR(22),
    returnDate CHAR(22),
    PRIMARY KEY (signature, passport),
    FOREIGN KEY (signature) REFERENCES Copy(signature) ON DELETE CASCADE,
    FOREIGN KEY (passport) REFERENCES User(passport) ON DELETE CASCADE
);

CREATE TABLE Reservation (
    signature CHAR(20),
    passport CHAR(20),
    assignmentID INT,
    reservationDate CHAR(22),
    PRIMARY KEY (signature, passport, assignmentID),
    FOREIGN KEY (signature) REFERENCES Copy(signature) ON DELETE CASCADE,
    FOREIGN KEY (passport) REFERENCES User(passport) ON DELETE CASCADE,
    FOREIGN KEY (assignmentID) REFERENCES Assignment(assignmentID) ON DELETE CASCADE
);

CREATE TABLE Comment (
    commentID INT AUTO_INCREMENT PRIMARY KEY,
    passport CHAR(20),
    bookID INT,
    date CHAR(22),
    text CHAR(2000),
    likes CHAR(7),
    dislikes CHAR(7),
    FOREIGN KEY (passport) REFERENCES User(passport) ON DELETE CASCADE,
    FOREIGN KEY (bookID) REFERENCES Book(bookID) ON DELETE CASCADE
);
