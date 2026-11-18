import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sunu_zone/data/depots.dart';
import 'package:sunu_zone/features/admin/admin_page.dart';
import 'package:sunu_zone/features/home/home_page.dart';
import 'package:sunu_zone/features/mes_annonces/mes_annonces.dart';
import 'package:sunu_zone/features/profile_page/profil_page.dart';
import 'package:sunu_zone/models/utilisateur.dart';

/// Suit la session : à chaque connexion ou déconnexion, la navigation
/// est reconstruite pour l'utilisateur concerné.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late final Stream<Utilisateur?> _session = authService.changements;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Utilisateur?>(
      stream: _session,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final utilisateur = snapshot.data;
        return _Navigation(
          key: ValueKey(utilisateur?.id),
          utilisateur: utilisateur,
        );
      },
    );
  }
}

class _Navigation extends StatefulWidget {
  const _Navigation({super.key, required this.utilisateur});

  final Utilisateur? utilisateur;

  @override
  State<_Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<_Navigation> {
  static const _indexAdmin = 3;

  int _indexActuel = 0;
  bool _estAdmin = false;
  int _nbEnAttente = 0;

  StreamSubscription<bool>? _abonnementRole;
  StreamSubscription<int>? _abonnementAttente;

  @override
  void initState() {
    super.initState();

    final utilisateur = widget.utilisateur;
    if (utilisateur == null) return;

    _abonnementRole = adminRepository
        .estAdministrateur(utilisateur.id)
        .listen(
          _surRoleAdmin,
          onError: (Object erreur) {
            debugPrint('Lecture du rôle administrateur : $erreur');
          },
        );
  }

  void _surRoleAdmin(bool estAdmin) {
    if (!mounted) return;

    final devientAdmin = estAdmin && !_estAdmin;
    if (devientAdmin) {
      _suivreAnnoncesEnAttente();
    } else if (!estAdmin) {
      _arreterSuivi();
    }

    setState(() {
      if (devientAdmin) {
        // Un administrateur arrive directement sur l'administration.
        _indexActuel = _indexAdmin;
      } else if (!estAdmin && _indexActuel == _indexAdmin) {
        _indexActuel = 0;
      }
      _estAdmin = estAdmin;
    });
  }

  void _suivreAnnoncesEnAttente() {
    _abonnementAttente?.cancel();
    _abonnementAttente = adminRepository
        .annoncesEnAttente()
        .map((annonces) => annonces.length)
        .listen(
          (nombre) {
            if (mounted) setState(() => _nbEnAttente = nombre);
          },
          onError: (Object erreur) {
            debugPrint('Annonces en attente : $erreur');
          },
        );
  }

  void _arreterSuivi() {
    _abonnementAttente?.cancel();
    _abonnementAttente = null;
    _nbEnAttente = 0;
  }

  @override
  void dispose() {
    _abonnementRole?.cancel();
    _abonnementAttente?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const HomePage(),
      const MesAnnoncesPage(),
      const ProfilPage(),
      if (_estAdmin) const AdminPage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _indexActuel, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexActuel,
        onDestinationSelected: (index) {
          setState(() => _indexActuel = index);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          const NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Mes annonces',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
          if (_estAdmin)
            NavigationDestination(
              icon: _IconeAdmin(nombre: _nbEnAttente, selectionne: false),
              selectedIcon: _IconeAdmin(
                nombre: _nbEnAttente,
                selectionne: true,
              ),
              label: 'Admin',
            ),
        ],
      ),
    );
  }
}

/// Icône de l'onglet Admin, avec une pastille quand il y a du travail.
class _IconeAdmin extends StatelessWidget {
  const _IconeAdmin({required this.nombre, required this.selectionne});

  final int nombre;
  final bool selectionne;

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: nombre > 0,
      label: Text(nombre > 99 ? '99+' : '$nombre'),
      child: Icon(
        selectionne
            ? Icons.admin_panel_settings
            : Icons.admin_panel_settings_outlined,
      ),
    );
  }
}
