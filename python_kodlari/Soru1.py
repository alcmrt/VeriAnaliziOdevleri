"""
Veri Analizi Teknik Ödev Soru1:

Bir banka müşterilerine ait 3 milyon telefon numarası verisini bir text dosyasında veriyor ve
bizden telefonların sabit hat mı, cep telefonu hattı mı olduğunu, sabit hat ise hangi şehre ait olduğunu
bulmamızı istiyor. Görevin yerine getirilmesi için nasıl bir yol izlersiniz?
"""

import pandas as p

"""
ÇÖZÜM:
"""

# Öncelikle .txt dosyasından telefon numaralarını okuyoruz:
data_frame = p.read_csv("./veriler/telefonlar.txt")

# Müşteri numaralarını telefon numaralarından regular expression yardımı ile ayırıyoruz
data_frame["telefon"] = data_frame["MUSTERI NO  TELEFON"].str.split("[ \t]{2,}").str[-1].str.strip()
data_frame = data_frame[["telefon"]]

# Ardından telefon numaraları arasındaki boşlukları çıkarıyoruz ve elimizde sadece telefon numaraları kalıyor.
data_frame = data_frame.replace(to_replace=" +", value="", regex=True)

## Adım-1: Öncelikle telefon numaralarının başındaki "+90" şeklinde olan '0', '9', '+'
# karakterterlerini temizlememiz gerekir:

# 1a) Öncelikle numaraların başındaki '0' karakterini atıyoruz
data_frame = data_frame.replace(to_replace="^0", value="", regex=True)

# 1b) Daha Sonra numaraların başında varsa "+90" ibaresini çıkarıyoruz
data_frame = data_frame.replace(to_replace="^[+]90", value="", regex=True)

## Adım-2: Telefon numaraları düzenlendikten sonra uzunluklarının 10 haneli olması gerekiyor.
# karakter sayısı eksik olan numaralar için kesin bir tespit yapamayız. Bu numaraları veri içerisinden temizliyoruz.
# önce telefon numaralarının hane sayısı tespit ediliyor.
data_frame["uzunluk"] = data_frame["telefon"].str.len()

#daha sonra uzunluk 10 karakterden kısa olan satırlar veriden çıkarılıyor.
# önce uzunluğu 10 dan küçük olan satırların indexleri tespit ediliyor
# daha sonra bu satırlar veri içerisinden çıkarılıyor.
index_names = data_frame[data_frame["uzunluk"] < 10].index
data_frame.drop(index_names, inplace=True)

## Adım-3: Kalan numaralar '5' karakteri ile başlıyorsa cep telefonu hattı olduğunu anlıyoruz. aksi takdirde
# il alan kodlarının bulunduğu look up tablosundan ilk 3 karakteri karşılaştırıp numaraların
# hangi ile ait olduğunu buluyoruz.

data_frame["kod"] = data_frame["telefon"].astype(str).str[0:3]  # alan kodu çıkarılıyor

# il alan kodları için lookup tablosu oluşturuluyor
look_up_table = p.read_csv("./veriler/il_alan_kodlari.csv").astype(str)

# sabit hatların hangi ile ait olduğunu left join yaparak buluyoruz
data_frame = p.merge(data_frame, look_up_table, on="kod", how="left")

# ardından eğer alan kodu '5' karakteri ile başlıyorsa kategorisini "cep" olarak kaydediyoruz
data_frame.loc[data_frame["kod"].astype(str).str[0] == "5", "il"] = "cep"

# sonuç olarak elimizde veritabanına kaydetmek üzere bu şekilde bir tablo kalıyor
print(data_frame)
print()

"""
Sonuç:

Buradaki 3 milyonuluk telefon verisini, text dosyasından parça parça okuyarak 
daha küçük parçalara bölüp threadler halinde yukarıdaki mantıkla işleyebiliriz.
"""