class AppUser {
  const AppUser({required this.uid, this.email, this.displayName, this.photoUrl});

  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  /// [displayName] if the user set one, else the local part of their email
  /// (Firebase leaves displayName null on fresh email/password sign-up,
  /// unlike the local/offline fallback which derives it), else 'Guest'.
  String get displayNameOrFallback {
    if (displayName != null && displayName!.isNotEmpty) return displayName!;
    if (email != null && email!.isNotEmpty) return email!.split('@').first;
    return 'Guest';
  }
}
