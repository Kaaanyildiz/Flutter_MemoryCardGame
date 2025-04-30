# Katkıda Bulunma Rehberi

Bu belge, Memory Match Game projesine nasıl katkıda bulunabileceğiniz hakkında bilgiler sunar.

## Geliştirme İş Akışı

1. Projeyi forklayın
2. Kendi feature branch'inizi oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'feat: add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Bir Pull Request açın

## Commit Mesaj Formatı

Bu proje için [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) standartlarını kullanıyoruz:

- `feat: `: Yeni özellikler
- `fix: `: Hata düzeltmeleri
- `docs: `: Sadece dokümantasyon değişiklikleri
- `style: `: Kodun anlam değiştirmeyen değişiklikler (format, boşluk vb.)
- `refactor: `: Hata düzeltmeyen ve özellik eklemeyen kod değişiklikleri
- `perf: `: Performans iyileştirmeleri
- `test: `: Test ekleme veya düzeltme
- `build: `: Yapı sistemini veya harici bağımlılıkları etkileyen değişiklikler
- `ci: `: CI yapılandırma dosyaları ve komut dosyalarındaki değişiklikler

## Kod Stili

- Flutter/Dart için [Effective Dart](https://dart.dev/guides/language/effective-dart) kurallarına uyun
- Kodunuzun Flutter lint kurallarını (analysis_options.yaml) geçtiğinden emin olun

## Pull Request Süreci

1. PR açmadan önce kodunuzun tüm testlerden geçtiğinden emin olun
2. PR'ınızda yapılan değişiklikleri açık bir şekilde açıklayın
3. Belgelerinizi güncelleyin
4. PR'ınızda gerekli CI kontrollerinin başarılı olduğundan emin olun

## Testler

Yeni bir özellik eklerken veya bir hata düzeltirken test ekleyin. Yüksek test kapsamı projenin kalitesini korumamıza yardımcı olur.

## Lisans

Bu projeye katkıda bulunarak, katkılarınızın projenin MIT lisansı altında lisanslanmasını kabul edersiniz.