-- ============================================
-- LibraryNexus • Triggers for Book Stock Update
-- ============================================

-- Drop triggers if they already exist
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_loans_ai_borrow'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -4080 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_loans_au_return'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -4080 THEN RAISE; END IF; END;
/

-- Trigger after inserting a new loan: decrease available copies
CREATE OR REPLACE TRIGGER trg_loans_ai_borrow
AFTER INSERT ON Loans
FOR EACH ROW
DECLARE
  v_avail NUMBER;
BEGIN
  UPDATE Books
     SET available_copies = available_copies - 1
   WHERE book_id = :NEW.book_id;

  SELECT available_copies INTO v_avail FROM Books WHERE book_id = :NEW.book_id;
  UPDATE Books
     SET status = CASE WHEN v_avail <= 0 THEN 'OUT' ELSE 'AVAILABLE' END
   WHERE book_id = :NEW.book_id;
END;
/
SHOW ERRORS;

-- Trigger after returning a book: increase available copies
CREATE OR REPLACE TRIGGER trg_loans_au_return
AFTER UPDATE OF return_date ON Loans
FOR EACH ROW
WHEN (OLD.return_date IS NULL AND NEW.return_date IS NOT NULL)
DECLARE
  v_avail NUMBER;
BEGIN
  UPDATE Books
     SET available_copies = available_copies + 1
   WHERE book_id = :NEW.book_id;

  SELECT available_copies INTO v_avail FROM Books WHERE book_id = :NEW.book_id;
  UPDATE Books
     SET status = CASE WHEN v_avail <= 0 THEN 'OUT' ELSE 'AVAILABLE' END
   WHERE book_id = :NEW.book_id;
END;
/
SHOW ERRORS;
