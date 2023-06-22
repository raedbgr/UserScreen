import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:untitled/Home/my_controller.dart';

import '../Models/updates.dart';

class AddUserDialog extends StatefulWidget {
  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final MyController gxc = Get.find<MyController>();

  @override
  void initState() {
    super.initState();
    if (gxc.isExist) {
      _nameController.text = gxc.oldUser.name!;
      _ageController.text = gxc.oldUser.age.toString();
      gxc.imageFile = gxc.oldUser.pic;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add user'),
      content: GetBuilder<MyController>(
        builder: (ctr) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  gxc.imageFile != null ? Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2),
                      image: DecorationImage(
                        image: FileImage(gxc.imageFile!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ) : Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2),),
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    children: [
                      TextButton(
                          onPressed:(){
                            gxc.pickImageFromCamera();
                          },
                          child: gxc.isExist ? const Text("Change Image") : const Text("Add Image")
                      ),
                      // SizedBox(height: ,),
                      if (gxc.isExist && gxc.imageFile != null)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              gxc.temp = gxc.oldUser.pic;
                              gxc.imageFile = null;
                              gxc.oldUser.pic = null;
                              gxc.userList[gxc.indx!].pic = null;
                            });
                          },
                          child: const Text("Remove Image"),
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15,),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                keyboardType:TextInputType.number,
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
            ],
          );
        }
      ),
      actions: [
        TextButton(
            onPressed: (){
              // show updates related to this user only
              _showUserUpdates();
            },
            child: Text('Show Updates')),
        SizedBox(width: 10,),
        TextButton(
          child: gxc.isExist ? const Text('Update') : const Text('Add'),
          onPressed: () async {
            if (_nameController.text.isEmpty || _ageController.text.isEmpty) {
              const snackBar = SnackBar(
                content: Text('Please add your name and age!'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return; // return to User Model
            }
            else {
              if (gxc.isExist){
                gxc.updateUser(_nameController.text, int.parse(_ageController.text), gxc.imageFile,);
                gxc.imageFile = null;
                gxc.isExist = false;
              } else {
                DateTime dateTime = DateTime.now();

                String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

                gxc.addUser(_nameController.text, int.parse(_ageController.text), gxc.imageFile!, formattedDateTime);
            }
               Get.back();
              await gxc.savePrefs();
            }
          },
        ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }

  void _showUserUpdates() {
    final List<updateMod> userUpdates = gxc.updateList.where((update) {
      // Check if the update is related to the user
      return update.msg!.contains(gxc.oldUser.name!);
    }).toList();

    // bottom sheet for the updates related to a single user card
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: double.infinity,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.blue,
                padding: const EdgeInsets.all(10),
                child: Expanded(
                  child: const Text(
                    'User History',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: userUpdates.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(userUpdates[index].msg!),
                      subtitle: Text(userUpdates[index].date!),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


}
