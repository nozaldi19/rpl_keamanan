import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_keamanan/utils/validators.dart';
// Ganti 'rpl_keamanan' dengan nama package di pubspec.yaml (mis. secure_http).

void main() {
  group('isValidEmail', () {
    test('menerima email valid', () {
      expect(Validators.isValidEmail('budi@amikom.ac.id'), isTrue);
      expect(Validators.isValidEmail('a.b+c@mail.co'), isTrue);
    });

    test('menolak email tanpa @', () {
      expect(Validators.isValidEmail('budi.amikom.ac.id'), isFalse);
    });

    test('menolak email tanpa domain/titik', () {
      expect(Validators.isValidEmail('budi@amikom'), isFalse);
    });

    test('menolak email tanpa nama lokal', () {
      expect(Validators.isValidEmail('@amikom.ac.id'), isFalse);
    });

    test('menolak email mengandung spasi atau string kosong', () {
      expect(Validators.isValidEmail('bu di@amikom.ac.id'), isFalse);
      expect(Validators.isValidEmail(''), isFalse);
    });
  });

  group('sanitize', () {
    test('meng-escape tag script', () {
      expect(
        Validators.sanitize('<script>alert("xss")</script>'),
        '&lt;script&gt;alert(&quot;xss&quot;)&lt;/script&gt;',
      );
    });

    test('meng-escape petik tunggal', () {
      expect(Validators.sanitize("O'Reilly"), 'O&#39;Reilly');
    });

    test('meng-escape ampersand lebih dulu', () {
      expect(Validators.sanitize('a & b'), 'a &amp; b');
      expect(Validators.sanitize('<'), '&lt;');
    });

    test('menghapus spasi di awal dan akhir', () {
      expect(Validators.sanitize('  halo  '), 'halo');
    });

    test('input aman tidak berubah', () {
      expect(Validators.sanitize('Budi Santoso'), 'Budi Santoso');
    });

    test('hasil tidak mengandung karakter < > " \'', () {
      final out = Validators.sanitize('<img src="x" onerror=\'a()\'>');
      expect(out.contains(RegExp('[<>"\']')), isFalse);
    });
  });

  group('validateText', () {
    test('null dan string kosong ditolak', () {
      expect(Validators.validateText(null, fieldName: 'Nama'),
          'Nama tidak boleh kosong');
      expect(Validators.validateText('   ', fieldName: 'Nama'),
          'Nama tidak boleh kosong');
    });

    test('panjang valid mengembalikan null', () {
      expect(Validators.validateText('Budi'), isNull);
    });

    test('tepat di batas maksimal diterima', () {
      expect(Validators.validateText('a' * 100), isNull);
    });

    test('melebihi batas maksimal ditolak', () {
      expect(
        Validators.validateText('a' * 101, fieldName: 'Nama'),
        'Nama harus antara 1-100 karakter',
      );
    });

    test('kurang dari minimal ditolak', () {
      expect(
        Validators.validateText('ab', fieldName: 'Kode', minLength: 3),
        'Kode harus antara 3-100 karakter',
      );
    });
  });

  // Tambahan untuk Latihan 3
  group('validatePhone', () {
    test('valid 10-13 digit', () {
      expect(Validators.validatePhone('0812345678'), isNull);
      expect(Validators.validatePhone('0812345678901'), isNull);
    });
    test('terlalu pendek/panjang atau mengandung huruf ditolak', () {
      expect(Validators.validatePhone('081234'), isNotNull);
      expect(Validators.validatePhone('08123456789012'), isNotNull);
      expect(Validators.validatePhone('08123abc789'), isNotNull);
    });
  });

  group('validateUrl', () {
    test('http dan https diterima', () {
      expect(Validators.validateUrl('https://amikom.ac.id'), isNull);
      expect(Validators.validateUrl('http://localhost:8080/api'), isNull);
    });
    test('tanpa skema atau skema lain ditolak', () {
      expect(Validators.validateUrl('amikom.ac.id'), isNotNull);
      expect(Validators.validateUrl('ftp://amikom.ac.id'), isNotNull);
    });
  });

  group('validatePassword', () {
    test('password kuat diterima', () {
      expect(Validators.validatePassword('Abcdef1!'), isNull);
    });
    test('password lemah ditolak', () {
      expect(Validators.validatePassword('Ab1!'), isNotNull); // pendek
      expect(Validators.validatePassword('abcdefg1!'), isNotNull); // no kapital
      expect(Validators.validatePassword('Abcdefgh!'), isNotNull); // no angka
      expect(Validators.validatePassword('Abcdefg12'), isNotNull); // no simbol
    });
  });
}