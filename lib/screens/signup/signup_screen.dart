import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'dart:io';
import 'dart:async';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/signup/signup_bloc.dart';
import '../../blocs/signup/signup_state.dart';
import '../../blocs/signup/signup_event.dart';

class SignupScreen extends StatefulWidget {
  final bool x;
  const SignupScreen({Key? key, this.x = false}) : super(key: key);
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  var deviceInfo = {
    'devtype': 1,
    'devtoken': '',
  };

  bool passToggle = true;
  bool passToggle1 = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      setState(() {
        deviceInfo = {'devtype': 1, 'devtoken': androidInfo.id};
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      setState(() {
        deviceInfo = {
          'devtype': 1,
          'devtoken': iosInfo.identifierForVendor ?? ''
        };
      });
    }
  }

  String? phone;
  String? password;
  String? phoneValidator (String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Số điện thoại không được để trống';
    }
    RegExp regPhone = RegExp(r'^0\d{9}$');
    if(!regPhone.hasMatch(phone)) {
      return 'Sai định dạng số điện thoại';
    }
    return null;
  }

  String? passwordValidator (String? password) {
    if (password == null || password.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    RegExp regChar = RegExp(r'^[\w_]{6,30}$');
    RegExp regPhone = RegExp(r'^0\d{9}$');
    if(regPhone.hasMatch(password)) {
      return 'Định dạng mật khẩu giống với định dạng điện thoại';
    }
    if(!regChar.hasMatch(password)) {
      return 'Mật khẩu phải từ 6-30 kí tự';
    }
    return null;
  }
  String? RepasswordValidator (String? password) {
    if (password == null || password.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    RegExp regChar = RegExp(r'^[\w_]{6,30}$');
    RegExp regPhone = RegExp(r'^0\d{9}$');
    if(regPhone.hasMatch(password)) {
      return 'Định dạng mật khẩu giống với định dạng điện thoại';
    }
    if(!regChar.hasMatch(password)) {
      return 'Mật khẩu phải từ 6-30 kí tự';
    }
    return null;
  }

  void savePhone (String? phoneValue) {
    setState(() {
      phone = phoneValue;
    });
  }

  void savePassword (String? passwordValue) {
    setState(() {
      password = passwordValue;
    });
  }

  final formStateKey = GlobalKey<FormState>();
  void submitForm(BuildContext context) async {
    if (formStateKey.currentState?.validate() ?? true) { // Khi form gọi hàm validate thì tất cả các TextFormField sẽ gọi hàm validate. Hàm validate trả về true là thành công, false là thất bại
      // print('#Validate: Trước khi save: Phone: ${phone} và Password: ${password}');
      formStateKey.currentState?.save(); // khi form gọi hàm save thì tất cả các TextFormField sẽ gọi hàm save
      // print('#Validate: Sau khi save: Phone: ${phone} và Password: ${password}');
      BlocProvider.of<SignupBloc>(context).add(Signup(phone: phone!, password: password!));

    } else {
      // print('#Validate: Validate thất bại. Vui lòng thử lại');
    }
  }
  @override
  Widget build(BuildContext context) {
    final SignupBloc signupBloc = BlocProvider.of<SignupBloc>(context);
    bool isHiddenKeyboard = MediaQuery.of(context).viewInsets.bottom == 0;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, isHiddenKeyboard ? 80 : 50, 0, 0),
          child: Form(
            key: formStateKey,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        'Cosmetica',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary)
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(40, isHiddenKeyboard ? 60 : 40, 40, 0),                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 11),
                                  //Change this value to custom as you like
                                  isDense: true,
                                  // and add this line
                                  hintText: 'Số điện thoại'
                              ),
                              validator: phoneValidator,
                              onSaved: savePhone,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                                obscureText: passToggle,
                                decoration: InputDecoration(
                                    contentPadding:
                                    EdgeInsets.symmetric(vertical: 11),
                                    //Change this value to custom as you like
                                    isDense: true,
                                    // and add this line
                                    hintText: 'Mật khẩu',
                                    suffixIcon: InkWell(
                                      onTap:(){
                                        setState(() {
                                          passToggle = !passToggle;
                                        });
                                      },
                                      child: Icon(
                                          passToggle ? Icons.visibility : Icons.visibility_off
                                      ),
                                    )
                                ),
                                validator: passwordValidator,
                                onSaved: savePassword
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                                obscureText: passToggle1,
                                decoration: InputDecoration(
                                    contentPadding:
                                    EdgeInsets.symmetric(vertical: 11),
                                    //Change this value to custom as you like
                                    isDense: true,
                                    // and add this line
                                    hintText: 'Nhập lại mật khẩu',
                                    suffixIcon: InkWell(
                                      onTap:(){
                                        setState(() {
                                          passToggle1 = !passToggle1;
                                        });
                                      },
                                      child: Icon(
                                          passToggle1 ? Icons.visibility : Icons.visibility_off
                                      ),
                                    )
                                ),
                                validator: passwordValidator,
                                onSaved: savePassword
                            ),
                            BlocBuilder<SignupBloc, SignupState>(
                                builder: (context, state) {
                                  switch (state.status) {
                                    case SignupStatus.initial: {
                                      return Container(
                                        child:
                                        SizedBox(width: 10,),
                                        alignment: Alignment.bottomCenter,
                                        height: 25,);
                                    }
                                    case SignupStatus.success: {

                                      return Column(
                                        children: [
                                          Container(
                                            child:
                                            Row(
                                              children: [
                                                Icon(Icons.download_done_outlined,
                                                  color: Colors.green,
                                                  size: 18,),
                                                SizedBox(width: 5,),
                                                Text(
                                                    "Đăng kí thành công, nhấn tiếp tục để hoàn tất",
                                                    style: TextStyle(color: Colors.green)
                                                ),
                                              ],
                                              mainAxisAlignment: MainAxisAlignment.center,
                                            ),
                                            alignment: Alignment.bottomCenter,
                                            height: 25,),
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            height: 40, //height of button
                                            width: 150, //width of button
                                            child: ElevatedButton(
                                              onPressed: () {
                                                BlocProvider.of<AuthBloc>(context).add(Logout());
                                                BlocProvider.of<SignupBloc>(context).add(afterSignUp());
                                                Navigator.pop(context);
                                              },
                                              child: Text('Tiếp tục'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                textStyle:
                                                TextStyle(fontWeight: FontWeight.bold),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(30)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    case SignupStatus.userExist: return Container(
                                      child:
                                        Row(
                                          children: [
                                            Icon(Icons.error,
                                              color: Colors.red,
                                              size: 18,),
                                            SizedBox(width: 5,),
                                            Text(
                                                "Số điện thoại đã được người dùng khác sử dụng",
                                                style: TextStyle(color: Colors.red)
                                            ),
                                          ],
                                        ),
                                      alignment: Alignment.bottomCenter,
                                      height: 25,);
                                    case SignupStatus.failure: return Container(
                                      child:
                                      Row(
                                        children: [
                                          Icon(Icons.error,
                                            color: Colors.red,
                                            size: 18,),
                                          SizedBox(width: 5,),
                                          Text(
                                              "Tạo tài khoản không thành công, hãy thử lại",
                                              style: TextStyle(color: Colors.red)
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.bottomCenter,
                                      height: 25,);
                                    default: return Container(
                                      child:
                                      SizedBox(width: 10,),
                                      alignment: Alignment.bottomCenter,
                                      height: 25,);
                                  }
                                } ),

                            Container(
                              margin: EdgeInsets.only(top: 50),
                              width: 150, //width of button
                              child: ElevatedButton(
                                onPressed: () {
                                  submitForm(context);
                                },
                                child: Text('Đăng kí'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Đã có tài khoản')),
                            ),
                          ],
                        ))
                  ]),
            ),
          ),
        ));
  }

}

class CustomAlertDialog extends StatelessWidget {
  final Color bgColor;
  final String? title;
  final String? message;
  final double circularBorderRadius;

  CustomAlertDialog({
    this.title,
    this.message,
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,

  })  : assert(bgColor != null),
        assert(circularBorderRadius != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: message != null ? Text(message!) : null,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),
      actions: [
        TextButton(onPressed: (){Navigator.pop(context);}, child: Text("OK"))

      ],
    );
  }
}
