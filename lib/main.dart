import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'shared/presentation/pages/home/home_page.dart';

// Auth Feature
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/edit_profile_page.dart';

// Event Feature
import 'features/event/data/datasources/event_remote_datasource.dart';
import 'features/event/data/repositories/event_repository_impl.dart';
import 'features/event/presentation/providers/event_provider.dart';

// Museum Feature
import 'features/museum/data/datasources/museum_remote_datasource.dart';
import 'features/museum/data/repositories/museum_repository_impl.dart';
import 'features/museum/presentation/providers/museum_provider.dart';

// Article Feature
import 'features/article/data/datasources/article_remote_datasource.dart';
import 'features/article/data/repositories/article_repository_impl.dart';
import 'features/article/presentation/providers/article_provider.dart';
import 'features/article/presentation/pages/article_form_page.dart';

// Comment & Rating Features
import 'shared/data/datasources/comment_remote_datasource.dart';
import 'shared/data/datasources/rating_remote_datasource.dart';
import 'shared/data/repositories/comment_repository_impl.dart';
import 'shared/data/repositories/rating_repository_impl.dart';
import 'shared/presentation/providers/comment_provider.dart';
import 'shared/presentation/providers/rating_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  dotenv.load().then((_) {
    runApp(const MyApp());
  });
}

Future<void> _initializeApp() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: const Color(0xFFB71C1C)),
                    const SizedBox(height: 16),
                    const Text(
                      'Memuat Cultara...',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gagal memuat aplikasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return _buildMainApp();
      },
    );
  }

  Widget _buildMainApp() {
    final firestore = FirebaseFirestore.instance;
    final firebaseAuth = firebase_auth.FirebaseAuth.instance;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            repository: AuthRepositoryImpl(
              remoteDataSource: AuthRemoteDataSourceImpl(
                firebaseAuth: firebaseAuth,
                firestore: firestore,
              ),
            ),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => EventProvider(
            repository: EventRepositoryImpl(
              remoteDataSource: EventRemoteDataSourceImpl(firestore: firestore),
            ),
          )..fetchAllEvents(),
        ),

        ChangeNotifierProvider(
          create: (_) => MuseumProvider(
            repository: MuseumRepositoryImpl(
              remoteDataSource: MuseumRemoteDataSourceImpl(
                firestore: firestore,
              ),
            ),
          )..fetchAllMuseums(),
        ),

        ChangeNotifierProvider(
          create: (_) => ArticleProvider(
            repository: ArticleRepositoryImpl(
              remoteDataSource: ArticleRemoteDataSourceImpl(
                firestore: firestore,
              ),
            ),
          )..fetchAllArticles(),
        ),

        ChangeNotifierProvider(
          create: (_) => CommentProvider(
            repository: CommentRepositoryImpl(
              remoteDataSource: CommentRemoteDataSourceImpl(
                firestore: firestore,
              ),
            ),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => RatingProvider(
            repository: RatingRepositoryImpl(
              remoteDataSource: RatingRemoteDataSourceImpl(
                firestore: firestore,
              ),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Cultara App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.red,
          ).copyWith(secondary: Colors.amber),
        ),
        home: const AuthWrapper(),
        routes: {
          '/home': (context) => const HomePage(),
          '/login': (context) => const LoginPage(),
          '/article-form': (context) => const ArticleFormPage(),
          '/edit-profile': (context) => const EditProfilePage(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const AuthWrapper());
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isAuthenticated) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
