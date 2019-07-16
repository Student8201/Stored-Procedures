-- drop if exist
IF EXISTS(SELECT 1 FROM sys.procedures WHERE [name] = 'InsertContactAddress')
	BEGIN;
		DROP PROCEDURE dbo.InsertContactAddress;
	END;
	
GO

-- create procedure InsertContactAddress
CREATE PROCEDURE dbo.InsertContactAddress
(
 @ContactId		INT,
 @HouseNumber	VARCHAR(200),
 @Street	VARCHAR(200),
 @City	VARCHAR(200),
 @Postcode	VARCHAR(20)
)
AS
BEGIN;

SET NOCOUNT ON;

DECLARE @AddressId INT;

SELECT @Street = UPPER(LEFT(@Street, 1) + LOWER(LEFT(@Street, LEN(@Street) - 1)));
SELECT @City = UPPER(LEFT(@City, 1) + LOWER(LEFT(@City, LEN(@City) - 1)));

INSERT INTO dbo.ContactAddresses
        ( ContactId ,
          HouseNumber ,
          Street ,
          City ,
          Postcode
        )
VALUES  ( @ContactId , -- ContactId - int
          @HouseNumber , -- HouseNumber - varchar(200)
          @Street , -- Street - varchar(200)
          @City , -- City - varchar(200)
          @Postcode  -- Postcode - varchar(20)
        )
        
SELECT @AddressId = SCOPE_IDENTITY();
        
SELECT  ct.ContactId, ct.AddressId, ct.HouseNumber, ct.Street, 
ct.City, ct.Postcode
	FROM dbo.ContactAddresses ct
WHERE ContactId = @ContactId;

SET NOCOUNT OFF;

END;
GO
-- excute procedure
EXEC dbo.InsertContactAddress @ContactId = 24, -- int
    @HouseNumber = '10', -- varchar(200)
    @Street = 'Dowing Street', -- varchar(200)
    @City = 'London', -- varchar(200)
    @Postcode = 'SW1 2AA' -- varchar(20)

-- debug stored procedure
--CREATE PROCEDURE dbo.InsertContactAddress
--(
DECLARE
 @ContactId		INT,
 @HouseNumber	VARCHAR(200),
 @Street	VARCHAR(200),
 @City	VARCHAR(200),
 @Postcode	VARCHAR(20)
--)
-- AS
--BEGIN;

SET NOCOUNT ON;

DECLARE @AddressId INT;

SELECT @ContactId = 24, -- int
    @HouseNumber = '10', -- varchar(200)
    @Street = 'Dowing Street', -- varchar(200)
    @City = 'London', -- varchar(200)
    @Postcode = 'SW1 2AA' -- varchar(20)
    
PRINT 'Street left: ' + UPPER(LEFT(@Street, 1));
PRINT 'Street right: ' + LOWER(RIGHT(@Street, LEN(@Street) - 1));

SELECT @Street = UPPER(LEFT(@Street, 1)) + LOWER(RIGHT(@Street, LEN(@Street) - 1));
SELECT @City = UPPER(LEFT(@City, 1)) + LOWER(RIGHT(@City, LEN(@City) - 1));

PRINT 'Street: ' + @Street;
PRINT 'City: ' + @City;
/*
INSERT INTO dbo.ContactAddresses
        ( ContactId ,
          HouseNumber ,
          Street ,
          City ,
          Postcode
        )
VALUES  ( @ContactId , -- ContactId - int
          @HouseNumber , -- HouseNumber - varchar(200)
          @Street , -- Street - varchar(200)
          @City , -- City - varchar(200)
          @Postcode  -- Postcode - varchar(20)
        )
        
SELECT @AddressId = SCOPE_IDENTITY();
   
SELECT  ct.ContactId, ct.AddressId, ct.HouseNumber, ct.Street, 
ct.City, ct.Postcode
	FROM dbo.ContactAddresses ct
WHERE ContactId = @ContactId;
*/
SET NOCOUNT OFF;

-- END;
GO