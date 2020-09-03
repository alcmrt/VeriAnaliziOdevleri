/*Veri Analizi Teknik ödev Soru-5*/

/*
Bir bankanın veri tabanı tablosunda (örneğin Oracle) müşteri isimleri ve 
müşterilerin kimlik numaraları var. 

Fakat bazı kimlik numaraları aynı olmasına rağmen müşteri isimleri farklı. 
Bu durumdaki kayıtları nasıl bir sorgu ile bulursunuz?
*/

/*
ÇÖZÜM:

Varsayım:
Bir kişinin birden fazla banka hesabı olabilir. 
Bu durumda banka hesap numarası her zaman veritabanında unique olarak tutulmak zorundadır.

Bu sebeple "banka_hesap_verileri" adlı bir schema oluşturduktan sonra 
veritabanı tablosunun aşağıdaki gibi olabileceğini varsaydım.
*/

create table banka_hesabi(
	id_hesap int not null auto_increment unique,
    tckn varchar(11) not null,
    ad varchar(45) not null,
    primary key (id_hesap)
);

/*ardından tablo verileri dolduruldu*/
insert into banka_hesabi (tckn, ad) values("71824829102", "ali");
insert into banka_hesabi (tckn, ad) values("12381949284", "ali");
insert into banka_hesabi (tckn, ad) values("71824829102", "ali");
insert into banka_hesabi (tckn, ad) values("59382838321", "ahmet");
insert into banka_hesabi (tckn, ad) values("71824829102", "mehmet");


/*
Ardından veri tabanına aşağıdaki sorguyu atıp ad ve tc numarasına göre
gruplandırdığımızda aynı kimlik numarasına sahip farklı isimleri görebiliriz.
*/
select count(tckn) as toplam_tckn, tckn, count(ad) as ad_sayisi, ad
from banka_hesabi
group by ad, tckn
having count(tckn) > 0 order by tckn;
