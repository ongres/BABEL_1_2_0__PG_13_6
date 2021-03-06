-- For TDS backends, the dbid is the logical database id, so db_name(dbid)
-- should show us the logical database name of the process.
-- We are showing multiple rows in sys.sysprocesses for the
-- current SPID (BABEL-2828), so doing a SELECT DISTINCT
SELECT DISTINCT db_name(dbid), loginname FROM sys.sysprocesses WHERE spid = @@SPID
GO

CREATE DATABASE db_2829
GO
USE db_2829
GO
SELECT DISTINCT db_name(dbid), loginname FROM sys.sysprocesses WHERE spid = @@SPID
GO
USE master
GO
DROP DATABASE db_2829
GO