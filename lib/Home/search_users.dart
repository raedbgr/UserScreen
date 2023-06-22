import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/user.dart';
import 'alert_dialog.dart';
import 'my_controller.dart';

class SearchUser extends SearchDelegate {
  final MyController gxc = Get.put(MyController());
  Eluser? tappedUser;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (tappedUser != null) {
      return Container(
        height: 145,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  tappedUser!.pic != null
                      ? Expanded(
                          flex: 2,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 2),
                              image: DecorationImage(
                                image: FileImage(tappedUser!.pic!),
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
                            'Name : ${tappedUser!.name}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Age : ${tappedUser!.age}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 7),
                        Text('Date : ${tappedUser!.date}'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        onPressed: () {
                          // dialog instance
                          gxc.isExist = true;
                          gxc.indx = gxc.generalIndex;
                          gxc.oldUser.name = tappedUser!.name;
                          gxc.oldUser.age = tappedUser!.age;
                          gxc.oldUser.pic = tappedUser!.pic;
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
    } else {
      return const Center(
        child: Text('No Result'),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> names = [];
    for (int i = 0; i < gxc.userList.length; i++) {
      names.add(gxc.userList[i].name!);
    }
    List filterNames =
        names.where((element) => element.contains(query)).toList();

    return ListView.builder(
      itemCount: query == '' ? gxc.userList.length : filterNames.length,
      itemBuilder: (BuildContext context, int index) {
        Eluser user = query == ''
            ? gxc.userList[index]
            : gxc.userList.firstWhere((user) => user.name == filterNames[index]);

        return InkWell(
          onTap: () {
            tappedUser = user;
            showResults(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
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
                    Expanded(child: Container()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
