import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todoapp/data/local_storage.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks; // içerisinde task verilerini tutan boş bir liste tanımladık
  late LocalStorage _localStorage;
  @override
  void initState() {
    
    super.initState();
    _localStorage =locator<LocalStorage>();
    _allTasks = <Task> []; // burada uygulama başlamadan bir kez tanımlanması için initstate yapısı içerisinde tanımladık.
     _getAllTaskFromDb(); // initstate içerisinde asyn işlem yapılamayacağından bu işlemi fonksiyonla dışarı alıyoruz.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: (){
            _showAddTaskBottomSheet(context);
          },
            child: Text(
          'Bugün Neler Yapacaksın?',
          style: TextStyle(color: Colors.black),
        )),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                _showAddTaskBottomSheet(context);
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: _allTasks.isNotEmpty ? ListView.builder(itemBuilder: (context, index) {
        var _oAnkiListeElemani = _allTasks[index];
        return Dismissible(
          background:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete),
              SizedBox(width: 8,),
              Text('Bu görev silindi'),
          ],),
          key: Key(_oAnkiListeElemani.id),
          onDismissed: (direction){
            _allTasks.removeAt(index);
            _localStorage.deleteTask(task:_oAnkiListeElemani);
            setState(() {
              
            });
          },
          child: TaskItem(task:_oAnkiListeElemani),
        );
      } , itemCount: _allTasks.length,): Center(child: Text('Hadi Görev Oluştur.'),),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context)
                    .viewInsets
                    .bottom), // klavye açıldığında hemen üstünde texfieldın yer almasını belirtmek için bunu kullanıyoruz.
            width: MediaQuery.of(context).size.width,
            child:  ListTile(
              title: TextField(
                onSubmitted: (value) => {
                  Navigator.of(context).pop(),
                  DatePicker.showTimePicker(context,showSecondsColumn: false,onConfirm: (time) async {
                    var yeniEklenecekGorev=Task.create(name:value,createdAt: time);
                    _allTasks.add(yeniEklenecekGorev);
                     await _localStorage.addTask(task: yeniEklenecekGorev);
                    setState(() {
                      
                    });
                  }),
                },
                style:const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  hintText: 'Görev Nedir?',
                  border: InputBorder
                      .none, // textfield alttaki çizgiyi kaldırmak için kullanıyoruz.
                ),
              ),
            ),
          );
        });
  }

  void _getAllTaskFromDb() async{
    _allTasks = await _localStorage.getAllTask();
    setState(() {
      
    });
  }
}
