/*Veri Analizi Teknik ödev Soru-2*/

/*
Elimizde çok sayıda e-mail adresi var. Bu adreslerin sahiplerinin hangilerinin aynı 
firmada çalıştığını bulmak için nasıl bir yol izlersiniz?
*/

/*ÇÖZÜM:*/

/* 
Öncelikle verilerin saklandığı "firma_verileri" adlı bir schema oluşturuldu ve
içerisindeki tablo yapılarını aşağıdaki gibi oluşturdum. 
*/
create table employee(
	id_employee int not null auto_increment unique,
    name varchar(45) not null,
    surname varchar(45) not null,
    primary key (id_employee)
);

create table emails(
	id_email int not null auto_increment unique,
    id_employee int not null,
	email varchar(254) not null unique,
    primary key (id_email),
    foreign key (id_employee) references employee(id_employee) on delete cascade
);

/* ardından veriler tablolara yerleştiriliyor */
insert into employee (name, surname) values("deniz", "sezgin");
insert into employee (name, surname) values("kadir", "demir");
insert into employee (name, surname) values("ceyda", "taştan");
insert into employee (name, surname) values("ali", "demir");
insert into employee (name, surname) values("tamer", "kara");
insert into employee (name, surname) values("müge", "şen");

insert into emails (id_employee, email) values(1, "deniz@sadeyazilim.com");
insert into emails (id_employee, email) values(2, "kadir@SADEYAZILIM.COM");
insert into emails (id_employee, email) values(2, "kadir@afirma.com");
insert into emails (id_employee, email) values(3, "Ceyda@gmail.com");
insert into emails (id_employee, email) values(4, "ali@gmail.com");
insert into emails (id_employee, email) values(5, "tamer@sadeyazilim.com");
insert into emails (id_employee, email) values(6, "müge@testbank.com.tr");

/*öncelikle tüm email adreslerindeki karakterleri lowercase olacak şekilde düzenleniyor*/
update emails set email = LOWER(email);

/*
Ardından email adreslerinin alan adı kısmını ve local kısmını ve çalışan id'lerini
ayrıştırıyoruz. ve sonuçları domain ve çalışan id'lerine göre sıralıyoruz.

Bu şekilde hangi kullanıcıların aynı firmada çalıştığını tespit edebiliriz. 
*/
select id_employee, substring(email, 1, locate('@', email) - 1) as localpart,
       substring(email, locate('@', email) + 1) as domain
from emails order by domain, id_employee
