----------------------------------------- PAYMENTPROCESSFLOW ----------------------------------

--use PaymentProcessFlow;

----------------------------------PROCEDURE TO CHECK DUPLICATE IDS OR 0 PAYMENT ------------------------------------------------------
/*
create procedure CheckDuplicateAndPayment
@id float,
@payment float

as 

if @id in (select CHART_ID from CodingExtractTable where CHART_ID = @id) OR @payment = 0
	return 0
else
	return 1
*/


-----------------------------------------PROCEDURE FOR MATCHING CRITERIA1 -------------------------------------------------------------
/*
create procedure MatchingCriteria1
@id float

as
declare 
@provider_group_id_from_CET float,
@provider_group_name_from_CET nvarchar(255),
@provider_group_name_from_PP nvarchar(255),
@provider_tin float,
@first_cond int,
@second_cond int

select @provider_group_id_from_CET= PROVIDER_GROUP_ID, @provider_group_name_from_CET = PROVIDER_GROUP_NAME  from CodingExtractTable where CHART_ID = @id;
select @provider_tin = provider_group_id, @provider_group_name_from_PP = provider_group_name from ProviderPaymentTable where chart_id=@id;

if @provider_group_id_from_CET = @provider_tin
	set @first_cond = 1

else
	set @first_cond = 0

if (select LEFT(@provider_group_name_from_CET,10)) = (select LEFT(@provider_group_name_from_PP,10))
	set @second_cond = 1 
else
	set @second_cond = 0

if (@first_cond=1 AND @second_cond=1)
	return 1

else 
	return 0

*/

-----------------------------------------PROCEDURE FOR MATCHING CRITERIA2 ----------------------------------------------
/*
create procedure MatchingCriteria2
@id float

as
declare 
@provider_group_id_from_CET float,
@provider_group_name_from_CET nvarchar(255),
@provider_group_name_from_PP nvarchar(255),
@provider_tin float,
@first_cond int,
@second_cond int,
@find int

select @provider_group_id_from_CET= PROVIDER_GROUP_ID, @provider_group_name_from_CET = PROVIDER_GROUP_NAME  from CodingExtractTable where CHART_ID = @id;
select @provider_tin = provider_group_id, @provider_group_name_from_PP = provider_group_name from ProviderPaymentTable where chart_id=@id;

if @provider_group_id_from_CET = @provider_tin
	set @first_cond = 1

else
	set @first_cond = 0

set @find = CHARINDEX(LEFT(@provider_group_name_from_PP,5),@provider_group_name_from_CET)

if @find = 0
	set @second_cond = 0

else
	set @second_cond = 1

if (@first_cond=1 AND @second_cond=1)
	return 1

else 
	return 0


*/


-----------------------------------------PROCEDURE FOR MATCHING CRITERIA3 ----------------------------------------------
/*
create procedure MatchingCriteria3
@id float

as
declare 
@provider_group_id_from_CET float,
@provider_last_name_from_CET nvarchar(255),
@provider_last_name_from_PP nvarchar(255),
@provider_first_name_from_CET nvarchar(255),
@provider_first_name_from_PP nvarchar(255),
@provider_tin float,
@first_cond int,
@second_cond int,
@third_cond int,
@find int

select @provider_group_id_from_CET= PROVIDER_GROUP_ID, @provider_last_name_from_CET = PROVIDER_LAST_NAME, @provider_first_name_from_CET = PROVIDER_FIRST_NAME  from CodingExtractTable where CHART_ID = @id;
select @provider_tin = provider_group_id, @provider_last_name_from_PP = provider_last_name, @provider_first_name_from_PP = provider_first_name from ProviderPaymentTable where chart_id=@id;

if @provider_group_id_from_CET = @provider_tin
	set @first_cond = 1

else
	set @first_cond = 0


if @provider_last_name_from_CET = @provider_last_name_from_PP
	set @second_cond = 1
else
	set @second_cond = 0


if (select(LEFT(@provider_first_name_from_CET,5))) = (select(LEFT(@provider_first_name_from_PP,5)))
	set @third_cond = 1
else
	set @third_cond = 0


if (@first_cond=1 AND @second_cond=1 AND @third_cond = 1)
	return 1

else 
	return 0
*/


