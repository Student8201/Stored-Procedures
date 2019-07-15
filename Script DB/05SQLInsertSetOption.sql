-- SET OPTION LESS NETWORK TRAFFIC
-- EXECUTE -> RESULT, METADATA
-- drop if exist
-- DROP PROCEDURE IF EXISTS dbo.InsertContact;
IF EXISTS(SELECT 1 FROM sys.procedures WHERE [name] = 'InsertContact')
	BEGIN;
		DROP PROCEDURE dbo.InsertContact;
	END;
	
GO

-- 02 create procedure with parameters not initalize
CREATE PROCEDURE dbo.InsertContact
(
 @FirstName VARCHAR(40),
 @LastName VARCHAR(40),
 @DateOfBirth DATE = NULL, -- default value
 @AllowContactByPhone BIT,
 @ContactId INT OUTPUT
)
AS

BEGIN;

SET NOCOUNT ON;

INSERT INTO dbo.Contacts
        ( FirstName ,
          LastName ,
          DateOfBirth ,
          AllowContactByPhone ,
          CreatedDate
        )
VALUES  ( @FirstName , -- FirstName - varchar(40)
          @LastName , -- LastName - varchar(40)
          @DateOfBirth , -- DateOfBirth - date
          @AllowContactByPhone , -- AllowContactByPhone - bit
          GETDATE()  -- CreatedDate - datetime
        )
        
SELECT @ContactId = SCOPE_IDENTITY(); -- have trigger -> add table ContactAddresses
SELECT ContactId, FirstName, LastName, DateOfBirth, AllowContactByPhone
FROM dbo.Contacts
WHERE ContactId = @ContactId;

SET NOCOUNT OFF;

END;
GO
-- execute procedure

DECLARE @ContactIdOut INT;

EXEC dbo.InsertContact
@FirstName = 'Michael',
@LastName = 'Monkhouse',
@DateOfBirth = '2000-09-08',
@AllowContactByPhone = 0,
@ContactId = @ContactIdOut OUTPUT;

SELECT * FROM dbo.Contacts WHERE ContactId = @ContactIdOut ORDER BY ContactId DESC;

SELECT @ContactIdOut AS ContactIdOut;
