import 'package:flutter/material.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';

void main() {
  runApp(const MyApp());
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<Article>> future;

  @override
  void initState() {
    super.initState();
    future = getNewsData();
  }

  Future<List<Article>> getNewsData() async {
    NewsAPI newsAPI = NewsAPI("51fb2dcf7faa40fa94ce1b48a2f8ae03");
    return await newsAPI.getTopHeadlines(
      country: "us",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading the news"),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return _buildNewsListView(snapshot.data as List<Article>);
                  } else {
                    return const Center(
                      child: Text("No newsavailable "),
                    );
                  }
                }
              },
              future: future,
            ),
          )
        ],
      )),
    );
  }
}

Widget _buildNewsListView(List<Article> articleList) {
  return ListView.builder(
    itemBuilder: (context, index) {
      Article article = articleList[index];
      return _buildNewsListView(articleList);
    },
    itemCount: articleList.length,
  );
}

Widget _buildNewsIteam(Article article) {
  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Image.network(
              article.urlToImage ?? "",
            ),
          )
        ],
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Анимация завершена, переход к следующему экрану
        // Например, Navigator.pushReplacement()
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 96, 33, 243),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: const FlutterLogo(
            size: 220,
          ),
        ),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  return const MaterialApp(
    home: LoginPage(),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String phoneNumber = '';
  String errorMessage = '';

  void login() {
    if (phoneNumber == '911') {
      setState(() {
        errorMessage = 'Ошибка авторизации!';
      });
    } else {
      // Выполнение операций авторизации
      // ...
      // Например, переход на следующий экран
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NewsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Авторизация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  phoneNumber = value;
                  errorMessage = '';
                });
              },
              decoration: const InputDecoration(
                labelText: 'Номер телефона',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: login,
              child: const Text('Войти'),
            ),
            const SizedBox(height: 8.0),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
