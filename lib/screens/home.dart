import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memory_cache/memory_cache.dart';
import 'package:obtolab_mobile/screens/login.dart';
import 'package:obtolab_mobile/screens/qr.dart';
import 'package:obtolab_mobile/screens/talepler.dart';
import 'package:http/http.dart' as http;
class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  late Future<List<UnOrderedList>> _dinners;
  Future<List<UnOrderedList>> getDinners(double fontSize) async {
    List<UnOrderedList> beers = [];
    try {
      final response = await http.get(Uri.parse("https://api.punkapi.com/v2/beers"));
      var beersData = json.decode(response.body);

      for (var beer in beersData){
        UnOrderedList beerTmp = UnOrderedList(title: beer["name"], fontSize: fontSize);
        beers.add(beerTmp);
      }
      return beers.sublist(0,10);
    }catch (e){
      UnOrderedList beerTmp = UnOrderedList(title: "Kayıt Bulunamadı", fontSize: fontSize);
      beers.add(beerTmp);
      return beers;
    }

  }

  Future<List<UnOrderedList>> getPeople(double fontSize) async {
    List<UnOrderedList> people = [];
    try{
      final response = await http.get(Uri.parse("https://randomuser.me/api/?results=10"));
      var peopleData = json.decode(response.body);

      for (var person in peopleData["results"]){
        UnOrderedList personTmp = UnOrderedList(title: person["name"]["title"]+" "+person["name"]["first"]+" "+person["name"]["last"], fontSize: fontSize);
        people.add(personTmp);
      }
      return people.sublist(0,10);
    }catch(e) {
      UnOrderedList personTmp = UnOrderedList(title: "Kayıt Bulunamadı.", fontSize: fontSize);
      people.add(personTmp);
      return people;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth > 600 ? 30 : 20;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firma Adı"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red[600],
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Çıkış yapmak istediğinize emin misiniz?"),
                    actions: [
                      TextButton(
                        child: Text("Hayır"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Evet"),
                        onPressed: () async {
                          // MemoryCache önbelleğini temizle
                          MemoryCache.instance.delete('isLogged');
                          MemoryCache.instance.delete('login_email');
                          MemoryCache.instance.delete('login_password');

                          // LoginForm sayfasına git ve tüm geçmişi kaldır
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginForm()),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],

      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        // padding: EdgeInsets.symmetric(vertical: 1),
        margin: const EdgeInsets.all(20),
        // padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight:Radius.circular(10)),
                          color: Colors.blue
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                            onPressed: (){
                              _dinners=getPeople(fontSize-3);
                            },
                          ),
                          Center(
                            child: Text(
                              "Yemek Listesi",
                              style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios,color: Colors.white),
                            onPressed: (){},
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                TableRow(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(231, 231, 231, 1),
                    borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10),bottomRight:Radius.circular(10)),
                  ),
                  children: <Widget>[
                    SingleChildScrollView(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height:MediaQuery.of(context).size.height/4 ,
                        child: FutureBuilder<List<UnOrderedList>>(
                          future: getDinners(fontSize-3),
                          builder: (BuildContext context, AsyncSnapshot<List<UnOrderedList>> snapshot) {
                            if (snapshot.hasData) {
                              return RawScrollbar(
                                  thumbVisibility: true, //always show scrollbar
                                  thickness: 5, //width of scrollbar
                                  thumbColor: Colors.blue[200],
                                  radius: const Radius.circular(20), //corner radius of scrollbar
                                  scrollbarOrientation: ScrollbarOrientation.left, //which side to show scrollbar
                                  child:ListView.builder(
                                    // physics: NeverScrollableScrollPhysics(), // önemli: bu, ListView'in kendisine kaydırılabilirliği kapatır
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return snapshot.data![index];
                                    },
                                  )
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return const Center(
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    semanticsLabel: "Yükleniyor...",
                                    semanticsValue: "Yükleniyor...",
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0,5,5,0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 0)
                          ),
                          onPressed: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Talepler()));
                          },
                          child: Text(
                            "Talepler",
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold
                            ),
                          )
                      ),
                    )
                ),
                Expanded(
                    flex: 4,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(5,5,0,0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 0)
                          ),
                          onPressed: (){},
                          child: Text(
                            "Anketler",
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold
                            ),
                          )
                      ),
                    )
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 100,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0,5,5,0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 0)
                          ),
                          onPressed: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => QRCodeScanner()));
                          },
                          child: Text(
                            "QR ile Hızlı Giriş",
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold
                            ),
                          )
                      ),
                    )
                ),
                Expanded(
                    flex: 100,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(5,5,0,0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 0)
                          ),
                          onPressed: (){},
                          child: Text(
                            "Sisteme Giriş",
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold
                            ),
                          )
                      ),
                    )
                )
              ],
            ),
            Expanded(child: KisiListeleriTab(izinliler: getPeople(fontSize-3), doganlar: getPeople(fontSize-3),)),
          ],
        ),
      ),
    );
  }

}

