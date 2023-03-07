
import 'package:flutter/material.dart';
import 'package:memory_cache/memory_cache.dart';
import 'package:obtolab_mobile/screens/home.dart';
import 'package:obtolab_mobile/screens/login.dart';


void main() {
  runApp(const MyApp());
}
//
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const Router(),

    );
  }
}

class Router extends StatefulWidget {
  const Router({Key? key}) : super(key: key);

  @override
  _RouterState createState() => _RouterState();
}


class _RouterState extends State<Router>  {
  late bool _isLogged=false;
  @override
  void initState(){
    super.initState();
    if (MemoryCache.instance.contains("isLogged")){
      _isLogged = MemoryCache.instance.read<bool>('isLogged')!;
    }else{
      _isLogged=false;
    }

  }
  Widget build(BuildContext context) {

    if (_isLogged){
      return Home();
    }
    return const LoginForm();
  }
}
