
-- Function string_split
CREATE FUNCTION dbo.splitstring ( @stringToSplit VARCHAR(MAX) )
RETURNS
 @returnList TABLE ([Name] [nvarchar] (500))
AS
BEGIN

 DECLARE @name NVARCHAR(255)
 DECLARE @pos INT

 WHILE CHARINDEX(',', @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX(',', @stringToSplit)  
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)

  INSERT INTO @returnList 
  SELECT @name

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 INSERT INTO @returnList
 SELECT @stringToSplit

 RETURN
END
-- drop if exist
IF EXISTS(SELECT 1 FROM sys.procedures WHERE [name] = 'InsertContactNotes')
	BEGIN;
		DROP PROCEDURE dbo.InsertContactNotes;
	END;
	
GO
-- create procedure
CREATE PROCEDURE dbo.InsertContactNotes
(
 @ContactId		INT,
 @Notes			VARCHAR(MAX)
)
AS
BEGIN;

DECLARE @NoteTable	TABLE (Note	VARCHAR(MAX));
DECLARE @NoteValue	VARCHAR(MAX);

INSERT INTO @NoteTable (Note)
SELECT *
	FROM dbo.splitstring(@Notes);
-- SELECT value FROM STRING_SPLIT(@Notes, ',')
DECLARE NoteCursor CURSOR FOR 
	SELECT Note FROM @NoteTable;

OPEN NoteCursor
FETCH NEXT FROM NoteCursor INTO @NoteValue;

WHILE @@FETCH_STATUS = 0
 BEGIN;
	INSERT INTO dbo.ContactNotes (ContactId, Notes)
		VALUES (@ContactId, @NoteValue);

	FETCH NEXT FROM NoteCursor INTO @NoteValue;

 END;

CLOSE NoteCursor;
DEALLOCATE NoteCursor;

SELECT * FROM dbo.ContactNotes
	WHERE ContactId = @ContactId
ORDER BY NoteId DESC;

END;

-- excute 
/*
To change the compatibility level, select a different option from the list. 
The choices are SQL Server 2008 (100), SQL Server 2012 (110), SQL Server 2014 (120), SQL Server 2016 (130), and SQL Server 2017 (140).
STRING_SPLIT from 130 and higher
https://stackoverflow.com/questions/10914576/t-sql-split-string
*/
-- ALTER DATABASE Contacts SET COMPATIBILITY_LEVEL = 130

EXEC dbo.InsertContactNotes @ContactId = 22, -- int
    @Notes = 'ollie called. He wants you to ring him back.,Hal Roach atreed to meet.,Way Out West is a big hit!' -- varchar(max)
