-- ============================================
-- LibraryNexus • Sample Data
-- ============================================

-- Insert sample books
INSERT INTO Books (book_id, title, author, total_copies, available_copies, status) VALUES
(1, 'Clean Code', 'Robert C. Martin', 3, 3, 'AVAILABLE');
INSERT INTO Books VALUES (2, 'Design Patterns', 'GoF', 2, 2, 'AVAILABLE');
INSERT INTO Books VALUES (3, 'Introduction to Algorithms', 'CLRS', 1, 1, 'AVAILABLE');

-- Insert sample members
INSERT INTO Members (member_id, full_name, email, joined_at) VALUES
(101, 'Alice Johnson', 'alice@example.com', SYSDATE);
INSERT INTO Members VALUES (102, 'Brian Lee', 'brian@example.com', SYSDATE);
INSERT INTO Members VALUES (201, 'Carla Gomez', 'carla@example.com', SYSDATE);

COMMIT;
