import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/model.dart';
import 'package:flutter_project/page/create.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();

  List<Blog> listBlog = [
    Blog(
      title: 'Info Bangunan',
      slug: "info-bangunan",
      category: 'karet',
      image: "202208011659341685224425838.jpg",
      description:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
    ),
    Blog(
      title: 'Genteng',
      slug: "Katalog",
      category: 'karet',
      image: "2022080316595694292071107839.jpg",
      description: "ini adalah deskripsi",
    ),
    Blog(
      title: 'Batu Bata',
      slug: "hahaha",
      category: 'karet',
      image: "2022080316595703361742919603.jpg",
      description: "ini deskripsi",
    ),
  ];

  @override
  initState() {
    super.initState();

    _getDataFromStorage();
  }

  _getDataFromStorage() async {
    String? data = await storage.read(key: 'list-post');
    if (data != null) {
      final dataDecoded = jsonDecode(data);
      if (dataDecoded is List) {
        setState(() {
          for (var item in dataDecoded) {
            listBlog.add(Blog.fromJson(item));
          }
        });
      }
    }
  }

  _saveDataToStorage() async {
    final List<Object> _tmp = [];
    for (var item in listBlog) {
      _tmp.add(item.toJson());
    }
    ;

    await storage.write(
      key: 'list-post',
      value: jsonEncode(_tmp),
    );
  }

  _showPopupMenuItem(BuildContext context, int index) {
    final blogClicked = listBlog[index];
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Menu untuk Post ${blogClicked.title}'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => CreateEditScreen(
                            mode: FormMode.edit,
                            blog: blogClicked,
                          )));
              if (result is Blog) {
                setState(() {
                  listBlog[index] = result;
                });
                _saveDataToStorage();
              }
            },
            child: const Text('Edit'),
          ),
          CupertinoActionSheetAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as delete or exit and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              showCupertinoModalPopup<void>(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: const Text('Alert'),
                  content: Text(
                      'Apakah anda yakin akan menghapus post ${blogClicked.title} ?'),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      /// This parameter indicates this action is the default,
                      /// and turns the action's text to bold text.
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Tidak'),
                    ),
                    CupertinoDialogAction(
                      /// This parameter indicates the action would perform
                      /// a destructive action such as deletion, and turns
                      /// the action's text color to red.
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          listBlog.removeAt(index);
                        });
                      },
                      child: const Text('Iya'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: new AppBar(
        //   leading: new Icon(Icons.backpack_outlined),
        //   title: new Text('Kembali'),
        // ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 55, left: 300),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Berikut Adalah Hasil Tes Apps Ferdynus Dewanto',
                // + username.toString(),
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'PoppinsSemiBold',
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 25,
              ), //tinggi logo X
              Image.asset(
                'images/logopt.png',
                width: 170,
                height: 170,
              ),
              SizedBox(
                height: 35,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                  ),
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        final item = listBlog[index];
                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: GestureDetector(
                            onTap: () => _showPopupMenuItem(context, index),
                            child: (Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.title}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                Text(
                                  'Category : ${item.category}',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black),
                                ),
                                Text(
                                  '${item.description}',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                              ],
                            )),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: listBlog.length),

                  // child: GridView.count(
                  //   crossAxisCount: 2,
                  //   crossAxisSpacing: 12,
                  //   mainAxisSpacing: 20,
                  //   children: <Widget>[
                  //     Card(
                  //       child: InkWell(
                  //         onTap: () {
                  //           // Navigator.push(
                  //           //   context,
                  //           //   MaterialPageRoute(
                  //           //       builder: (context) => Pengajuan()),
                  //           // );
                  //         },
                  //         child: Center(
                  //             child: Column(
                  //           children: <Widget>[
                  //             SizedBox(height: 5),
                  //             Image.asset('images/dokumen.png',
                  //                 width: 100, height: 100),
                  //             SizedBox(height: 2),
                  //             Text(
                  //               'Pengajuan',
                  //               style: TextStyle(
                  //                   fontSize: 20,
                  //                   fontFamily: 'PoppinsSemiBold'),
                  //               textAlign: TextAlign.center,
                  //             ),
                  //           ],
                  //         )),
                  //       ),
                  //     ),
                  //     Card(
                  //       child: InkWell(
                  //         onTap: () {
                  //           // Navigator.push(
                  //           //   context,
                  //           //   MaterialPageRoute(
                  //           //       builder: (context) => Aboutus()),
                  //           // );
                  //         },
                  //         child: Center(
                  //             child: Column(
                  //           children: <Widget>[
                  //             SizedBox(height: 13),
                  //             Image.asset('images/profile.png',
                  //                 width: 70, height: 70),
                  //             SizedBox(height: 10),
                  //             Text(
                  //               'Tentang\n Kami',
                  //               style: TextStyle(
                  //                   fontSize: 19,
                  //                   fontFamily: 'PoppinsSemiBold'),
                  //               textAlign: TextAlign.center,
                  //             ),
                  //           ],
                  //         )),
                  //       ),
                  //     ),
                  //     Card(
                  //       child: InkWell(
                  //         onTap: () {
                  //           // Navigator.push(
                  //           //   context,
                  //           //   MaterialPageRoute(
                  //           //       builder: (context) => Kontaksar()),
                  //           // );
                  //         },
                  //         child: Center(
                  //             child: Column(
                  //           children: <Widget>[
                  //             SizedBox(height: 1),
                  //             Image.asset('images/kontak.png',
                  //                 width: 95, height: 95),
                  //             Text(
                  //               'Kritik &\n Saran',
                  //               style: TextStyle(
                  //                   fontSize: 19,
                  //                   fontFamily: 'PoppinsSemiBold'),
                  //               textAlign: TextAlign.center,
                  //             ),
                  //           ],
                  //         )),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        const CreateEditScreen(mode: FormMode.create)));
            if (result is Blog) {
              setState(() {
                listBlog.add(result);
              });
              _saveDataToStorage();
            }
            ;
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
