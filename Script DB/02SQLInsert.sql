USE Contacts;
GO

-- 01 create procedure InsertContact
CREATE PROCEDURE dbo.InsertContact
AS
BEGIN;

DECLARE @FirstName VARCHAR(40),
		@LastName VARCHAR(40),
		@DateOfBirth DATE,
		@AllowContactByPhone BIT;

SELECT @FirstName = 'Hoang',
		@LastName = 'Nguyen',
		@DateOfBirth = '1982-07-20',
		@AllowContactByPhone = 0;
		
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
END;
GO
-- execute insert contact
EXEC dbo.InsertContact;
GO


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
 @AllowContactByPhone BIT
)
AS

BEGIN;

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
END;
GO
-- execute insert contact with parameter
EXEC dbo.InsertContact
@FirstName = 'Terry',
@LastName = 'Thomas',
@DateOfBirth = '2000-09-08',
@AllowContactByPhone = 0;
GO

-- get contacts
EXEC dbo.SelectContacts;
GO
