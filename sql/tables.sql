-- ============================================
-- LibraryNexus • Schema Definition
-- ============================================

-- Drop existing tables to allow clean re-run
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Loans PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Books PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Members PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/

-- Books table: stores catalog with stock control
CREATE TABLE Books (
  book_id          NUMBER        PRIMARY KEY,
  title            VARCHAR2(200) NOT NULL,
  author           VARCHAR2(120),
  total_copies     NUMBER        NOT NULL CHECK (total_copies >= 0),
  available_copies NUMBER        NOT NULL CHECK (available_copies >= 0),
  status           VARCHAR2(20)  DEFAULT 'AVAILABLE' CHECK (status IN ('AVAILABLE','OUT'))
);

-- Members table: registered library users
CREATE TABLE Members (
  member_id   NUMBER        PRIMARY KEY,
  full_name   VARCHAR2(120) NOT NULL,
  email       VARCHAR2(160),
  joined_at   DATE          DEFAULT SYSDATE
);

-- Loans table: tracks borrow and return activity
CREATE TABLE Loans (
  loan_id     NUMBER        PRIMARY KEY,
  book_id     NUMBER        NOT NULL REFERENCES Books(book_id),
  member_id   NUMBER        NOT NULL REFERENCES Members(member_id),
  loan_date   DATE          DEFAULT SYSDATE,
  due_date    DATE          NOT NULL,
  return_date DATE,
  status      VARCHAR2(20)  DEFAULT 'BORROWED' CHECK (status IN ('BORROWED','RETURNED'))
);

-- Helpful indexes for performance
CREATE INDEX idx_loans_book   ON Loans(book_id);
CREATE INDEX idx_loans_member ON Loans(member_id);
