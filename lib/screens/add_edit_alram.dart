import 'package:alram/Database/database.dart';
import 'package:alram/Database/models/brief_Alram_Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class AddAlram extends StatefulWidget {
  final BriefAlramModel? model;

  const AddAlram({this.model});

  @override
  _AddAlramState createState() => _AddAlramState(model);
}

class _AddAlramState extends State<AddAlram> {
  final _formKey = GlobalKey<FormState>();

  late BriefAlramModel model;

  _AddAlramState(BriefAlramModel? model) {
    model.toString();
    if (model == null) {
      model = BriefAlramModel(
          isSet: 1,
          title: 'Alram',
          time: DateTime(2020),
          days: 'Sun,Mon,Tue,Wed');
    }
    this.model = model;

    List<String>? days = model.days?.split(',');

    days?.forEach((element) {
      daysList[element] = true;
    });
  }

  Map<String, bool> daysList = {
    'Sun': false,
    'Mon': false,
    'Tue': false,
    'Wed': false,
    'Thu': false,
    'Fri': false,
    'Sat': false,
  };

  List<Widget> _activeDays() {
    List<Widget> children = <Widget>[];

    daysList.forEach((key, value) {
      var wid = Container(
          margin: EdgeInsets.all(10),
          child: ElevatedButton(
            child: Text(key),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    value ? Colors.blue : Colors.transparent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
            onPressed: () => setState(() => daysList[key] = !value),
          ));
      children.add(wid);
    });

    return children;
  }

  Widget _costomForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TimePickerSpinner(
            time: model.time,
            is24HourMode: false,
            normalTextStyle: TextStyle(
              fontSize: 20,
            ),
            highlightedTextStyle: TextStyle(
              fontSize: 40,
            ),
            spacing: 20,
            itemHeight: 80,
            isForce2Digits: true,
            onTimeChange: (time) {
              setState(() {
                model.time = time;
              });
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              initialValue: model.title,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Alram note';
                }
                model.title = value;
                return null;
              },
            ),
          ),
          Center(
            child: Text('Active days'),
          ),
          Container(
            margin: EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 2,
              children: _activeDays(),
            ),
          )
        ],
      ),
    );
  }

  void _prepareDaysList() {
    List<String>? days = [];

    daysList.forEach((key, value) {
      if (value) {
        days.add(key);
      }
      model.days = days.join(',');
    });
  }

  Future<int> _insertData() async {
    _prepareDaysList();
    if (model.id == null) {
      return await DBProvider.instance.insert(model);
    } else {
      return await DBProvider.instance.update(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(child: Text('Alram')),
        actions: [
          IconButton(
              onPressed: () async {
                _formKey.currentState!.validate();

                await _insertData();
                Navigator.pop(context);
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: _costomForm(),
    );
  }
}
