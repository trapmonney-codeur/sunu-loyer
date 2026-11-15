/// Photos de remplissage, en attendant un hébergeur d'images.
/// Avec la même `graine`, on obtient toujours les mêmes photos.
List<String> imagesDemo(String graine, {int nombre = 3}) {
  return List.generate(
    nombre,
    (index) => 'https://picsum.photos/seed/$graine-$index/800/600',
  );
}