class KisiListeleriTab extends StatelessWidget {
  late Future<List<UnOrderedList>> _izinliler=[] as Future<List<UnOrderedList>>;
  late Future<List<UnOrderedList>> _doganlar=[] as Future<List<UnOrderedList>>;
  KisiListeleriTab({super.key,required Future<List<UnOrderedList>> izinliler, required Future<List<UnOrderedList>> doganlar}){
    _izinliler = izinliler;
    _doganlar = doganlar;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth > 600 ? 30 : 20;
    return Container(
      margin: const EdgeInsets.only(top:5),

      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topRight:Radius.circular(10),topLeft:Radius.circular(10)),
                color: Colors.blue,
              ),
              child: const TabBar(
                indicatorColor: Colors.deepOrange,
                labelColor: Colors.black,

                tabs:  [
                  Tab(
                    child: Text(
                      "İzinli Olanlar",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Doğum Günü Olanlar",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(231, 231, 231, 1),
                      borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10),bottomRight:Radius.circular(10)),
                    ),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height:MediaQuery.of(context).size.height/4 ,
                        child: FutureBuilder<List<UnOrderedList>>(
                          future: _izinliler,
                          builder: (BuildContext context, AsyncSnapshot<List<UnOrderedList>> snapshot) {
                            if (snapshot.hasData) {
                              return RawScrollbar(
                                  thumbVisibility: false, //always show scrollbar
                                  thickness: 5, //width of scrollbar
                                  thumbColor: Colors.blue[200],
                                  radius: const Radius.circular(20), //corner radius of scrollbar
                                  scrollbarOrientation: ScrollbarOrientation.left, //which side to show scrollbar
                                  child:ListView.builder(
                                    // physics: NeverScrollableScrollPhysics(), // önemli: bu, ListView'in kendisine kaydırılabilirliği kapatır
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return snapshot.data![index];
                                    },
                                  )
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return const Center(
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    semanticsLabel: "Yükleniyor...",
                                    semanticsValue: "Yükleniyor...",
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(231, 231, 231, 1),
                      borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10),bottomRight:Radius.circular(10)),
                    ),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height:MediaQuery.of(context).size.height/4 ,
                        child: FutureBuilder<List<UnOrderedList>>(
                          future: _doganlar,
                          builder: (BuildContext context, AsyncSnapshot<List<UnOrderedList>> snapshot) {
                            if (snapshot.hasData) {

                              return RawScrollbar(
                                  minThumbLength: 1,
                                  thumbVisibility: false, //always show scrollbar
                                  thickness: 5, //width of scrollbar
                                  thumbColor: Colors.blue[200],
                                  radius: const Radius.circular(20), //corner radius of scrollbar
                                  scrollbarOrientation: ScrollbarOrientation.left, //which side to show scrollbar
                                  child:ListView.builder(
                                    // physics: NeverScrollableScrollPhysics(), // önemli: bu, ListView'in kendisine kaydırılabilirliği kapatır
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return snapshot.data![index];
                                    },
                                  )
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return const Center(
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    semanticsLabel: "Yükleniyor...",
                                    semanticsValue: "Yükleniyor...",
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UnOrderedList extends StatelessWidget {
  final String title;
  final double fontSize;
  const UnOrderedList({Key? key,required this.title,required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7.5,vertical: 0),
      margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 3),
      child: Row(
          children:[
            Text("\u2022", style: TextStyle(fontSize: fontSize,)), //bullet text
            const SizedBox(width: 10,), //space between bullet and text
            Expanded(
              child:Text(title, style: TextStyle(fontSize: fontSize),), //text
            ),
          ]
      ),
    );
  }
}
