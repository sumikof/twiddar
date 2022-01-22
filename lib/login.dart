import 'package:flutter/material.dart';
import 'package:my_app/service.dart';
import 'package:my_app/main.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginWidget(),
    );
  }
}

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future(() async {
      var uri = await twitterService.getAuthorizationURI();
      launch(uri);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ログイン後に表示されたPINを入力
            TextFormField(
              controller: controller,
            ),
            ElevatedButton(
              onPressed: () async {
                // 入力されたPINを元に Access Token を取得
                final pin = controller.text;
                twitterService.authorization(pin);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(title: 'Timeline'),
                    ));
              },
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
