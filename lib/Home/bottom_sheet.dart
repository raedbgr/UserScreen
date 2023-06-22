import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/Home/my_controller.dart';
import 'package:untitled/Models/updates.dart';

class MyBotSheet extends StatefulWidget {
  _MyBotSheetState createState() => _MyBotSheetState();
}

class _MyBotSheetState extends State<MyBotSheet> {
  final MyController gxc = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    List<updateMod> reversedList = gxc.updateList.reversed.toList(); // Reverse the order of the list

    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return SizedBox(
          height: double.infinity,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.blue,
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: const Text(
                        'Update History',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    IconButton(
                        onPressed: (){
                          // clear user update history
                          setState(() {
                            gxc.updateList.clear();
                          });
                        },
                        icon: Icon(Icons.delete, color: Colors.white,))
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: reversedList.length,
                    itemBuilder: (BuildContext context, int index) {
                      gxc.indx2 = index;
                      updateMod update = reversedList[index];

                      return ListTile(
                        title: Text('${update.msg}'),
                        subtitle: Text('${update.date}'),
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }
}
