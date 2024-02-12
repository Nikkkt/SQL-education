-- 1
GO
CREATE OR ALTER VIEW TeachersBooks AS
SELECT Teacher.first_name, Teacher.last_name, Book.name AS borrowed_books
FROM Teacher

JOIN T_Cards ON Teacher.id = T_Cards.id_teacher
JOIN Book ON T_Cards.id_book = Book.id

-- 2
GO
CREATE OR ALTER VIEW StudentsNotBooks AS
SELECT Student.first_name, Student.last_name 
FROM Student
WHERE id NOT IN (SELECT DISTINCT id_student FROM S_Cards)

-- 3
GO
CREATE OR ALTER VIEW MostActive AS
SELECT TOP 1 Librarian.first_name, Librarian.last_name, COUNT(*) AS TakenBooks
FROM Librarian

JOIN S_Cards ON Librarian.id = S_Cards.id_librarian
GROUP BY Librarian.first_name, Librarian.last_name

-- 4
GO
CREATE OR ALTER VIEW MostResponsible AS
SELECT TOP 1 Librarian.first_name, Librarian.last_name, COUNT(*) AS ReturnedBooks
FROM Librarian

JOIN S_Cards ON Librarian.id = S_Cards.id_librarian
WHERE S_Cards.date_in IS NOT NULL

GROUP BY Librarian.first_name, Librarian.last_name