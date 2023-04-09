create schema if not exists company;

create table company.employee (
	Fname varchar(15) NOT NULL,
    Minit char,
    Lname varchar(15) NOT NULL,
    Ssn char(9) NOT NULL,
    Bdate DATE,
    Address varchar(30),
    sex char,
    Salary decimal(10,2),
    Super_ssn char(9),
    Dno int NOT NULL,
    PRIMARY KEY (Ssn)
);

use company;
create table departmant (
	Dname varchar(15) not null,
    Dnumber int not null,
    Mgr_ssn char(9),
    Mgr_start_date date,
    primary key (Dnumber),
    unique (Dname),
    foreign key (Mgr_ssn) references employee(Ssn)
);

RENAME TABLE company.departmant TO company.department;
create table dept_locations (
	Dnumber int not null,
    Dlocation varchar(15) not null,
    primary key(Dnumber, Dlocation),
    foreign key (Dnumber) references department(Dnumber)
);

RENAME TABLE company.department TO company.departament;
create table project (
	Pname varchar(15) not null,
    Pnumber int not null,
    Plocation varchar(15),
    Dnum int not null,
    primary key (Pnumber, Plocation),
    unique (Pname),
    foreign key (Dnum) references departament(Dnumber)
);

create table works_on (
	Essn char(9) not null,
    Pno int not null,
    Hours decimal(3,1) not null,
    primary key (Essn, Pno),
    foreign key (Essn) references employee(Ssn),
    foreign key (Pno) references project(Pnumber)
);

create table dependent (
	Essn char(9) not null,
    Dependent_name varchar(15) not null,
    Sex char,
    Bdate date,
    Relationship varchar(8),
    primary key (Essn, Dependent_name),
    foreign key (Essn) references employee(Ssn)
);

show tables;
desc departament;

show character set;

select * from information_schema.table_constraints
where constraint_schema = 'company';

select * from information_schema.referential_constraints
where constraint_schema = 'company';

alter table employee
	add constraint fk_employee
    foreign key(Super_ssn) references employee(Ssn)
    on delete set null
    on update cascade;

alter table departament drop constraint departament_ibfk_1;
alter table departament add constraint fk_dept foreign key(Mgr_ssn) references employee(Ssn) on update cascade;
alter table departament add column Mgr_dept_date date;
alter table departament rename column Mgr_dept_date to Dept_create_date;

alter table dept_locations drop constraint dept_locations_ibfk_1;
alter table dept_locations add constraint fk_dept_locations foreign key (Dnumber) references departament(Dnumber) on delete cascade on update cascade;

-- inserção de dados no bd company
insert into employee values('John', 'B', 'Smith', 123456789, '1965-01-09', '731-Fondre-Houston-TX', 'M', 30000, NULL, 5); 
insert into employee values('Franklin', 'T', 'Wong', 333445555, '1955-12-08', '638-Voss-Houston-TX', 'M', 40000, 123456789, 5),
						   ('Alicia', 'J', 'Zelaya', 999887777, '1968-01-19', '3321-Castle-Spring-TX', 'F', 25000, 333445555, 4),
                           ('Jennifer', 'S', 'Wallace', 987654321, '1941-06-20', '291-Berry-Bellaire-TX', 'F', 43000, null, 5),
                           ('Ramesh', 'K', 'Narayan', 666884444, '1962-09-15', '975-Fire-Oak-Humble-TX', 'M', 38000, 987654321, 5),
                           ('Joyce', 'A', 'English', 453453453, '1972-07-31', '5631-Rice-Houston-TX', 'F', 25000, 987654321, 5),
                           ('Ahmad', 'V', 'Jabbar', 987987987, '1969-03-29', '980-Dallas-HOuston-TX', 'M', 25000, 123456789, 4),
                           ('James', 'E', 'Borg', 888665555, '1937-11-10', '450-Stone-Houston-TX', 'M', 55000, 333445555, 1); 
