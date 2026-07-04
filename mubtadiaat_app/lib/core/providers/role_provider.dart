import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppRole {
  admin,
  mustahiq,
  mufattish,
  mundzir
}

extension AppRoleExtension on AppRole {
  String get name {
    switch (this) {
      case AppRole.admin: return 'Software Admin';
      case AppRole.mustahiq: return 'Mustahiq (Guru)';
      case AppRole.mufattish: return 'Mufattish';
      case AppRole.mundzir: return 'Mundzir (Kepala Madrasah)';
    }
  }
}

class RoleNotifier extends StateNotifier<AppRole> {
  RoleNotifier() : super(AppRole.admin);

  void setRole(AppRole role) {
    state = role;
  }
}

final roleProvider = StateNotifierProvider<RoleNotifier, AppRole>((ref) {
  return RoleNotifier();
});
