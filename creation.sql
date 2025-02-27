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
    plate VARCHAR(50) PRIMARY KEY,
    status VARCHAR(50)
);

CREATE TABLE RouteStop (
    routeID INT,
    municipality VARCHAR(255),
    stopTime TIME,
    PRIMARY KEY (routeID, municipality),
    FOREIGN KEY (municipality) REFERENCES Municipality(name) ON DELETE CASCADE
);

CREATE TABLE Assignment (
    assignmentID INT PRIMARY KEY,
    stopDate DATE,
    plate VARCHAR(50),
    routeID INT,
    driverPassport VARCHAR(50),
    FOREIGN KEY (plate) REFERENCES Bibus(plate) ON DELETE NO ACTION,
    FOREIGN KEY (routeID) REFERENCES RouteStop(routeID) ON DELETE NO ACTION,
    FOREIGN KEY (driverPassport) REFERENCES Driver(passport) ON DELETE NO ACTION
);

CREATE TABLE Driver (
    passport VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255),
    surname VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    contractStart DATE,
    contractEnd DATE,
    status VARCHAR(50)
);

CREATE TABLE Book (
    bookID INT PRIMARY KEY,
    title VARCHAR(255),
    mainAuthor VARCHAR(255),
    country VARCHAR(255),
    originalLanguage VARCHAR(50),
    alternativeTitles TEXT,
    subject TEXT,
    contentNotes TEXT,
    awards TEXT
);

CREATE TABLE Edition (
    ISBN VARCHAR(50) PRIMARY KEY,
    bookID INT,
    publicationDate DATE,
    mainLanguage VARCHAR(50),
    otherLanguages TEXT,
    editionNumber INT,
    publisher VARCHAR(255),
    length INT,
    series VARCHAR(255),
    legalDeposit VARCHAR(255),
    publicationPlace VARCHAR(255),
    dimensions TEXT,
    physicalFeatures TEXT,
    ancillaryMaterial TEXT,
    notes TEXT,
    URL TEXT,
    FOREIGN KEY (bookID) REFERENCES Book(bookID) ON DELETE CASCADE
);

CREATE TABLE Copy (
    signature VARCHAR(50) PRIMARY KEY,
    ISBN VARCHAR(50),
    condition TEXT,
    comments TEXT,
    deregisteredDate DATE,
    FOREIGN KEY (ISBN) REFERENCES Edition(ISBN) ON DELETE CASCADE
);
/*updated values*/
CREATE TABLE User (
    passport VARCHAR(20) PRIMARY KEY,
    name CHAR(80),
    surname1 CHAR(80),
    surname2 CHAR(80),
    birthDate CHAR(10),
    municipality x,
    address CHAR(150),
    email CHAR(100),
    phone CHAR(9),
    FOREIGN KEY (municipality) REFERENCES Municipality(name) ON DELETE NO ACTION
);
/**/
CREATE TABLE Loan (
    signature VARCHAR(50),
    passport VARCHAR(20),
    loanDate DATE,
    returnDate DATE,
    penaltyWeeks INT,
    PRIMARY KEY (signature, passport),
    FOREIGN KEY (signature) REFERENCES Copy(signature) ON DELETE CASCADE,
    FOREIGN KEY (passport) REFERENCES User(passport) ON DELETE CASCADE
);

CREATE TABLE Reservation (
    signature VARCHAR(50),
    passport VARCHAR(20),
    assignmentID INT,
    reservationDate DATE,
    PRIMARY KEY (signature, passport, assignmentID),
    FOREIGN KEY (signature) REFERENCES Copy(signature) ON DELETE CASCADE,
    FOREIGN KEY (passport) REFERENCES User(passport) ON DELETE CASCADE,
    FOREIGN KEY (assignmentID) REFERENCES Assignment(assignmentID) ON DELETE CASCADE
);

CREATE TABLE Comment (
    commentID INT PRIMARY KEY,
    passport VARCHAR(50),
    bookID INT,
    date DATE,
    text TEXT,
    likes INT,
    dislikes INT,
    FOREIGN KEY (passport) REFERENCES User(passport) ON DELETE CASCADE,
    FOREIGN KEY (bookID) REFERENCES Book(bookID) ON DELETE CASCADE
);
