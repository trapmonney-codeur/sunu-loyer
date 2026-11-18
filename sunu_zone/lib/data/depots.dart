import 'package:sunu_zone/data/admin_repository.dart';
import 'package:sunu_zone/data/firestore_admin_repository.dart';

import 'annonce_repository.dart';
import 'auth_service.dart';
import 'firebase_auth_service.dart';
import 'firestore_annonce_repository.dart';

/// Seul endroit qui choisit les implémentations utilisées par l'application.
final AnnonceRepository annonceRepository = FirestoreAnnonceRepository();
final AuthService authService = FirebaseAuthService();

final AdminRepository adminRepository = FirestoreAdminRepository();
