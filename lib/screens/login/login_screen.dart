import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../routes.dart';

import '../signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool fail ;
  const LoginScreen({Key? key, this.fail = false}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  var deviceInfo = {
    'devtype': 1,
    'devtoken': '',
  };

  bool passToggle = true;

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
      BlocProvider.of<AuthBloc>(context).add(Login(phone: phone!, password: password!));

      // để logic ở UI sẽ bị chậm không cập nhật. Chuyển logic vào trong auth_bloc
      // lấy thông tin người dùng và lưu vào cache
      // final userInfo = BlocProvider.of<AuthBloc>(context).state.authUser;
      // final _id = userInfo.id;
      // final _name = userInfo.name;
      // final _token = userInfo.token;
      // Map<String, dynamic> user = {'id': _id, 'name': _name, 'token': _token};
      // final prefs = await SharedPreferences.getInstance();
      // print("#Login: "+user.toString()); // đang làm ở đây
      // await prefs.setString('user', jsonEncode(user));

      // Bởi vì cập nhật state bằng Bloc nên không cần push từ Login
      // Navigator.push(context, MaterialPageRoute(builder: (context) => NavScreen()));
    } else {
      // print('#Validate: Validate thất bại. Vui lòng thử lại');
    }
  }
  @override
  Widget build(BuildContext context) {
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
                          padding: EdgeInsets.fromLTRB(40, isHiddenKeyboard ? 104 : 40, 40, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 11),
                                  isDense: true,
                                  hintText: 'Điện thoại hoặc email'
                                ),
                                validator: phoneValidator,
                                onSaved: savePhone,
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                  obscureText: passToggle,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 11),
                                    isDense: true,
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
                              widget.fail
                              ? Container(child:
                                  Row(
                                    children: [
                                      Icon(Icons.error,
                                        color: Colors.red,
                                        size: 18),
                                      SizedBox(width: 5,),
                                      Text(
                                        "Tên đăng nhập hoặc mật khẩu không chính xác",
                                        style: TextStyle(color: Colors.red)
                                        ),
                                    ],
                                  ),
                                  alignment: Alignment.bottomCenter,
                                  height: 25,)
                              : SizedBox(height:25,width: 10,),
                              Container(
                                margin: EdgeInsets.only(top: 50),
                                width: double.infinity, //width of button
                                child: ElevatedButton(
                                  onPressed: () {
                                    submitForm(context);
                                  },
                                  child: Text('Đăng nhập')
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    print(deviceInfo);
                                  },
                                  child: Text('Quên mật khẩu?')),
                              SizedBox(height: 50),
                              Text(
                                "HOẶC",
                                style: TextStyle(fontSize: 12, color: Colors.black38),
                              ),
                              SizedBox(height: 12),
                              Container(
                                height: 40, //height of button
                                width: 150, //width of button
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(Routes.signup_screen);
                                  },
                                  child: Text('Đăng kí')
                                ),
                              ),
                            ],
                          ))
                    ]),
              ),
            )));
  }
}
