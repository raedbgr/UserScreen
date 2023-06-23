import 'package:flutter/material.dart';
import 'package:untitled/Home/alert_dialog.dart';
import 'package:get/get.dart';
import 'package:untitled/Home/bottom_sheet.dart';
import 'package:untitled/Home/my_controller.dart';
import 'package:untitled/Home/search_users.dart';
import '../Models/user.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final MyController gxc = Get.put(MyController());
  List<Eluser> selectedUsers = [];
  bool isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    gxc.loadPrefs();
    gxc.loadHistoryPrefs();
  }

  Widget buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildUserListView() {
    return ListView.builder(
      itemCount: gxc.userList.length,
      itemBuilder: (BuildContext context, int index) {
        Eluser user = gxc.userList[index];
        bool isSelected = selectedUsers.contains(user);
        gxc.generalIndex = index;

        return GestureDetector(
          onLongPress: () {
            setState(() {
              isSelectionMode = !isSelectionMode;
              if (!isSelectionMode) {
                selectedUsers.clear();
              }
              // edit here ------
              if (isSelectionMode) {
                if (isSelected) {
                  selectedUsers.remove(user);
                } else {
                  selectedUsers.add(user);
                }
              }
              // ----------------
            });
          },
          onTap: () {
            setState(() {
              if (isSelectionMode) {
                if (isSelected) {
                  selectedUsers.remove(user);
                } else {
                  selectedUsers.add(user);
                }
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              color: isSelected ? Colors.blue[100] : null,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ---------------
                    user.pic != null
                        ? Expanded(
                            flex: 2,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: 2),
                                image: DecorationImage(
                                  image: FileImage(user.pic!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            flex: 2,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 2)),
                              child: const Icon(
                                Icons.person,
                                size: 90,
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 180,
                            child: Text(
                              'Name : ${user.name}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Age : ${user.age}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 7),
                          Text('Date : ${user.date}'),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {
                            // dialog instance
                            gxc.isExist = true;
                            gxc.indx = index;
                            gxc.oldUser.name = user.name;
                            gxc.oldUser.age = user.age;
                            gxc.oldUser.pic = user.pic;
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AddUserDialog();
                              },
                            );
                          },
                          icon: const Icon(Icons.edit)),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        leading: IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchUser());
            },
            icon: const Icon(Icons.search)),
        actions: [
          isSelectionMode
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isSelectionMode = !isSelectionMode;
                      if (!isSelectionMode) {
                        selectedUsers.clear();
                      }
                    });
                  },
                  icon: const Icon(Icons.close),
                )
              : Container(),
          isSelectionMode
              ? IconButton(
                  onPressed: () {
                    if (selectedUsers.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Remove Users'),
                            content: Text(
                                'Are you sure you want to remove ${selectedUsers.length} user(s)?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  for (Eluser user in selectedUsers) {
                                    gxc.removeUser(user);
                                  }
                                  // edited here -------
                                  setState(() {
                                    isSelectionMode = !isSelectionMode;
                                    if (!isSelectionMode) {
                                      selectedUsers.clear();
                                    }
                                  });
                                  // -------------
                                  // selectedUsers.clear();
                                  Get.back();
                                },
                                child: const Text('Remove'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  icon: const Icon(Icons.delete),
                )
              : Container(),
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return MyBotSheet();
                    });
              },
              icon: const Icon(Icons.history)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // add user to list view
          gxc.isExist = false;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddUserDialog();
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: GetBuilder<MyController>(
        builder: (context) {
          return gxc.isLoading.value
              ? buildLoadingIndicator()
              : buildUserListView();
        },
      ),
    );
  }
}
