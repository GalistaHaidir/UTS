import 'package:flutter/material.dart';
import 'package:flutter_application/sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Pelanggaran Kelas',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Daftar Pelanggaran Kelas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController pelanggaranController = TextEditingController();

  void initState() {
    refreshNote();
    super.initState();
  }

  //ambil database
  List<Map<String, dynamic>> note = [];
  void refreshNote() async {
    final data = await SQLHelper.getNote();
    setState(() {
      note = data;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    print(note);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: note.length,
          itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(note[index]['nama']),
                  subtitle: Text(note[index]['pelanggaran']),
                  trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () => modalForm(note[index]['id']),
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () => hapusNote(note[index]['id']),
                              icon: Icon(Icons.delete))
                        ],
                      )),
                ),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalForm(null);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //fungsi tambah
  Future<void> tambahNote() async {
    await SQLHelper.tambahNote(namaController.text, pelanggaranController.text);
    refreshNote();
  }

//fungsi ubah
  Future<void> ubahNote(int id) async {
    await SQLHelper.ubahNote(
        id, namaController.text, pelanggaranController.text);
    refreshNote();
  }

//fungsi hapus
  void hapusNote(int id) async {
    await SQLHelper.hapusNote(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Berhasil hapus')));
    refreshNote();
  }

  //form tambah
  void modalForm(int id) async {
    if (id != null) {
      final dataNote = note.firstWhere((element) => element['id'] == id);
      namaController.text = dataNote['nama'];
      pelanggaranController.text = dataNote['pelanggaran'];
    }
    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 800,
              child: SingleChildScrollView(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(hintText: 'Nama Siswa'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: pelanggaranController,
                    decoration: const InputDecoration(hintText: 'Pelanggaran'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await tambahNote();
                        } else {
                          await ubahNote(id);
                        }
                        namaController.text = '';
                        pelanggaranController.text = '';
                        Navigator.pop(context);
                      },
                      child: Text(id == null ? 'tambah' : 'ubah'))
                ],
              )),
            ));
  }
}
