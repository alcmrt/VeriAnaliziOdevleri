/*Veri Analizi Teknik ödev Soru-3*/

/* 
Bankada veri tabanında müşterilerin adresleri, iş adresi ve ev adresi olarak tutulmaktadır. 
Bazı müşteriler yazım farkları olsa da iş ve ev adresi olarak aynı adresi vermişlerdir. 
İş ve ev adresi aynı olan müşterileri nasıl bulursunuz? 
*/

/*ÇÖZÜM:*/

/*
Öncelikle "banka_verileri" adlı bir schema yaratıp 
MySQL veritabanı yapısını aşağıdaki gibi oluşturup veriler dolduruluyor.
*/

create table customers(
	id int not null auto_increment unique,
    name varchar(45) not null,
    surname varchar(45) not null,
    primary key (id)
);
create table adres(
	id_adres int not null auto_increment unique,
    id_customer int not null,
    is_adresi varchar(100) not null,
    ev_adresi varchar(100) not null,
    primary key (id_adres),
    foreign key (id_customer) references customers(id) on delete cascade
);

/*********************************************************************************/

/*veriler tablolara yerleştiriliyor*/
insert into customers (name, surname) values("veli", "sezgin");
insert into customers (name, surname) values("ali", "demir");
insert into customers (name, surname) values("mehmet", "taştan");

insert into adres (id_customer, is_adresi, ev_adresi) 
	values(1, "Tugay Yolu Cad. No:60 Maltepe", "Tugay Yolu Caddesi No60 MALTEPE");
insert into adres (id_customer, is_adresi, ev_adresi) 
	values(2, "İnkılap Mah. Küçüksu Cd. No 6 Ümraniye", "İnkılap Mahallesi Küçüksu Caddesi No 6 Ümraniye");
insert into adres (id_customer, is_adresi, ev_adresi) 
	values(3, "Soğanlık Mah. Muş Sk. No 63 Kartal", "Soğanlık Mah. Muş Sk. No 61 Kartal");

/************************************************************************************/

/*daha sonra adres verileri hepsi küçük harf olacak şekilde düzenleniyor.*/
update adres set is_adresi = LOWER(is_adresi);
update adres set ev_adresi = LOWER(ev_adresi);

/* 
ardından adres içeriği

mah. -> mahallesi
cad. -> caddesi
sk.  -> sokak

olacak şekilde yeniden düzenleniyor.
*/
update adres set is_adresi = replace(is_adresi, "mah.", "mahallesi")
	where is_adresi like "%mah.%";
update adres set ev_adresi = replace(ev_adresi, "mah.", "mahallesi")
	where ev_adresi like "%mah.%";
    
update adres set is_adresi = replace(is_adresi, "cad.", "caddesi")
	where is_adresi like "%cad.%";
update adres set ev_adresi = replace(ev_adresi, "cad.", "caddesi")
	where ev_adresi like "%cad.%";

update adres set is_adresi = replace(is_adresi, "cd.", "caddesi")
	where is_adresi like "%cd.%";
update adres set ev_adresi = replace(ev_adresi, "cd.", "caddesi")
	where ev_adresi like "%cd.%";

/* adres içerisindeki ":" karakteri "" ile değiştiriliyor */
update adres set is_adresi = replace(is_adresi, ":", "");
update adres set ev_adresi = replace(ev_adresi, ":", "");

/* "no" string inden sonra bir boşluk bırakıyoruz */
update adres set is_adresi = replace(is_adresi, "no", "no ");
update adres set ev_adresi = replace(ev_adresi, "no", "no ");

/*
adreste arka arkaya birden fazla space karakteri varsa 
tek space karakteri olacak şekilde adresi düzenliyoruz.
*/
update adres set is_adresi = replace(replace(is_adresi, '  ', ' '), '  ', ' ');
update adres set ev_adresi = replace(replace(ev_adresi, '  ', ' '), '  ', ' ');

/*ardından ev ve iş adresi aynı olan kullanıcıların id'lerini tespit ediyoruz*/
select id_customer, is_adresi, ev_adresi from adres
	where is_adresi = ev_adresi;
