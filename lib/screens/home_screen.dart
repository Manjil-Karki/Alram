import 'package:alram/Database/database.dart';
import 'package:alram/Database/models/brief_Alram_Model.dart';
import 'package:alram/components/home_sliverHeaderDelegate.dart';
import 'package:alram/screens/add_edit_alram.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isTrue = true;

  List<Widget> _daysList(String? days) {
    final List<String>? obtainedList = days?.split(',');
    final children = <Widget>[];
    final daysList = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    
    for (var day in daysList) {
      bool activeDay = obtainedList != null ?  obtainedList.contains(day): false;




      var wid = Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: activeDay ? Colors.amber : null,
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Text(day),
      );

      children.add(wid);
    }
    return children;
  }

  Widget _buildAlramList() {
    return FutureBuilder(
        future: DBProvider.instance.querryAll(),
        builder: (context, AsyncSnapshot<List<BriefAlramModel>> snapshot) {
          if (!snapshot.hasData) {
            return SliverList(
                delegate: SliverChildListDelegate([
              Card(
                elevation: 0.0,
                color: Colors.white,
                margin: EdgeInsets.all(8.0),
                child: Text("No data",
                    style: TextStyle(
                      fontSize: 12,
                    )),
              )
            ]));
          }
          if (snapshot.hasData) {
            final List<BriefAlramModel> models = snapshot.data!;
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed('add_alram', arguments: models[index]);
                    },
                    child: Dismissible(
                      background: Container(
                        color: Colors.red,
                      ),
                      key: UniqueKey(),
                      confirmDismiss: (DismissDirection direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text(
                                  "Are you sure you wish to delete this item?"),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("DELETE")),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("CANCEL"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) async {
                        await DBProvider.instance.delete(models[index].id!);
                        setState(() {});
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        margin: EdgeInsets.all(15),
                        child: Container(
                            margin: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            '${models[index].title}',
                                            style: TextStyle(
                                              fontSize: 25,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            '${models[index].time!.hour.toString().padLeft(2, '0')}:${models[index].time!.minute.toString().padLeft(2, '0')}',
                                            style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Switch(
                                          value: models[index].isSet == 1
                                              ? true
                                              : false,
                                          onChanged: (stat) {
                                            DBProvider.instance.updateIsSet(
                                                models[index].id!,
                                                stat ? 1 : 0);
                                            setState(() {});
                                          }),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: _daysList(models[index].days),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                      ),
                    ),
                  );
                },
                childCount: models.length,
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: HomeHeaderDeligate(),
          ),
          _buildAlramList(),
        ],
      ),
    );
  }
}
