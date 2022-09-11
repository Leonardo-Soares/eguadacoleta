import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.amber),
    initialRoute: "/login",
    routes: {
      "/login": (context) => LoginPage(),
      "/home": (context) => HomePage(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Home page"),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email = "";
  String? password = "";
  final formKey = GlobalKey<FormState>();
  var isLoading = false;
  var isLogged = false;

  void login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    setState(() {});
    final response = await apiLogin(email: email, password: password);
    isLoading = false;
    setState(() {});
    if (response) {
      Navigator.pushNamed(context, "/home");
    }
    else {
      Navigator.pushNamed(context, "/login");
    }
  }

  bool validate() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  String? validateEmail(String? email) =>
      email != null && email.isNotEmpty ? null : "Email incorreto";
  String? validatePassword(String? password) =>
      password != null && password.length > 8 ? null : "Senha incorreta";

  Future<bool> apiLogin(
      {required String email, required String password}) async {
     final response = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
     print(response);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return isLogged
        ? HomePage()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (value) => validateEmail(value),
                      onSaved: (value) => email = value,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "Senha"),
                      validator: (value) => validatePassword(value),
                      onSaved: (value) => password = value,
                    ),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else
                      TextButton(
                        onPressed: () {
                          if (validate()) {
                            login(email: email!, password: password!);
                            print("Email: $email | Senha: $password");
                          }
                        },
                        child: const Text("Entrar"),
                      ),
                  ],
                ),
              ),
            ),
          );
  }
}
