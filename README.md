# LibraryNexus 📔☂️
LibraryNexus is a PL/SQL system that unites books, members, and loans in one streamlined flow. It validates stock, enforces borrowing logic, and updates statuses automatically. Lightweight yet powerful, it delivers clarity and reliability for modern library management.

---

## Features

> Relational schema with three core entities: Books, Members, and Loans.

> Borrowing procedure (Borrow_Book) that enforces stock validation and due-date calculation.

> Automated triggers to adjust stock and book status on loan and return.

> Sample dataset with books and members for immediate testing.

> End-to-end test script to validate business logic and error handling.

---


## Project Structure

```pgsql
LibraryNexus
├── sql
│   ├── tables.sql        # Schema definitions
│   ├── procedures.sql    # Stored procedure(s)
│   ├── triggers.sql      # Automatic stock update triggers
│   ├── seed.sql          # Sample data inserts
│   └── test.sql          # End-to-end test script
├── LICENSE               # MIT License
└── README.md             # Project documentation
```

## Quick Start

### 1. Create Schema

Run the schema script in Oracle Live SQL or an Oracle XE instance:

```sql
@sql/tables.sql
```

### 2. Load Stored Procedure and Triggers

```sql
@sql/procedures.sql
@sql/triggers.sql
```

### 3. Insert Sample Data

```sql
@sql/seed.sql
```

### 4. Run Tests

Execute the full workflow:

```sql
@sql/test.sql
```

## Example Output

```csharp
Borrowed book 1 by member 101
Borrowed book 1 by member 102
Borrowed book 3 by member 201
Expected error: ORA-20002: Book out of stock
```

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---

## Author
Created by Rico Aprilla Nanda
