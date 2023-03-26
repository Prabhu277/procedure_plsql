-- 1)( Create a external customer file upload the customer file to the table using external table methodz the.
--Pass the data in the intermediate table to customer tabke , 
--account table and customer to account relationship table. 
--And create a procedure that when given the customer I'd , 
--returns all the CTA relationship along with balances)

--Create Directory:
create or replace directory customer as 'D:\Prabhu\New folder\Oracle Task_1';
/
grant read,write on directory customer to SYS;
/
select * from dba_directories;
/
-- Create External File access to external to internal file
create table customer_tab(
customer_id int,
acc_holder_name varchar2(50),
email_id varchar2(50),
phone_no varchar2(20),
bank_name varchar2(50),
branch_name varchar2(50),
acc_no varchar2(50),
acc_type varchar2(20),
balance decimal(10,2)
)

ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY customer
  ACCESS PARAMETERS (
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('customers.txt')
);
/
select * from customer_tab;
/
drop table customer_tab;
/
grant select, insert, update, delete on customer_table to SYSTEM;

/
create table customer(
customer_id int,
acc_holder_name varchar2(50) ,
email_id varchar2(50) ,
phone_no varchar2(20),
bank_name varchar2(50) ,
branch_name varchar2(50) 
);
/
insert into customer (customer_id, acc_holder_name, email_id, phone_no, bank_name, branch_name)
select customer_id, acc_holder_name, email_id, phone_no, bank_name, branch_name
FROM customer_tab;
/
select * from customer;
/
drop table customer;
/
create table account(
acc_no varchar2(50),
customer_id int,
acc_type varchar2(20),
balance decimal(10,2)
)
/
insert into account (acc_no, customer_id, acc_type, balance)
select distinct acc_no, customer_id, acc_type, balance
FROM customer_tab;
/
select * from account;
/
drop table account;
/
create table customer_account(customer_id int,acc_holder_name varchar2(20), balance decimal(10,2));

/
insert into customer_account (customer_id,acc_holder_name, balance)
select customer_id ,acc_holder_name, balance
From customer_tab;
/
select * from customer_account;
/
drop table customer_account;
/
--create procedure with bluk fetch

create or replace procedure get_details is cursor ca is select * from customer_account;
begin
for i in ca loop
dbms_output.put_line(i.customer_id||' '||i.acc_holder_name||' '||i.balance);
end loop;
end;

/
execute get_details;
/
set serveroutput on;
begin
    get_details();
End;
/
set serveroutput on;
create or replace procedure id(c_id int)
IS 
c_balance customer_account%rowtype;
begin
    select * into c_balance from
    customer_account 
    where customer_id = c_id;
    dbms_output.put_line(c_balance.acc_holder_name || ' ' || c_balance.balance );
end;
/
EXECUTE id(10);
/
