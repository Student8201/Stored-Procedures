IF EXISTS(SELECT 1 FROM sys.procedures WHERE [name] = 'InsertContactRole')
	BEGIN;
		DROP PROCEDURE dbo.InsertContactRole;
	END;
	
GO

-- create procedure defensive coding
CREATE PROCEDURE dbo.InsertContactRole
(
 @ContactId	INT,
 @RoleTitle	VARCHAR(200)
)
AS
BEGIN;

DECLARE @RoleId		INT;
		
BEGIN TRY;

BEGIN TRANSACTION;

	IF NOT EXISTS(SELECT 1 FROM dbo.Roles WHERE RoleTitle = @RoleTitle)
	 BEGIN;
		INSERT INTO dbo.Roles (RoleTitle)
			VALUES (@RoleTitle);
	 END;

	SELECT @RoleId = RoleId FROM dbo.Roles WHERE RoleTitle = @RoleTitle;

	IF NOT EXISTS(SELECT 1 FROM dbo.ContactRoles WHERE ContactId = @ContactId AND RoleId = @RoleId)
	 BEGIN;
		INSERT INTO dbo.ContactRoles (ContactId, RoleId)
			VALUES (@ContactId, @RoleId);
	 END;

COMMIT TRANSACTION;
	
SELECT	C.ContactId, C.FirstName, C.LastName, R.RoleTitle
	FROM dbo.Contacts C
		INNER JOIN dbo.ContactRoles CR
			ON C.ContactId = CR.ContactId
		INNER JOIN dbo.Roles R
			ON CR.RoleId = R.RoleId
WHERE C.ContactId = @ContactId;

END TRY
BEGIN CATCH;
	IF (@@TRANCOUNT > 0)
	 BEGIN;
		ROLLBACK TRANSACTION;
	 END;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE(); 
	PRINT 'Error message: ' + ERROR_MESSAGE();
	RETURN -1;
END CATCH;

RETURN 0;

END;

-- execute procedure
DECLARE @RetVal INT;

EXEC @RetVal = dbo.InsertContactRole @ContactId = 22, -- int
    @RoleTitle = 'Comedian'; -- varchar(200)
    
PRINT 'Return value: '+ CONVERT(VARCHAR(10), @RetVal);    

SELECT* FROM dbo.Roles;
SELECT * FROM dbo.ContactRoles;


    