/// Kumpulan fungsi validasi dan sanitasi input.
class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phoneRegex = RegExp(r'^[0-9]{10,13}$');
  static final RegExp _urlRegex = RegExp(r'^https?://[^\s/$.?#][^\s]*$');
  static final RegExp _upperRegex = RegExp(r'[A-Z]');
  static final RegExp _digitRegex = RegExp(r'[0-9]');
  static final RegExp _symbolRegex = RegExp(r'[^A-Za-z0-9\s]');

  /// Memvalidasi format email.
  static bool isValidEmail(String email) => _emailRegex.hasMatch(email);

  /// Memvalidasi bahwa [value] tidak kosong.
  static bool isNotEmpty(String? value) =>
      value != null && value.trim().isNotEmpty;

  /// Memvalidasi panjang [value] antara [min] dan [max].
  static bool hasValidLength(String value, {int min = 1, int max = 100}) {
    final length = value.trim().length;
    return length >= min && length <= max;
  }

  /// Membersihkan input dari karakter berbahaya (mencegah XSS).
  ///
  /// `&` diganti pertama agar entity hasil penggantian tidak ter-escape dua kali.
  static String sanitize(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;')
        .trim();
  }

  /// Memvalidasi teks. Mengembalikan pesan error atau `null` jika valid.
  static String? validateText(
    String? value, {
    String fieldName = 'Field',
    int minLength = 1,
    int maxLength = 100,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    if (!hasValidLength(value, min: minLength, max: maxLength)) {
      return '$fieldName harus antara $minLength-$maxLength karakter';
    }
    return null;
  }

  /// Memvalidasi email. Mengembalikan pesan error atau `null` jika valid.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!isValidEmail(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // ===================== Latihan 3 =====================

  /// Memvalidasi nomor telepon: hanya angka, 10-13 digit.
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (!_phoneRegex.hasMatch(value.trim())) {
      return 'Nomor telepon harus berupa angka 10-13 digit';
    }
    return null;
  }

  /// Memvalidasi URL: harus diawali http:// atau https://.
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL tidak boleh kosong';
    }
    if (!_urlRegex.hasMatch(value.trim())) {
      return 'URL harus diawali http:// atau https://';
    }
    return null;
  }

  /// Memvalidasi password: minimal 8 karakter, ada huruf kapital,
  /// angka, dan simbol. Password tidak di-trim agar spasi tetap dihitung.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!_upperRegex.hasMatch(value)) {
      return 'Password harus mengandung huruf kapital';
    }
    if (!_digitRegex.hasMatch(value)) {
      return 'Password harus mengandung angka';
    }
    if (!_symbolRegex.hasMatch(value)) {
      return 'Password harus mengandung simbol';
    }
    return null;
  }
}