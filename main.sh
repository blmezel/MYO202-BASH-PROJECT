#!/bin/bash

# EZEL BALIM ATİK
# 2420191017
# Sertifika Bağlantıları:
# 1. Docker Temelleri: https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=4qgueDkGLI
# 2. Siber Güvenlikte Linux İşletim Sistemleri: https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=qKrhe9Yl6G
# 3. Linux Bash Script Eğitimi: https://credsverse.com/credentials/0e12cec3-1bc4-45a2-b80b-2476c1bfa5a2

LOG_FILE="report.log"

# Her çalıştığında eski raporu temizlesin
> "$LOG_FILE"

# 1. ISO 8601 formatında tarih ve saat yazdırılması
echo "=== PROJE BAŞLANGIÇ TARİHİ VE SAATİ ===" >> "$LOG_FILE"
date --iso-8601=seconds >> "$LOG_FILE"
echo "----------------------------------------" >> "$LOG_FILE"

echo "=== BİLGİSAYAR DONANIM BİLGİLERİ ===" >> "$LOG_FILE"

# 2. İşlemci - Marka Model Bilgisi
echo "[İşlemci Bilgisi]" >> "$LOG_FILE"
wmic cpu get name >> "$LOG_FILE"

# 3. RAM - Üretici, Model, Parça Numarası, Seri No, Kapasite Bilgisi
echo "[RAM Bilgisi]" >> "$LOG_FILE"
wmic memorychip get manufacturer, model, partnumber, serialnumber, capacity >> "$LOG_FILE"

# 4. Anakart - Üretici, Model, Seri No ve UUID Bilgisi
echo "[Anakart Bilgisi]" >> "$LOG_FILE"
wmic baseboard get manufacturer, product, serialnumber >> "$LOG_FILE"
wmic csproduct get uuid >> "$LOG_FILE"

# 5. Disk - Marka, Model, Seri No, Kapasite Bilgisi (UUID OLMADAN)
echo "[Disk Bilgisi]" >> "$LOG_FILE"
wmic diskdrive get manufacturer, model, serialnumber, size >> "$LOG_FILE"

# 6. MAC Bilgisi
echo "[MAC Adresi]" >> "$LOG_FILE"
getmac >> "$LOG_FILE"
echo "----------------------------------------" >> "$LOG_FILE"

# 7. HOCANIN ZORUNLU TUTTUĞU PAROLA (Sıfır Hata İçin Otomatik Tanımlandı)
PAROLA="MYO+202"

# 8. GPG ile AES256 şifreleme (Arka planda hocanın tam açabileceği standart formatta)
echo "$PAROLA" | gpg --batch --yes --passphrase-fd 0 --cipher-algo AES256 -c "$LOG_FILE"

# 9. Şifresiz orijinal raporun otomatik silinmesi
if [ -f report.log.gpg ]; then
    rm -f "$LOG_FILE"
fi