import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/auth.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: AppBody(),
      body: WebcamApp(),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Something goes wrong, try to reload page."),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularProgressIndicator(),
    );
  }
}

class AppBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.height > screenSize.width;
    double size300 = 0;
    double size500 = 0;

    if (isMobile) {
      size300 = screenSize.width * 0.3;
      size500 = screenSize.width * 0.51;
    } else {
      size300 = screenSize.height * 0.3;
      size500 = screenSize.height * 0.51;
    }

    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        // Here background image
        Image.asset(
          "images/background.jpg",
          fit: BoxFit.cover,
        ),
        Container(
          child: ListView(
            children: [
              Container(
                height: 80,
                color: Colors.white,
              ),
              Container(
                height: size500,
                alignment: Alignment.bottomCenter,
                color: Colors.white.withOpacity(0.2),
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        isMobile
                            ? Container()
                            : Expanded(
                                flex: 1,
                                child: Container(),
                              ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.bottomCenter,
                              child: Image.asset("images/cat_.png")),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        isMobile
                            ? Container()
                            : Expanded(
                                flex: 1,
                                child: Container(),
                              ),
                      ],
                    )),
              ),
              Container(
                //height: size500,
                padding: isMobile ? EdgeInsets.all(25) : EdgeInsets.all(75),
                color: Colors.white,
                child: Row(
                  children: [
                    isMobile
                        ? Container()
                        : Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Wrap(children: [
                          Text(
                            "Firebase auth test",
                            textScaleFactor: 2,
                          ),
                          Container(
                            child: FirebaseControls(),
                          ),
                        ]),
                      ),
                    ),
                    isMobile
                        ? Container()
                        : Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                  ],
                ),
              ),
              Container(
                height: size500,
                color: Colors.white.withOpacity(0.2),
              ),
              Container(
                alignment: Alignment.center,
                height: size300,
                color: Colors.white,
                child: Text(
                  "Made by Torganik, with Flutter and help of the gods. 2020",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class FirebaseControls extends StatefulWidget {
  @override
  _FirebaseControlsState createState() => _FirebaseControlsState();
}

class _FirebaseControlsState extends State<FirebaseControls> {
  User user;

  void userChangeListener(User usr) {
    setState(() {
      this.user = usr;
    });
  }

  @override
  void initState() {
    super.initState();
    AuthService().setUserChangeListener(this.userChangeListener);
  }

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  // FORM
                  child: Container(
                      child: FutureBuilder(
                    future: _initialization,
                    builder: (context, snapshot) {
                      // Check for errors
                      if (snapshot.hasError) {
                        return SomethingWentWrong();
                      }

                      // Once complete, show your application
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          children: [
                            RegisterForm(),
                            SizedBox(
                              height: 50,
                            ),
                            LoginForm(),
                            SizedBox(
                              height: 50,
                            ),
                            WebcamApp(),
                          ],
                        );
                      }

                      // Otherwise, show something whilst waiting for initialization to complete
                      return Loading();
                    },
                  ))),
              Expanded(
                  flex: 1,
                  // user data
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                            "Screen is: W${screenSize.width} H:${screenSize.height}"),
                        Text("Current user: ${this.user ?? "No user"}"),
                      ],
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _hidePass = true;

  @override
  void initState() {
    _loginController.text = "torganik@yandex.ru";
    _passwordController.text = "123456";
    super.initState();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter login';
              }
              return null;
            },
            decoration: InputDecoration(helperText: "Login"),
            controller: _loginController,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
            obscureText: _hidePass,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                  onTapDown: (tapDown) {
                    setState(() {
                      _hidePass = false;
                    });
                  },
                  onTapUp: (tapDown) {
                    setState(() {
                      _hidePass = true;
                    });
                  },
                  child: Icon(Icons.remove_red_eye)),
              helperText: "Password",
            ),
            controller: _passwordController,
          ),
          RaisedButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                AuthService auth = AuthService();
                User usr = await auth.tryToAuth(
                    _loginController.text, _passwordController.text);
                if (usr == null) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Login failed')));
                } else if (usr is User) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Login OK')));
                } else {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Shit in auth data')));
                }
              }
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _phone = "+";
  String _fullName = "";
  String _password = "";
  bool _loginByPhone = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Auth by phone"),
              Checkbox(
                  value: _loginByPhone,
                  onChanged: (val) {
                    setState(() {
                      _loginByPhone = val;
                    });
                  }),
            ],
          ),
          TextFormField(
            initialValue: _fullName,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
            decoration: InputDecoration(helperText: "What is your name?"),
          ),
          TextFormField(
            initialValue: (_loginByPhone ? _phone : _email),
            keyboardType: (_loginByPhone
                ? TextInputType.phone
                : TextInputType.emailAddress),
            textCapitalization: TextCapitalization.none,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter ${(_loginByPhone ? "Phone" : "E-mail")}';
              } else {
                _email = value;
              }
              return null;
            },
            decoration: InputDecoration(
                helperText: "${(_loginByPhone ? "Phone" : "E-mail")}"),
          ),
          TextFormField(
            initialValue: _password,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter password';
              } else {
                _password = value;
              }
              return null;
            },
            obscureText: true,
            decoration: InputDecoration(
              helperText: "Password",
            ),
          ),
          RaisedButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                print("Go to reg: $_email $_password");
                await AuthService().registerNewUser(_email, _password);
              }
            },
            child: Text('Registration'),
          ),
        ],
      ),
    );
  }
}

class WebcamApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: WebcamPage(),
      );
}

class WebcamPage extends StatefulWidget {
  @override
  _WebcamPageState createState() => _WebcamPageState();
}

class _WebcamPageState extends State<WebcamPage> {
  // Webcam widget to insert into the tree
  Widget _webcamWidget;
  // VideoElement
  VideoElement _webcamVideoElement;
  bool frontCam = false;

  @override
  void initState() {
    super.initState();
    // Create a video element which will be provided with stream source
    _webcamVideoElement = VideoElement();
    // Register an webcam

    ui.platformViewRegistry.registerViewFactory(
        'webcamVideoElement', (int viewId) => _webcamVideoElement);
    // Create video widget
    _webcamWidget =
        HtmlElementView(key: UniqueKey(), viewType: 'webcamVideoElement');
    // Access the webcam stream
  }

  @override
  Widget build(BuildContext context) {
    window.navigator.getUserMedia(
        audio: false, video: {"facingMode": "user"}).then((MediaStream stream) {
      _webcamVideoElement.srcObject = stream;
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Cam MediaStream:',
              style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
            ),
            Container(
              child: Row(
                children: [
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        this.frontCam = !this.frontCam;
                      });
                    },
                    child:
                        Text("${(frontCam ? "To back cam" : "To front cam")}"),
                  ),
                ],
              ),
            ),
            Container(width: 750, height: 750, child: _webcamWidget),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _webcamVideoElement.srcObject.active
            ? _webcamVideoElement.play()
            : _webcamVideoElement.pause(),
        tooltip: 'Start stream, stop stream',
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
