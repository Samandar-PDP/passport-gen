import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passport_gen/db/sql_helper.dart';
import 'package:passport_gen/model/passport.dart';
import 'package:passport_gen/screen/add_screen.dart';
import 'package:passport_gen/screen/detail_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: SqlHelper.getAllPassports(),
        builder: (context, snapshot) {
          if(snapshot.data != null && snapshot.data?.isNotEmpty == true) {
            final list = snapshot.data?.reversed.toList();
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final p = list?[index];
                return ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (context) => DetailScreen(passport: p)));
                  },
                  leading: Text("${index + 1}",style: const TextStyle(
                    fontSize: 20,
                    color: CupertinoColors.black
                  ),),
                  title: Text(p?.fullName ?? "",style: const TextStyle(
                  fontSize: 20,
                  color: CupertinoColors.black
                  ),),
                  subtitle: Text(p?.city ?? "",style: const TextStyle(
                      fontSize: 20,
                      color: CupertinoColors.black
                  ),),
                  trailing: IconButton(
                    onPressed:() {
                      _showActionSheet(p);
                    },
                    icon: const Icon(Icons.more_vert),
                  ),
                );
              },
            );
          } else if (snapshot.data?.isEmpty == true) {
            return const Center(child: Icon(CupertinoIcons.alarm));
          } else {
            return const CupertinoActivityIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => const AddScreen())),
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }

  void _deletePassport(int? id, BuildContext context)  {
    SqlHelper.deletePassport(id).then((value) {
      setState(() {

      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Deleted")));
    });
  }

  void _updatePassport(int? id) {
    SqlHelper.updatePassport(id, Passport(id, 'Yangi', 'Yangi address', '', '', '', '')).then((value) {
      setState(() {

      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Updated")));
    });
  }

  void _showActionSheet(Passport? passport) {
    showCupertinoModalPopup(context: context, builder: (context) => CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
            _updatePassport(passport?.id);
          }, child: Text("Update"),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop();
            _deletePassport(passport?.id, context);
          }, child: Text("Delete"),
        ),
      ],
    ));
  }
}
