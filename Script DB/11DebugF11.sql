IF EXISTS(SELECT 1 FROM sys.procedures WHERE [name] = 'InsertContactRole')
	BEGIN;
		DROP PROCEDURE dbo.InsertContactRole;
	END;
	
GO

GO

CREATE PROCEDURE dbo.InsertContactRole
(
 @ContactId	INT,
 @RoleTitle	VARCHAR(200)
)
AS
BEGIN;

DECLARE @RoleId		INT;
		
BEGIN TRANSACTION;

	INSERT INTO dbo.Roles (RoleTitle)
		VALUES (@RoleTitle);

	SELECT @RoleId = SCOPE_IDENTITY();

	INSERT INTO dbo.ContactRoles (ContactId, RoleId)
		VALUES (@ContactId, @RoleId);

	SELECT	C.ContactId, C.FirstName, C.LastName, R.RoleTitle
		FROM dbo.Contacts C
			INNER JOIN dbo.ContactRoles CR
				ON C.ContactId = CR.ContactId
			INNER JOIN dbo.Roles R
				ON CR.RoleId = R.RoleId
	WHERE C.ContactId = @ContactId
		AND R.RoleId = @RoleId;

COMMIT TRANSACTION;

END;
GO

-- execute procedure
EXEC dbo.InsertContactRole @ContactId = 22, -- int
    @RoleTitle = 'Comedian' -- varchar(200)

SELECT * FROM dbo.Roles;
SELECT * FROM dbo.ContactRoles;