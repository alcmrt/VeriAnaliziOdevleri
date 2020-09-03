/*Veri Analizi Teknik ödev Soru-4*/

/*
Elimizde bazı okulların isimleri ve bulundukları mahallelerin olduğu bir liste mevcut. 
Başka bir listede ise il, bu illerdeki ilçeler ve bu ilçelerdeki mahalleleri 
bulunduran referans tablomuz var. Mahalle bilgisini ve bu referans tabloları kullanarak 
okulların hangi il ve ilçede olduklarını nasıl bulursunuz?
*/

/*ÇÖZÜM:*/

/* 
Referans tablolarını kullanarak verilerin saklandığı okul_verileri adlı bir schema ve tablo yapılarını 
MySQL yapısını aşağıdaki gibi oluşturdum. 
*/
create table sehirler(
	id_sehir int not null auto_increment unique,
    sehir_adi varchar(45) not null,
    primary key (id_sehir)
);

create table ilceler(
	id_ilce int not null auto_increment unique,
    id_sehir int not null,
	ilce_adi varchar(45) not null,
    primary key (id_ilce),
    foreign key (id_sehir) references sehirler(id_sehir) on delete cascade
);

create table mahalleler(
	id_mahalle int not null auto_increment unique,
    id_ilce int not null,
	mahalle_adi varchar(45) not null,
    primary key (id_mahalle),
    foreign key (id_ilce) references ilceler(id_ilce) on delete cascade
);

create table okullar(
	id_okul int not null auto_increment unique,
    id_mahalle int not null,
	okul_adi varchar(100) not null,
    primary key (id_okul),
    foreign key (id_mahalle) references mahalleler(id_mahalle) on delete cascade
);

/* ardından veriler tablolara yerleştiriliyor */
insert into sehirler (sehir_adi) values("ankara");
insert into sehirler (sehir_adi) values("istanbul");

insert into ilceler (id_sehir, ilce_adi) values(1, "çankaya");
insert into ilceler (id_sehir, ilce_adi) values(1, "altındağ");
insert into ilceler (id_sehir, ilce_adi) values(1, "etimesgut");
insert into ilceler (id_sehir, ilce_adi) values(2, "şişli");

insert into mahalleler (id_ilce, mahalle_adi) values(1, "kavaklıdere");
insert into mahalleler (id_ilce, mahalle_adi) values(1, "esat");
insert into mahalleler (id_ilce, mahalle_adi) values(1, "ayrancı");
insert into mahalleler (id_ilce, mahalle_adi) values(1, "cumhuriyet");
insert into mahalleler (id_ilce, mahalle_adi) values(4, "bozkurt");
insert into mahalleler (id_ilce, mahalle_adi) values(4, "eskişehir");
insert into mahalleler (id_ilce, mahalle_adi) values(4, "cumhuriyet");
insert into mahalleler (id_ilce, mahalle_adi) values(3, "eryaman");

insert into okullar (id_mahalle, okul_adi) values(1, "kavalkıdere iöo");
insert into okullar (id_mahalle, okul_adi) values(8, "etimesgut anadolu lisesi");
insert into okullar (id_mahalle, okul_adi) values(5, "cumhuriyet lisesi");
insert into okullar (id_mahalle, okul_adi) values(4, "zafer ilkokulu");

/*
tablo verilerini de yerleştirdikten sonra aşağıdaki sql sorgusu ile 
hangi okulun hangi mahalle, hangi ilçe ve hangi şehirde olduğunu
bulabiliriz
*/
select 
	okul_adi as okul, 
    mahalleler.mahalle_adi as mahalle, 
    ilceler.ilce_adi as ilce, 
    sehirler.sehir_adi as il 
from 
	okullar, 
    mahalleler, 
    ilceler, 
    sehirler
where 
	okullar.id_mahalle = mahalleler.id_mahalle 
		and 
	mahalleler.id_ilce = ilceler.id_ilce 
		and
	ilceler.id_sehir = sehirler.id_sehir;