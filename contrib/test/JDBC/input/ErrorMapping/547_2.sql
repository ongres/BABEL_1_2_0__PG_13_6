CREATE TABLE t547_2(c1 int CHECK  (c1 < 10));
INSERT INTO t547_2 VALUES(5)
GO

INSERT INTO t547_2 VALUES(50);
GO

begin transaction
GO

INSERT INTO t547_2 VALUES(50);
GO

if (@@trancount > 0) select cast('transaction did not rolledback' as text) else select cast('transaction rollback' as text)
GO

if (@@trancount > 0) rollback tran
GO

create schema error_mapping;
GO

create table error_mapping.temp1 (a int)
GO

create procedure error_mapping.ErrorHandling1 as
begin
insert into error_mapping.temp1 values(1)
INSERT INTO t547_2 VALUES(50);
end
GO


create table error_mapping.temp2 (a int)
GO

insert into error_mapping.temp2 values(1)
INSERT INTO t547_2 VALUES(50);
GO

create table error_mapping.temp3 (a int)
GO

insert into error_mapping.temp3 values(1)
exec error_mapping.ErrorHandling1;
GO

if ((select count(*) from error_mapping.temp1) = 0 and (select count(*) from error_mapping.temp2) = 0 and (select count(*) from error_mapping.temp3) > 0) select cast('parse analysis phase error' as text)
GO

drop procedure error_mapping.ErrorHandling1;
GO
drop table error_mapping.temp1;
drop table error_mapping.temp2;
drop table error_mapping.temp3;
GO


create procedure error_mapping.ErrorHandling1 as
begin
INSERT INTO t547_2 VALUES(50);
if @@error > 0 select cast('STATEMENT TERMINATING ERROR' as text);
select @@trancount;
end
GO

create procedure error_mapping.ErrorHandling2 as
begin
exec error_mapping.ErrorHandling1;
if @@error > 0 select cast('CURRENT BATCH TERMINATING ERROR' as text);
end
GO

begin transaction;
GO
exec error_mapping.ErrorHandling2;
GO

declare @err int = @@error; if (@err > 0 and @@trancount > 0) select cast('BATCH ONLY TERMINATING' as text) else if @err > 0 select cast('BATCH TERMINATING\ txn rolledback' as text);
if @@trancount > 0 rollback transaction;
GO

drop procedure error_mapping.ErrorHandling1;
drop procedure error_mapping.ErrorHandling2;
set xact_abort OFF;
set implicit_transactions OFF;
GO


set xact_abort ON;
GO

create procedure error_mapping.ErrorHandling1 as
begin
INSERT INTO t547_2 VALUES(50);
if @@error > 0 select cast('STATEMENT TERMINATING ERROR' as text);
select @@trancount;
end
GO

create procedure error_mapping.ErrorHandling2 as
begin
exec error_mapping.ErrorHandling1;
if @@error > 0 select cast('CURRENT BATCH TERMINATING ERROR' as text);
end
GO

begin transaction;
GO
exec error_mapping.ErrorHandling2;
GO
declare @err int = @@error; if (@err > 0 and @@trancount > 0) select cast('BATCH ONLY TERMINATING' as text) else if @err > 0 select cast('BATCH TERMINATING\ txn rolledback' as text);
if @@trancount > 0 rollback transaction;
GO

drop procedure error_mapping.ErrorHandling1;
drop procedure error_mapping.ErrorHandling2;
set xact_abort OFF;
set implicit_transactions OFF;
GO

set xact_abort OFF;
GO

create table babel_2880(a int)
GO

begin try
insert into babel_2880 values(1);
INSERT INTO t547_2 VALUES(50);
end try
begin catch
	select * from babel_2880;
	select xact_state();
end catch
GO

select * from babel_2880;
GO

if @@trancount > 0 rollback transaction;
GO

set xact_abort OFF;
set implicit_transactions OFF;
GO


DROP TABLE t547_2
GO

drop table babel_2880
GO

drop schema error_mapping;
GO
