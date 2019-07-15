-- drop if exist
IF EXISTS(SELECT 1 FROM sys.types WHERE [name] = 'DrivingLicense')
	BEGIN;
		DROP TYPE dbo.DrivingLicense;
	END;
	
GO
-- create user-defined data type
CREATE TYPE dbo.DrivingLicense
FROM CHAR(16) NOT NULL;
GO

-- declare data type
DECLARE @DV DrivingLicense = 'lakdjfl1234567akjdfladjf231232131';
SELECT @DV AS DrivingLicense;
-- drop if exist
IF EXISTS(SELECT 1 FROM sys.table_types WHERE [name] = 'ContactNote')
	BEGIN;
		DROP TYPE dbo.ContactNote;
	END;
	
GO

-- create user-defined table type
CREATE TYPE dbo.ContactNote
AS TABLE(
Note VARCHAR(MAX) NOT NULL
);
GO

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
 @Notes			dbo.ContactNote READONLY
)
AS
BEGIN;

INSERT INTO dbo.ContactNotes(ContactId, Notes)
SELECT @ContactId, Note
	FROM @Notes;
-- SELECT value FROM STRING_SPLIT(@Notes, ',')

SELECT * FROM dbo.ContactNotes
	WHERE ContactId = @ContactId
ORDER BY NoteId DESC;

END;

-- calling stored procedure with a Table-valued parameter
DECLARE @TempNotes dbo.ContactNote;
-- insert temp table
INSERT INTO @TempNotes
        ( Note )
VALUES  ( 'Hi, Peter called'),  -- Note - varchar(max)
          ('Quick note to let you know Jo wants you to ring her'),
          ('She ran at 14:30. Terri asked about the quote.');

-- execute stored procedure
EXEC dbo.InsertContactNotes @ContactId = 23, -- int
    @Notes = @TempNotes -- ContactNote
