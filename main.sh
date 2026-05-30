#!/bin/bash

# Ezel Balım Atik

# 2420191017

# Sertifika Bağlantıları 

# 1. Docker Temelleri: https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=4qgueDkGLI

# 2. Siber Güvenlikte Linux İşletim Sistemleri: https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=qKrhe9Yl6G

# 3. Linux Bash Script Eğitimi: https://www.techcareer.net/certificates/validation/0e12cec3-1bc4-45a2-b80b-2476c1bfa5a2



# Rapor dosyasının adı
LOG_FILE="report.log"

# Script her çalıştığında eski raporu temizleyip yenisini başlatsın diye dosyayı boşaltıyoruz
> "$LOG_FILE"

# 1. ISO 8601 formatında tarih ve saat yazdırılması
echo "=== PROJE BAŞLANGIÇ TARİHİ VE SAATİ ===" >> "$LOG_FILE"
date --iso-8601=seconds >> "$LOG_FILE"
echo "----------------------------------------" >> "$LOG_FILE"

# 2. Bilgisayarın Donanım Bilgileri (Windows wmic ve getmac kullanımı)
echo "=== BİLGİSAYAR DONANIM BİLGİLERİ ===" >> "$LOG_FILE"

echo "[İşlemci Bilgisi]" >> "$LOG_FILE"
wmic cpu get Name /value | sed '/^$/d' >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "[RAM Bilgisi ve Kapasitesi]" >> "$LOG_FILE"
wmic memorychip get BankLabel, Capacity, Speed /value | sed '/^$/d' >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "[Anakart Bilgisi ve UUID Değeri]" >> "$LOG_FILE"
wmic baseboard get Product, Manufacturer /value | sed '/^$/d' >> "$LOG_FILE"
wmic csproduct get UUID /value | sed '/^$/d' >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "[Disk Bilgisi (Marka, Model, Seri Numara ve Kapasite)]" >> "$LOG_FILE"
wmic diskdrive get Model, Name, Size, SerialNumber /value | sed '/^$/d' >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "[MAC Adresi]" >> "$LOG_FILE"
getmac /fo list | sed '/^$/d' >> "$LOG_FILE"
echo "----------------------------------------" >> "$LOG_FILE"



# 3. Kullanıcıdan ekrana yazdırılmadan gizli bir kelime istenmesi
echo "Rapor güvenli bir şekilde şifrelenecek."
echo -n "Lütfen şifreleme için gizli kelimenizi (passphrase) girin: "
read -s SECRET_PHRASE
echo "" # Yeni satıra geçmek için

# 4. GPG ile Simetrik Şifreleme ve report.log.gpg dosyasının oluşturulması
# Kullanıcıdan alınan kelimeyi doğrudan gpg komutuna paslayarak etkileşimsiz şifreliyoruz
echo "$SECRET_PHRASE" | gpg --batch --yes --passphrase-fd 0 --symmetric --cipher-algo AES256 "$LOG_FILE"

# İşlem kontrolü
if [ -f "${LOG_FILE}.gpg" ]; then
    echo "Başarılı: '${LOG_FILE}.gpg' dosyası güvenli bir şekilde oluşturuldu!"
else
    echo "Hata: Şifreleme sırasında bir sorun oluştu!"
fi