select * from employee;

insert into dependent values (333445555, 'Alice', 'F', '1986-04-05', 'Daughter'),
							 (333445555, 'Theodore', 'M', '1983-10-25', 'Son'),
                             (333445555, 'Joy', 'F', '1958-05-03', 'Spouse'),
                             (987654321, 'Abner', 'M', '1942-02-28', 'Spouse'),
                             (123456789, 'Michael', 'M', '1988-01-04', 'Son'),
                             (123456789, 'Alice', 'F', '1988-12-30', 'Daughter'),
                             (123456789, 'Elizabeth', 'F', '1967-05-05', 'Spouse');
select * from dependent;

insert into departament values ('Research', 5, 333445555, '1988-05-22', '1986-05-22'),
							   ('Administration', 4, 987654321, '1995-01-01', '1994-01-01'),
                               ('Headquarters', 1, 888665555, '1981-06-19', '1980-06-19');
select * from departament;

insert into dept_locations values (1, 'Houston'),
                                  (4, 'Stafford'),
                                  (5, 'Bellaire'),
                                  (5, 'Sugarland'),
                                  (5, 'Houston');
select * from dept_locations;
                                  
insert into project values ('ProductX', 1, 'Bellaire', 5),
						   ('ProductY', 2, 'Sugarland', 5),
                           ('ProductZ', 3, 'Houston', 5),
                           ('Computerization', 10, 'Stafford', 4),
                           ('Reorganization', 20, 'Houston', 1),
                           ('Newbenefits', 30, 'Stafford', 4);
select * from project;
                           
insert into works_on values (123456789, 1, 32.5),
							(123456789, 2, 7.5),
                            (666884444, 3, 40.0),
                            (453453453, 1, 20.0),
                            (453453453, 2, 20.0),
                            (333445555, 2, 10.0),
                            (333445555, 3, 10.0),
                            (333445555, 10, 10.0),
                            (333445555, 20, 10.0),
                            (999887777, 30, 30.0),
                            (999887777, 10, 10.0),
                            (987987987, 10, 35.0),
                            (987987987, 30, 5.0),
                            (987654321, 30, 20.0),
                            (987654321, 20, 15.0),
                            (888665555, 20, 0.0);
select * from works_on;


-- consultas ao banco
select Ssn, Fname from employee as e, departament as d where e.Ssn = d.Mgr_ssn;

select Fname, Dependent_name, Relationship from employee, dependent where Essn = Ssn;

select Bdate, Address from employee where Fname = 'John' and Minit = 'B' and Lname = 'Smith';

select * from departament where Dname = 'Research';

select Fname, Lname, Address from employee, departament where Dname = 'Research' and Dnumber = Dno order by Fname;

select * from project, works_on where Pnumber = Pno;

select Pname, Essn, Fname, Hours from project, works_on, employee where Pnumber = Pno and Essn = Ssn;

-- atribuindo Alias
select E.Fname, E.Lname, S.Fname, S.Lname from employee as E, employee as S where E.Super_ssn = S.Ssn;

select E.Fname, E.Lname, E.Address from employee as E, departament as D where D.Dname = 'Research' and D.Dnumber = E.Dno;

-- Dnumber; department
desc departament;
desc dept_locations;

-- retira a ambiguidade através do alias ou as statement
select * from departament as d, dept_locations as l where d.Dnumber = l.Dnumber;
select Dname, l.Dlocation from departament as d, dept_locations as l where d.Dnumber = l.Dnumber;

select concat(Fname, ' ', Lname) as Employee from employee;

-- conversão de date
select * from employee;
-- errado: update employee set Bdate = 'DEC-21-1980' WHERE Ssn = '333445555';
update employee set Bdate = str_to_date('DEC-21-1980', '%b-%d-%Y') where Ssn = '333445555';
select * from employee where Ssn = '333445555';

-- rename table departament for department (feito após os comandos para não afetar as consultas e inserções)
rename table departament to department;