import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/SignEmpresa.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/contratanteLogin.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/empregadorpage.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/login_page.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/sign_page.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/signpage_tecnico.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/vagas.dart';

import 'features/user_auth/presentation/pages/chat_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyCSYYY0GRjXN-aqSTzEpiyDSD2aiu2tHYE",
    appId: "1:148252031975:web:0b509605d2c4f483be1b42",
    messagingSenderId: "148252031975",
    projectId: "soteno-firebase",
  ));

  /*await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('6LcOf9opAAAAAAZT9V4CGS90YBhfBydbzof3-JPw'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );*/

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCSYYY0GRjXN-aqSTzEpiyDSD2aiu2tHYE",
        appId: "1:148252031975:web:0b509605d2c4f483be1b42",
        messagingSenderId: "148252031975",
        projectId: "soteno-firebase",
      ),
    );
  }
  runApp(MyApp());
  debugShowCheckedModeBanner:
  false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider<ChatProvider>(
        create: (_) => ChatProvider(),
    ),
    // Adicione outros provedores aqui
    ],
      child:MaterialApp(
      home: MyHomePage(),
    )
    )
    ;
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _pageController;
  int totalPage = 3;

  void _onScroll() {
    print('ssss');
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0)
      ..addListener(() {
        _onScroll;
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: PageView(
        controller: _pageController,
        children: <Widget>[
          makePage(
              page: 1,
              image: 'images/Baba.jpg',
              description: 'Seja Bem-Vindo/a ao Soteno, '
                  'nesta aplicação você pode encontrar os melhores funcionários, conversar '
                  'com eles diretamente e avaliar também, aproveite o soteno.',
              button: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
          ),
          makePage(
              page: 2,
              image: 'images/mecanico.jpg',
              description: 'Olá, mais uma vez. '
                  'Aproveite cadastre-se para mostrar que está disponivel para trabalho, ou para contratar.'),
          makePage(
              page: 3,
              image: 'images/cozinheiro.jpg',
              description:
                  'Já está cadastrado? Não perca tempo e inicie a sua sessão,'
                  ' aproveite contratar ou ser contratado de forma fácil '
                  'e rápida, aproveite o soteno.',
            button: ElevatedButton(
              onPressed: () {}, // Deixe essa função vazia por enquanto
              child: PopupMenuButton(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  width: double.infinity,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Selecione uma Opção',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                  ),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    child: Text('Contrante'),
                    value: 'Contratante',
                  ),
                  const PopupMenuItem(
                    child: Text('Empresa'),
                    value: 'Empresa',
                  ),
                  const PopupMenuItem(
                    child: Text('Técnico'),
                    value: 'Técnico',
                  ),
                ],
                onSelected: (value) {
                  // Aqui você pode lidar com a seleção da opção
                  switch (value) {
                    case 'Contratante':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => loginContratante()),
                      );
                      break;
                    case 'Empresa':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => signEmpresa()),
                      );
                      break;
                    case 'Técnico':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignpageTecnico()),
                      );
                      break;
                    default:
                  }
                },
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
              ),
            ),

          ),

        ],
      )),
    );
  }

  Widget makePage({image, description, button, page}) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text(
                  page.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '/' + totalPage.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )
              ]),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Image.asset('images/sotenologo4.png'),
                height: 70,
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 15,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 15,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 15,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 15,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 15,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '4.0',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '(2300)',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Text(
                  description,
                  style: TextStyle(
                      color: Colors.white.withOpacity(.7),
                      height: 1.9,
                      fontSize: 15),
                ),
              ),
              Container(
                child: button,
              )
            ],
          ))
        ]),
      ),
    );
  }
}

/*SizedBox(
              width: 110,
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),*/

/*ElevatedButton(
                onPressed: () {}, // Deixe essa função vazia por enquanto
                child: PopupMenuButton(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    width: double.infinity,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Selecione uma Opção',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                    ),
                  ),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      child: Text('Contrante'),
                      value: 'Contratante',
                    ),
                    const PopupMenuItem(
                      child: Text('Empresa'),
                      value: 'Empresa',
                    ),
                    const PopupMenuItem(
                      child: Text('Técnico'),
                      value: 'Técnico',
                    ),
                  ],
                  onSelected: (value) {
                    // Aqui você pode lidar com a seleção da opção
                    switch (value) {
                      case 'Contratante':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => loginContratante()),
                        );
                        break;
                      case 'Empresa':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => signEmpresa()),
                        );
                        break;
                      case 'Técnico':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                        break;
                      default:
                    }
                  },
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                ),
              ),*/
