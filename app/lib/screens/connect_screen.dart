import 'package:flutter/material.dart';
import 'package:logic/main.dart';
import 'package:turt/common/widgets.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController;
  SocketBloc bloc;

  @override
  void initState() {
    nameController = TextEditingController();
    bloc = SocketBloc();
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  void connect() {
    bloc.add(ConnectToTheGameEvent(nameController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                controller: nameController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Username'
                ),
              ),
              AnyChangeableButton(
                bloc: bloc,
                button: Text('Connect!'),
                onTap: connect,
              )
            ],
          ),
        ),
      ),
    );
  }
}
