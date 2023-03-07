import 'package:flutter/material.dart';
import 'package:memory_cache/memory_cache.dart';
import 'package:obtolab_mobile/screens/home.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  final _cache = MemoryCache.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giriş"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Material(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    initialValue: _cache.read("login_email")??'',
                    decoration: const InputDecoration(
                      labelText: 'E-Posta',
                      // suffixIcon: IconButton(
                      //   icon: const Icon(Icons.clear),
                      //   onPressed: () {
                      //     setState(() => _email = '');
                      //   },
                      // ),
                    ),
                    onSaved: (value) {
                      _email = value!;
                    },
                    validator: (value) => value?.isEmpty ?? true ? 'Lütfen E-Postanızı Giriniz.' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Şifre',
                      // suffixIcon: IconButton(
                      //   icon: const Icon(Icons.clear),
                      //   onPressed: () => setState(() => _password = ''),
                      // ),
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      _password = value!;
                    },
                    obscuringCharacter: '*',
                    validator: (value) => value?.isEmpty ?? true ? 'Lütfen Şifrenizi Girin' : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Giriş Yap'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      bool isLoggedIn = false;

      // Check the user's credentials here
      if (_email == "a" && _password == "a") {
        isLoggedIn = true;
        _cache.create("login_email", _email);
        _cache.create("login_password", _password);
        _cache.create("isLogged", true);
      } else {
        _cache.create("isLogged", false);
      }

      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Giriş Başarısız"),
            content: Text("E-postanız veya şifreniz yanlış."),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Tamam"),
              )
            ],
          ),
        );
      }
    }
  }
}