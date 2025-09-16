-- ============================================
-- LibraryNexus • Borrow Procedure
-- ============================================

-- Drop procedure if it already exists
BEGIN EXECUTE IMMEDIATE 'DROP PROCEDURE Borrow_Book'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -4043 THEN RAISE; END IF; END;
/

-- Borrow_Book: validates availability and creates a loan record
CREATE OR REPLACE PROCEDURE Borrow_Book (
  p_book_id    IN NUMBER,
  p_member_id  IN NUMBER,
  p_days       IN NUMBER DEFAULT 7
) AS
  v_avail   Books.available_copies%TYPE;
  v_exists  NUMBER;
  v_due     DATE := TRUNC(SYSDATE) + NVL(p_days, 7);
BEGIN
  -- Ensure member exists
  SELECT COUNT(*) INTO v_exists FROM Members WHERE member_id = p_member_id;
  IF v_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Member not found');
  END IF;

  -- Check availability of the book
  SELECT available_copies INTO v_avail FROM Books WHERE book_id = p_book_id FOR UPDATE;
  IF v_avail <= 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Book out of stock');
  END IF;

  -- Insert new loan record (incremental loan_id)
  INSERT INTO Loans (loan_id, book_id, member_id, loan_date, due_date, status)
  VALUES ((SELECT NVL(MAX(loan_id), 0) + 1 FROM Loans), p_book_id, p_member_id, SYSDATE, v_due, 'BORROWED');

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20003, 'Book not found');
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END Borrow_Book;
/
SHOW ERRORS;
