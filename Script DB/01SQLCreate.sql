-- drop if exist procedure SelectContacts
IF EXISTS(SELECT 1 FROM sys.procedures WHERE [name] = 'SelectContacts')
	BEGIN;
		DROP PROCEDURE dbo.SelectContacts;
	END;
	
GO
-- create procedure
CREATE PROCEDURE dbo.SelectContacts
AS
BEGIN
SELECT * FROM dbo.Contacts ORDER BY ContactId DESC; -- WHERE FirstName = 'Grace';
END;

GO
-- execute procedure
EXEC dbo.SelectContacts;
GO
