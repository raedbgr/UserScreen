import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/Home/my_controller.dart';
import 'package:untitled/Models/updates.dart';

class MyBotSheet extends StatelessWidget {
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
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Update History',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: reversedList.length,
                    itemBuilder: (BuildContext context, int index) {
                      gxc.indx2 = index;
                      updateMod update = reversedList[index];

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${update.msg}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Date: ${update.date}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
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
