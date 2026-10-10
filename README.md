# DevInfo

Application Flutter de lecture d’articles de développement, avec authentification Firebase, chargement des articles depuis DEV.to et sauvegarde locale.

Ce README relie chaque exigence fonctionnelle à son implémentation : fichier, lignes concernées et aperçu du code. Les numéros de ligne correspondent aux fichiers du dépôt au moment de la rédaction.

## Arborescence du projet

```text
devinfo_ffsc/
├── assets/
│   ├── fonts/
│   └── images/
├── lib/
│   ├── core/
│   │   ├── errors/                 # Exceptions, échecs et erreurs Firebase
│   │   ├── network/                # Client Dio, intercepteur et état réseau
│   │   ├── router/                 # Routes et navigation par onglets
│   │   ├── storage/                # Initialisation et cache Hive
│   │   ├── theme/                  # Thèmes clair et sombre
│   │   └── utils/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/               # Firebase, modèles et repository
│   │   │   ├── domain/             # Entité, contrat et cas d’utilisation
│   │   │   └── presentation/       # Pages, widgets et providers
│   │   └── news/
│   │       ├── data/               # API DEV.to, cache Hive et repository
│   │       ├── domain/             # Entité, contrat et cas d’utilisation
│   │       └── presentation/       # Pages, cartes et providers
│   ├── firebase_options.dart
│   └── main.dart                   # Initialisation et lancement
├── test/
│   └── features/
│       ├── auth/data/repositories/
│       └── news/data/repositories/
└── README.md
```

Les dossiers générés par Flutter et les fichiers natifs internes sont omis pour garder cette vue centrée sur l’organisation fonctionnelle du projet.

## Exigences du projet et preuves dans le code

### 1. Initialiser Firebase, Hive et l’application Flutter

**Fichier et lignes :** [`lib/main.dart`](lib/main.dart#L10-L14)  
**Aperçu :**

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: DevInfoApp()));
}
```

Hive enregistre le modèle des articles et ouvre une boîte typée pour les mettre en cache.

**Fichier et lignes :** [`lib/core/storage/hive_service.dart`](lib/core/storage/hive_service.dart#L8-L13)  
**Aperçu :**

```dart
await Hive.initFlutter();
Hive.registerAdapter(ArticleModelAdapter());
await Hive.openBox<ArticleModel>(articlesBoxName);
```

### 2. Créer un compte, se connecter et protéger les pages privées

La couche d’accès aux données utilise Firebase Authentication pour créer un compte et connecter un utilisateur.

**Fichier et lignes :** [`lib/features/auth/data/datasources/auth_datasource_impl.dart`](lib/features/auth/data/datasources/auth_datasource_impl.dart#L11-L26)  
**Aperçu :**

```dart
_firebaseAuth.createUserWithEmailAndPassword(
  email: email,
  password: password,
);