-----------------------------------------PROCEDURE FOR MATCHING CRITERIA4 ----------------------------------------------
/*
create procedure MatchingCriteria4
@id float

as
declare 
@provider_last_name_from_CET nvarchar(255),
@provider_last_name_from_PP nvarchar(255),
@provider_first_name_from_CET nvarchar(255),
@provider_first_name_from_PP nvarchar(255),
@provider_group_name_from_CET nvarchar(255),
@provider_group_name_from_PP nvarchar(255),
@first_cond int,
@second_cond int,
@third_cond int

select @provider_group_name_from_CET= PROVIDER_GROUP_NAME, @provider_last_name_from_CET = PROVIDER_LAST_NAME, @provider_first_name_from_CET = PROVIDER_FIRST_NAME  from CodingExtractTable where CHART_ID = @id;
select @provider_group_name_from_PP = provider_group_name, @provider_last_name_from_PP = provider_last_name, @provider_first_name_from_PP = provider_first_name from ProviderPaymentTable where chart_id=@id;

if (select(LEFT(@provider_group_name_from_CET,10))) = (select(LEFT(@provider_group_name_from_PP,10)))
	set @first_cond = 1
else
	set @first_cond = 0

if @provider_last_name_from_CET = @provider_last_name_from_PP
	set @second_cond = 1
else
	set @second_cond = 0


if (select(LEFT(@provider_first_name_from_CET,5))) = (select(LEFT(@provider_first_name_from_PP,5)))
	set @third_cond = 1
else
	set @third_cond = 0


if (@first_cond=1 AND @second_cond=1 AND @third_cond = 1)
	return 1

else 
	return 0
*/


---------------------------------------------CREATING THE STAGES(1,2,3,4) AND EXCLUSION REPORT AND REJECTEDIDS TABLE---------------------
/*
select * into Stage1 from CodingExtractTable where 1= 0;

select * into Stage2 from CodingExtractTable where 1= 0;

select * into Stage3 from CodingExtractTable where 1= 0;

select * into Stage4 from CodingExtractTable where 1= 0;

select * into Exclusion_Report from CodingExtractTable where 1= 0;

select * into RejectedIDS from CodingExtractTable where 1= 0;
*/

----------------------------------------------- THIS IS THE PARENT PROCEDURE WHICH WILL CALL ALL OTHER PROCEDURES ---------------------------
/*
create procedure PaymentProcessProcedure
@id float,
@payment float

as

declare
@match1 int,
@match2 int,
@match3 int,
@match4 int

execute @match1 = MatchingCriteria1 @id

if @match1 = 1
begin
	insert into Stage1 select * From CodingExtractTable where CodingExtractTable.CHART_ID = @id
end

else
begin
	execute @match2 = MatchingCriteria2 @id

	if @match2 = 1
	begin
		insert into Stage2 select * From CodingExtractTable where CodingExtractTable.CHART_ID= @id
	end

	else
	begin
		execute @match3 = MatchingCriteria3 @id
		if @match3 = 1
		begin
			insert into Stage3 select * From CodingExtractTable where CodingExtractTable.CHART_ID = @id
		end
		else
		begin
			execute @match4 = MatchingCriteria4 @id
			if @match4 = 1
			begin
				insert into Stage4 select * From CodingExtractTable where CodingExtractTable.CHART_ID = @id
			end
				
			else
			begin
				insert into Exclusion_Report select * From CodingExtractTable where CodingExtractTable.CHART_ID = @id
			end

		end

	end


	end
*/




-------------------------------------- THIS CODE IS USED TO CALL THE PARENT PROCEDURE ON EVERY ROW OF CODINGEXTRACTTABLE -------------------

/*
declare 
@id int,
@payment float

Declare cursor1 CURSOR READ_ONLY
FOR 
select CHART_ID, PAYMENT from CodingExtractTable

open cursor1

fetch next from cursor1 into
@id, @payment 

while @@FETCH_STATUS = 0
begin
	execute PaymentProcessProcedure @id, @payment

	fetch next from cursor1 into @id, @payment
end

close cursor1
deallocate cursor1
*/

