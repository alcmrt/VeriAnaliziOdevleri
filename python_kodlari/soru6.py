"""
Veri Analizi Teknik Ödev Soru6:

Bir adres verisi içinde, farklı yerlerde kimlik numarası bilgisi de bulunmaktadır.
Bu bilgiyi adres bilgisinden nasıl ayırıp ikisini de ayrı yazarsınız?
"""

import pandas as p

"""
ÇÖZÜM:
"""

# Adreslerin text dosyasından okunduğunu varsayarak çözümü bu şekilde gerçekleştirdim.
# Öncelikle .txt dosyasından adresleri okuyoruz:
data_frame = p.read_csv("./veriler/adresler.txt")

# TC kimlik numaraları 11 haneli olduğundan adres içerisindeki 11 haneli sayıları
# regular expression yardımı ile ayırıp data frame içerisinde tc_numaraları adlı
# sütün altına ekliyoruz.
data_frame["tc_numaralari"] = data_frame.adresler.str.extract(".*\\b(\\d{11})\\b.*")

# ardından adresler kısmından benzer şekilde 11 haneli sayıları çıkarıyoruz.
data_frame["adresler"] = data_frame["adresler"].replace("\\b(\\d{11})", "", regex=True)

# elde ettiğimiz sonucu bu şekilde gösterebiliriz
print(data_frame)