_firebaseAuth.signInWithEmailAndPassword(
  email: email,
  password: password,
);
```

Le routeur redirige un visiteur non connecté vers la connexion et un utilisateur connecté vers l’accueil.

**Fichier et lignes :** [`lib/core/router/app_router.dart`](lib/core/router/app_router.dart#L16-L28)  
**Aperçu :**

```dart
final bool isSignedIn = authState.value != null;
if (!isSignedIn && !isAuthRoute) {
  return '/sign-in';
}
if (isSignedIn && isAuthRoute) {
  return '/home';
}
```

### 3. Charger et afficher la liste des articles

La source distante récupère les articles francophones depuis l’API DEV.to.

**Fichier et lignes :** [`lib/features/news/data/datasources/article_remote_datasource_impl.dart`](lib/features/news/data/datasources/article_remote_datasource_impl.dart#L10-L13)  
**Aperçu :**

```dart
final response = await dio.get("/articles?tag=french");
final List list = response.data;
return list.map((json) => ArticleModel.fromJson(json)).toList();
```

Le repository met les résultats en cache et réutilise le cache si le réseau est absent ou si le chargement distant échoue.

**Fichier et lignes :** [`lib/features/news/data/repositories/article_repository_impl.dart`](lib/features/news/data/repositories/article_repository_impl.dart#L19-L32)  
**Aperçu :**

```dart
if (await networkInfo.isConnected) {
  try {
    final remoteArticles = await remoteDatasource.getArticles();
    await localDatasource.cachedArticles(remoteArticles);
    return remoteArticles.map((model) => model.toEntity()).toList();
  } catch (_) {
    final cachedArticles = await localDatasource.getCachedArticles();
    return cachedArticles.map((model) => model.toEntity()).toList();
  }
}
```

La page d’accueil présente les cartes, permet de réessayer en cas d’erreur et de rafraîchir la liste par glissement vers le bas.

**Fichier et lignes :** [`lib/features/news/presentation/pages/home_page.dart`](lib/features/news/presentation/pages/home_page.dart#L22-L55)  
**Aperçu :**

```dart
return RefreshIndicator(
  onRefresh: () => ref.read(newsNotifierProvider.notifier).refresh(),
  child: ListView.builder(
    itemCount: articleList.length,
    itemBuilder: (context, index) => ArticleCardWidget(
      article: articleList[index],
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPage(article: articleList[index]),
        ),
      ),
    ),
  ),
);
```

### 4. Lire le détail complet d’un article

Le détail est demandé séparément par identifiant. L’API DEV.to renvoie le contenu dans le champ `body_html`.

**Fichier et lignes :** [`lib/features/news/data/datasources/article_remote_datasource_impl.dart`](lib/features/news/data/datasources/article_remote_datasource_impl.dart#L17-L24)  
**Aperçu :**

```dart
final response = await dio.get('/articles/$articleId');
final content = response.data['body_html'];
if (content is! String || content.isEmpty) {
  throw const FormatException('Le contenu de l’article est indisponible.');
}
return content;
```

La page détail est défilable et rend le corps HTML avec `flutter_html`.

**Fichier et lignes :** [`lib/features/news/presentation/pages/detail_page.dart`](lib/features/news/presentation/pages/detail_page.dart#L14-L22), [`lib/features/news/presentation/pages/detail_page.dart`](lib/features/news/presentation/pages/detail_page.dart#L96)  
**Aperçu :**

```dart
final articleContent = ref.watch(articleContentProvider(article.id));
...
child: SingleChildScrollView(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [...],
  ),
),
...
data: (content) => Html(data: content),
```

### 5. Naviguer entre les sections principales

La navigation principale regroupe les écrans Article, Vidéo et Profil. `IndexedStack` conserve leur état lors du changement d’onglet.

**Fichier et lignes :** [`lib/core/router/bottom_nav_bar.dart`](lib/core/router/bottom_nav_bar.dart#L14-L20), [`lib/core/router/bottom_nav_bar.dart`](lib/core/router/bottom_nav_bar.dart#L40-L53)  
**Aperçu :**

```dart
final List<Widget> _screens = [
  const HomePage(),
  const VideoPage(),
  const ProfilePage(),
];

body: IndexedStack(index: _currentIndex, children: _screens),
bottomNavigationBar: BottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) {
    setState(() {
      _currentIndex = index;
    });
  },
  items: _items,
),
```

La page Vidéo est pour l’instant un écran placeholder ; la navigation vers celle-ci existe, mais sa fonctionnalité reste à développer.

### 6. Consulter son profil et se déconnecter

La page Profil lit l’utilisateur depuis le flux d’authentification et propose une déconnexion confirmée.

**Fichier et lignes :** [`lib/features/news/presentation/pages/profile_page.dart`](lib/features/news/presentation/pages/profile_page.dart#L52-L60), [`lib/features/news/presentation/pages/profile_page.dart`](lib/features/news/presentation/pages/profile_page.dart#L115-L139)  
**Aperçu :**

```dart
final authState = ref.watch(authStateChangesProvider);
...
Card(
  child: ListTile(
    title: const Text('Adresse e-mail'),
    subtitle: Text(user.email),
  ),
),
...
await ref.read(signOutUseCaseProvider).call();
```

### 7. Vérifier la couche repository d’authentification

Trois tests couvrent la connexion réussie, l’inscription réussie et la conversion d’une erreur Firebase en exception applicative.

**Fichier et lignes :** [`test/features/auth/data/repositories/auth_repository_impl_test.dart`](test/features/auth/data/repositories/auth_repository_impl_test.dart#L18-L91)  
**Aperçu :**

```dart
test('la connexion renvoie l’utilisateur authentifié', () async { ... });
test('l’inscription renvoie l’utilisateur créé', () async { ... });
test('la connexion convertit une erreur Firebase en ServerException', () { ... });
```

## Lancer le projet

Prérequis : Flutter et un projet Firebase configuré pour les plateformes ciblées. Les options Firebase de la plateforme sont référencées par `lib/firebase_options.dart`.

```bash
flutter pub get
flutter run
```

## Lancer les tests

```bash
flutter test
```

Pour exécuter uniquement les tests du repository d’authentification :

```bash
flutter test test/features/auth/data/repositories/auth_repository_impl_test.dart
```

## Technologies principales

- Flutter et Dart
- Firebase Authentication
- Riverpod pour la gestion d’état et l’injection des dépendances
- Dio pour les requêtes HTTP
- Hive pour le cache local des articles
- DEV.to API pour les articles
- `flutter_html` pour l’affichage du contenu HTML des articles
