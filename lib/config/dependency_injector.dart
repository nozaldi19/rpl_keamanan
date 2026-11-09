import 'package:flutter/widgets.dart';
import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../services/api_service.dart';

/// Penyedia dependency sederhana (service locator + singleton).
///
/// [ApiService] dibuat sebagai singleton sehingga seluruh repository
/// berbagi satu instance (dan satu http.Client).
class DependencyInjector {
  DependencyInjector._internal();

  static final DependencyInjector _instance = DependencyInjector._internal();

  /// Instance tunggal [DependencyInjector].
  static DependencyInjector get instance => _instance;

  late final ApiService apiService = ApiService();

  late final UserRepository userRepository =
      UserRepositoryImpl(apiService: apiService);

  late final PostRepository postRepository =
      PostRepositoryImpl(apiService: apiService);

  /// Melepas resource yang digunakan.
  void dispose() => apiService.dispose();
}

/// [InheritedWidget] untuk menyediakan [DependencyInjector] ke widget tree.
class DependencyProvider extends InheritedWidget {
  final DependencyInjector injector;

  const DependencyProvider({
    super.key,
    required this.injector,
    required super.child,
  });

  /// Mengambil [DependencyInjector] terdekat.
  ///
  /// Memakai getInheritedWidgetOfExactType agar aman dipanggil di initState.
  static DependencyInjector of(BuildContext context) {
    final provider =
        context.getInheritedWidgetOfExactType<DependencyProvider>();
    assert(provider != null, 'DependencyProvider tidak ada di widget tree');
    return provider!.injector;
  }

  @override
  bool updateShouldNotify(DependencyProvider oldWidget) =>
      injector != oldWidget.injector;
}