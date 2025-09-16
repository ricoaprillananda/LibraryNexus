-- ============================================
-- LibraryNexus • End-to-End Test
-- ============================================

SET SERVEROUTPUT ON;

-- Borrow book id=1 by member 101 (stock: 3 → 2)
BEGIN
  Borrow_Book(1, 101, 7);
  DBMS_OUTPUT.PUT_LINE('Borrowed book 1 by member 101');
END;
/
SELECT book_id, title, available_copies, status FROM Books WHERE book_id = 1;

-- Borrow book id=1 again by member 102 (stock: 2 → 1)
BEGIN
  Borrow_Book(1, 102, 14);
  DBMS_OUTPUT.PUT_LINE('Borrowed book 1 by member 102');
END;
/
SELECT book_id, title, available_copies, status FROM Books WHERE book_id = 1;

-- Return one loan (stock should increase by 1)
UPDATE Loans
   SET return_date = SYSDATE,
       status = 'RETURNED'
 WHERE loan_id = (SELECT MIN(loan_id) FROM Loans WHERE book_id = 1 AND status = 'BORROWED');
COMMIT;
SELECT book_id, title, available_copies, status FROM Books WHERE book_id = 1;

-- Borrow book id=3 until stock is exhausted
BEGIN
  Borrow_Book(3, 201, 7); -- should succeed
  DBMS_OUTPUT.PUT_LINE('Borrowed book 3 by member 201');
  -- Attempt to borrow again with no stock
  Borrow_Book(3, 101, 7);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/
SELECT book_id, title, available_copies, status FROM Books WHERE book_id = 3;
