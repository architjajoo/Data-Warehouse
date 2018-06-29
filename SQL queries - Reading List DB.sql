--What are the two categories of books?
SELECT  categoryName FROM Category;

--How many books are read between 2006 and 2016?
Select COUNT(*) FROM BookRead
Where yearRead between 2006 and 2016;

--Which subcategory names begin with “20th Century” in alphabetical order?
select subcategoryName from Subcategory
where subcategoryName LIKE '20th Century%'
order by subcategoryName;

--How many unique authors are there?
select count(*) from Author;

--What is the title and number of pages of the shortest book read?
select top 1 title,pages
from Book
order by pages;

--What is the average length of the authors’ names?
select AVG(LEN(authorName) * 1.0) from Author;

-- How many unique books written by William Shakespear have been read?
select count(*) 
from BookAuthor ba inner join Author a on ba.authorId = a.authorId
where a.authorName = 'William Shakespeare';

-- How many total pages are read in 2011?
select sum(pages) as totalPages
from Book
where bookId in (select bookId from BookRead where yearRead = 2011);

--What are the titles of the books that are being read currently?
select title
from Book b inner join BookRead br on b.bookId = br.bookId
where currentlyReading = 1;

--How many subcategories of “Nonfiction” books are there?
select COUNT(*)
from Subcategory s inner join Category c on s.categoryId = c.categoryId
where c.categoryName =  'Nonfiction';

--In which years was “Harry Potter and the Deathly Hallows” read?
select yearRead
from Book b inner join BookRead br on b.bookId = br.bookId
where title = 'Harry Potter and the Deathly Hallows';

--Which authors wrote the book entitled “What I Learned Losing a Million Dollars”?
select authorName
from Book b inner join BookAuthor ba on b.bookId = ba.bookId
inner join Author a on ba.authorId = a.authorId
where b.title = 'What I Learned Losing a Million Dollars'
order by ba.authorOrder;

--What is the average number of pages of the “Fiction” books that were read in 2016?
select AVG(pages * 1.0) as avgPages
from Category c inner join Subcategory sc on c.categoryId = sc.categoryId
inner join Book b on sc.subcategoryId = b.subcategoryId
inner join BookRead br on b.bookId = br.bookId
where c.categoryName = 'Fiction' and br.yearRead = 2016;

/*What is the minimum number of pages, maximum number of pages, and average number of pages 
for all of the unique books written by George R. R. Martin and that were read?*/
select MIN(pages) as minPages, Max(pages) as maxPages,
AVG(pages * 1.0) as avgPages
from Book b inner join BookAuthor ba on b.bookId = ba.bookId
inner join Author a on ba.authorId = a.authorId
where a.authorName = 'George R. R. Martin';

--What is the most common first letter of the authors’ first names?
select top 1 LEFT(authorName, 1) as firstLetter, COUNT(*)
from Author
group by LEFT(authorName, 1)
order by COUNT(*) desc;

------------------------------------------------------------------------------------------

/*With respect to the number of pages in each book, what is the mean (average) and
standard deviation among all of the books that were read?*/
SELECT AVG(pages * 1.0) AS mean, STDEV(pages * 1.0) AS stdDev
FROM Book;

--What is the title of the only book in the reading list that is exactly 583 pages long?
SELECT title 
FROM Book
WHERE pages = 583;

--What is the most common length (number of pages) of all of the books that were read?
SELECT TOP 1 pages, COUNT(*) AS numberOfBooks
FROM Book
GROUP BY pages
ORDER BY numberOfBooks DESC;

-- What are the names of the authors that have only 5 characters in their name?
SELECT authorName
FROM Author
WHERE LEN(authorName) = 5;

--What is the name of the subcategory whose ID is 107?
SELECT subcategoryName
FROM Subcategory
WHERE subcategoryId = 107;

--What is the title of the very first book that was added to the reading list?
SELECT TOP 1 title
FROM Book b INNER JOIN BookRead br ON b.bookId = br.bookId
ORDER BY readingOrder;

--What is the title of the one book that was read and was written by multiple authors in 2015?
SELECT b.title, COUNT(*) AS numberOfAuthors
FROM BookAuthor ba INNER JOIN Book b ON ba.bookId = b.bookId
INNER JOIN BookRead br ON b.bookId = br.bookId
WHERE br.yearRead = 2015
GROUP BY b.title
HAVING COUNT(*) > 1;

/*In what year was the book with fewest total pages read and how many pages were 
read during that year?*/
SELECT TOP 1 yearRead, SUM(pages) AS totalPages
FROM Book b INNER JOIN BookRead br ON b.bookId = br.bookId
GROUP BY yearRead
ORDER BY totalPages;

--How many total pages are read in books written by Richard Feynman?
SELECT SUM(pages) AS totalPages
FROM Book b INNER JOIN BookRead br ON b.bookId = br.bookId
INNER JOIN BookAuthor ba ON ba.bookId = b.bookId
INNER JOIN Author a ON a.authorId = ba.authorId
WHERE a.authorName = 'Richard Feynman';

/*What are the titles of all of the books in the Economics subcategory that were
read in 2011?*/
SELECT title
FROM Book b INNER JOIN BookRead br On b.bookId = br.bookId
INNER JOIN Subcategory s ON b.subcategoryId = s.subcategoryId
WHERE s.subcategoryName = 'Economics'
AND yearRead = 2011;

--How many fiction books were read each year between 2010 and 2012?
SELECT yearRead, COUNT(*) AS fictionBooks
FROM BookRead br INNER JOIN Book b ON br.bookId = b.bookId
INNER JOIN Subcategory s ON b.subcategoryId = s.subcategoryId
INNER JOIN Category c ON s.categoryId = c.categoryId
WHERE yearRead BETWEEN 2010 AND 2012
AND c.categoryName = 'Fiction'
GROUP BY yearRead;

--What is the title of the first book that was read and was written by Orson Scott Card?
SELECT TOP 1 title
FROM BookRead br INNER JOIN Book b ON br.bookId = b.bookId
INNER JOIN BookAuthor ba ON ba.bookId = b.bookId
INNER JOIN Author a ON ba.authorId = a.authorId
WHERE a.authorName = 'Orson Scott Card'
ORDER BY readingOrder;

--How many books have been read more than once?
SELECT COUNT(*)
FROM (
SELECT bookId, COUNT(*) AS timesRead
FROM BookRead
GROUP BY bookId
HAVING COUNT(*) > 1
) AS booksReadMultipleTimes;

/* What are the three most popular subcategories of nonfiction books that were read? 
and what are the no. of books in each of these subcategories?*/
SELECT TOP 3 subcategoryName, COUNT(*) AS totalBooksRead
FROM Book b INNER JOIN BookRead br ON b.bookId = br.bookId
INNER JOIN Subcategory s ON b.subcategoryId = s.subcategoryId
INNER JOIN Category c ON c.categoryId = s.categoryId
WHERE c.categoryName = 'Nonfiction'
GROUP BY subcategoryName
ORDER BY totalBooksRead DESC;

--On average, how many books were read per year prior to 2017?
SELECT COUNT(*) * 1.0 /
(
SELECT COUNT(*) AS totalYears
FROM (
SELECT DISTINCT yearRead FROM BookRead WHERE yearRead < 2017
) AS distinctYears
) AS avgBooksPerYear
FROM BookRead
WHERE yearRead < 2017;

