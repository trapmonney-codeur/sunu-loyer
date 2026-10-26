import '../models/annonces.dart';

const List<Annonce> annoncesDemo = [
  Annonce(
    id: '1',
    type: 'Appartement',
    nbPieces: 3,
    surfaceM2: 85,
    prix: 350000,
    quartier: 'Dakar Plateau',
    images: [
      'https://picsum.photos/seed/sunu1a/800/600',
      'https://picsum.photos/seed/sunu1b/800/600',
      'https://picsum.photos/seed/sunu1c/800/600',
      'https://picsum.photos/seed/sunu1d/800/600',
    ],
    description:
        'Appartement lumineux au 2ᵉ étage, proche des commerces et des '
        'transports. Salon spacieux, cuisine équipée, deux chambres avec '
        'placards, eau courante et électricité.',
    proprietaire: 'Awa Diallo',
    telephone: '221770000001',
  ),
  Annonce(
    id: '2',
    type: 'Villa',
    nbPieces: 5,
    surfaceM2: 220,
    prix: 750000,
    quartier: 'Almadies, Dakar',
    images: [
      'https://picsum.photos/seed/sunu2a/800/600',
      'https://picsum.photos/seed/sunu2b/800/600',
      'https://picsum.photos/seed/sunu2c/800/600',
    ],
    description:
        'Villa de standing avec jardin clôturé et parking pour deux '
        'véhicules. Quartier calme et sécurisé, cuisine américaine, '
        'trois salles de bain.',
    proprietaire: 'Ibrahima Faye',
    telephone: '221770000002',
  ),
  Annonce(
    id: '3',
    type: 'Studio',
    nbPieces: 1,
    surfaceM2: 28,
    prix: 90000,
    quartier: 'Diass',
    images: ['https://picsum.photos/seed/sunu3a/800/600'],
    description:
        'Studio indépendant idéal pour une personne seule ou un étudiant. '
        'Douche et toilettes privées, compteur individuel, accès facile '
        'à la route principale.',
    proprietaire: 'Mariama Sow',
    telephone: '221770000003',
  ),
];
