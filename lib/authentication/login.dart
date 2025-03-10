
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:we_chat_app/API/apis.dart';
// import 'package:we_chat_app/authentication/registration.dart';
// import 'package:we_chat_app/mainscreens/chat_members.dart';



// class LoginForm extends StatefulWidget {
//   const LoginForm({super.key});

//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   final _formKey = GlobalKey<FormState>();
// final _emailController = TextEditingController();
// final _passwordController = TextEditingController();
// bool _obscureText = true;
// bool isLoading  = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:  isLoading ? CircularProgressIndicator() : Padding(
//        padding: const EdgeInsets.all(20.0),
//        child: Form(
//          key: _formKey,
//          child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//            children: [
//             Text("Chat Application",style: TextStyle(fontSize: 30),),
//             const SizedBox(height:20),
//              TextFormField(
//                controller: _emailController,
//                decoration: const InputDecoration(
//                  labelText: 'Email',
//                  border: OutlineInputBorder(),
//                ),
//                validator: (value) {
//                  if (value == null || value.isEmpty && value.contains('@gmail.com')) {
//                    return 'Please enter your email address';
//                  }
//                  return null;
//                },
//              ),
//              const SizedBox(height: 20.0),
//              TextFormField(
//                controller: _passwordController,
//                obscureText: _obscureText, // Control password visibility
//                decoration: InputDecoration(
//                  labelText: 'Password',
//                  border: const OutlineInputBorder(),
//                  suffixIcon: IconButton(
//                    icon: Icon(
//                      _obscureText ? Icons.visibility_off : Icons.visibility,
//                    ),
//                    onPressed: () {
//                      setState(() {
//                        _obscureText = !_obscureText;
//                      });
//                    },
//                  ),
//                ),
//                validator: (value) {
//                  if (value == null || value.isEmpty) {
//                    return 'Please enter your password';
//                  }
//                  return null;
//                },
//              ),
//              const SizedBox(height: 20.0),
//              ElevatedButton(
//                onPressed: () {
//                  if (_formKey.currentState!.validate() && _emailController.text.contains('@gmail.com') 
//                  && _passwordController.text != "" ) {
                   
//                   signIn();
//                  } else {
//                   showDialog(context: context, builder:(context)=>
//                   AlertDialog( 
//                     content:const  SizedBox(
//                       width:500,
//                       height: 200,
//                       child: Center( 
//                         child:  Text("Please Enter a Valid Email And Password"),
//                       ),
//                     ),
//                     actions: [ 
//                       ElevatedButton(onPressed: (){
//                         Navigator.pop(context);
//                       }, child: Text("Ok"))
//                     ],

//                   ));
//                  }
//                },
//                child: const Text('Login',style: TextStyle(color: Colors.black)),
//              ),
//             const  SizedBox(height: 30,),
//              Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//                children: [
//                 Text("Don't have account"),
//                  TextButton(onPressed: (){
//                   Navigator.push(context, MaterialPageRoute(builder:(context)=>Register()));
                 
//                  }, child:Text("Register")),
//                ],
//              )
//            ],
//          ),
//        ),

       

//     ));
//   }

//   void signIn() {
   



//     if(_formKey.currentState!.validate()) {

//       setState(() {
//         isLoading = true;
//       });
//       FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).then((user) {
//         setState(() {
//           isLoading = false;
//         });
//         Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatMembers()));
//         _emailController.clear();
//         _passwordController.clear();


//       }).catchError((onError) {
//          setState(() {
//         isLoading = false;
//       });
//       Fluttertoast.showToast(msg:"error"+onError.toString());


//       });

      
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_chat_app/authentication/registration.dart';
import 'package:we_chat_app/mainscreens/chat_members.dart';
import 'package:we_chat_app/widgets/responsive.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _buttonAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: Responsive.isDesktop(context)||Responsive.isDesktopLarge(context) ? 
              EdgeInsets.symmetric(horizontal:500,vertical: 60):EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _animation,
                      child: Text(
                        "Welcome to Chat App",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.blue, width: 1.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ScaleTransition(
                      scale: _buttonAnimation,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _emailController.text.contains('@') &&
                              _passwordController.text.isNotEmpty) {
                            signIn();
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: const SizedBox(
                                  width: 500,
                                  height: 200,
                                  child: Center(
                                    child: Text("Please enter a valid email and password"),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Ok"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text('Login', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                          },
                          child: const Text("Register"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void signIn() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((user) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatMembers()));
        _emailController.clear();
        _passwordController.clear();
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Error: ${onError.toString()}");
      });
    }
  }
}
