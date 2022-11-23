import 'package:flutter/material.dart';
import 'package:movie_ticket/loginadmin.dart';
import 'package:movie_ticket/userhome.dart';
import 'package:movie_ticket/utilities.dart';


class LoginUser extends StatefulWidget {
  const LoginUser({Key? key}) : super(key: key);

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final contactController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    height: screenHeight *
                        .2, //It will take the 20%  height of the screen
                    width: screenwidth * .5,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.network(
                        'https://tse3.mm.bing.net/th?id=OIP.rba3WWoW2LisfSKz7o9JawHaKU&pid=Api&P=0')),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: contactController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone number ',
                    hintText: 'Enter Your Phone number'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter password'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 30,
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18),
                  primary: Colors.red[900],
                ),
                onPressed: () async {
                  var response=await Utilities().loginUser(contactController.text,passwordController.text);
                  if(response=='success'){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => UserHome()));
                  }else{
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          content: Text("${response}"),
                        ));
                  }
                  passwordController.clear();
                  contactController.clear();
                },
                child: Text("Login"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Sign up"),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                ),
                Text("/"),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Admin"),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginAdmin()));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController=TextEditingController();
  final passwordController = TextEditingController();


  _submit() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    var response = await Utilities().registerUser(nameController.text,passwordController.text,emailController.text,passwordController.text);
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text("${response}"),
        ));
    emailController.clear();
    contactController.clear();
    nameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Signup ")),
        backgroundColor: Colors.red[900],
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginUser()));
              },
              child: Icon(
                Icons.home_filled,
                size: 30,

              ),
            ),
          )
        ],

      ),
      //body
      body: Align(
        alignment: Alignment(0, 0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            //form
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (value) {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid Name!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),

                    onFieldSubmitted: (value) {},
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid password!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                      border: OutlineInputBorder(),
                    ),

                    onFieldSubmitted: (value) {
                      //Validator
                    },
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return 'Enter a valid email!';
                      }
                      return null;
                    },
                  ),
                  //box styling
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                  TextFormField(
                    controller: contactController,
                    decoration: InputDecoration(
                      labelText: 'Contact',
                      border: OutlineInputBorder(),
                    ),

                    onFieldSubmitted: (value) {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field must not be empty!';
                      }
                      if (value.length != 10) {
                        return 'return valid mobile number';
                      }
                      return null;
                    }
                  ),
                  //text input

                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[900],
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => _submit(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}