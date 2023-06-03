import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widgets/personal_widgets.dart';
import '../../../blocs/personal_info/personal_info_bloc.dart';
import '../../../blocs/personal_info/personal_info_event.dart';
import '../../../blocs/personal_info/personal_info_state.dart';

class EditProfileScreen extends StatelessWidget {
  void setName(BuildContext context)  {
    TextEditingController _textFieldController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nhập tên '),
            content: TextField(
              onChanged: (value) {
                // name =
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Tên"),
            ),
            actions: [
              OutlinedButton(
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue)),
                onPressed: () {
                  BlocProvider.of<PersonalInfoBloc>(context).add(
                      SetNameUser(
                          name: _textFieldController.value.text));
                  BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
                  Navigator.pop(context);
                },
                child: Text('Xác nhận',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              OutlinedButton(
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey.shade200)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              )
            ],
          );
        });
  }
  void setDes(BuildContext context)  {
    TextEditingController _textFieldController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nhập mô tả '),
            content: TextField(
              onChanged: (value) {
                // name =
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Tên"),
            ),
            actions: [
              OutlinedButton(
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue)),
                onPressed: () {
                  BlocProvider.of<PersonalInfoBloc>(context).add(
                      SetDescriptionUser(
                          description: _textFieldController.value.text));
                  BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
                  Navigator.pop(context);
                },
                child: Text('Xác nhận',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              OutlinedButton(
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey.shade200)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              )
            ],
          );
        });
  }
  void setCity(BuildContext context)  {
    TextEditingController _textFieldController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nhập thành phố '),
            content: TextField(
              onChanged: (value) {
                // name =
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Tên"),
            ),
            actions: [
              OutlinedButton(
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue)),
                onPressed: () {
                  BlocProvider.of<PersonalInfoBloc>(context).add(
                      SetCityUser(
                          city: _textFieldController.value.text));
                  BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
                  Navigator.pop(context);
                },
                child: Text('Xác nhận',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              OutlinedButton(
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey.shade200)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              )
            ],
          );
        });
  }
  void setCountry(BuildContext context)  {
    TextEditingController _textFieldController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nhập đất nước '),
            content: TextField(
              onChanged: (value) {
                // name =
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Tên"),
            ),
            actions: [
              OutlinedButton(
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue)),
                onPressed: () {
                  BlocProvider.of<PersonalInfoBloc>(context).add(
                      SetCountryUser(
                          country: _textFieldController.value.text));
                  BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
                  Navigator.pop(context);
                },
                child: Text('Xác nhận',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              OutlinedButton(
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey.shade200)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              )
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Chỉnh sửa trang cá nhân',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Ảnh đại diện",
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      )),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => AvatarBottomSheet());
                        },
                        child: Text(
                          "Chỉnh sửa",
                          style: TextStyle(
                              fontSize: 17.0, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  AvtGestureDetector(),
                  const SizedBox(height: 20.0),
                  const Divider(
                    height: 0.0,
                    thickness: 1.0,
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Ảnh bìa",
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      )),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => CoverBottomSheet());
                        },
                        child: Text(
                          "Chỉnh sửa",
                          style: TextStyle(
                              fontSize: 17.0, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  CoverImageGestureDetector(),
                  const SizedBox(height: 20.0),
                  const Divider(
                    height: 0.0,
                    thickness: 1.0,
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                            "Mô tả",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          )),
                      GestureDetector(
                        onTap: () {
                          setDes(context);
                        },
                        child: Text(
                          "Chỉnh sửa",
                          style: TextStyle(
                              fontSize: 17.0, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  DescriptionGestureDetector(),
                  const SizedBox(height: 20.0),
                  const Divider(
                    height: 0.0,
                    thickness: 1.0,
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                            "Tên hiển thi",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          )),
                      GestureDetector(
                        onTap: () {
                          setName(context);
                        },
                        child: Text(
                          "Chỉnh sửa",
                          style: TextStyle(
                              fontSize: 17.0, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  NameGestureDetector(),
                  const SizedBox(height: 20.0),
                  const Divider(
                    height: 0.0,
                    thickness: 1.0,
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                            "Thành phố",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          )),
                      GestureDetector(
                        onTap: () {
                          setCity(context);
                        },
                        child: Text(
                          "Chỉnh sửa",
                          style: TextStyle(
                              fontSize: 17.0, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  CityGestureDetector(),
                  const SizedBox(height: 20.0),
                  const Divider(
                    height: 0.0,
                    thickness: 1.0,
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                            "Quốc gia",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          )),
                      GestureDetector(
                        onTap: () {
                          setCountry(context);
                        },
                        child: Text(
                          "Chỉnh sửa",
                          style: TextStyle(
                              fontSize: 17.0, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  CountryGestureDetector(),
                ],
              ),
          )),
        ],
      ),
    );
  }
}



class AvtGestureDetector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => AvatarBottomSheet());
            },
            child: CircleAvatar(
              radius: 80.0,
              backgroundImage:
              CachedNetworkImageProvider(userInfo.avatar),
            ),
          );
        });
  }
}


class CoverImageGestureDetector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => CoverBottomSheet());
            },
            child: Container(
              width: double.infinity,
              height: 220.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image:
                    CachedNetworkImageProvider(userInfo.coverImage),
                    fit: BoxFit.cover,
                  )),
            ),
          );
        });
  }
}


class DescriptionGestureDetector extends EditProfileScreen {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          return GestureDetector(
            onTap: () {
              setDes(context);
            },
            child: Text(userInfo.description,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 15.0)),
          );
        });
  }
}

class NameGestureDetector extends EditProfileScreen {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          return GestureDetector(
            onTap: () {
              setName(context);
            },
            child: Text(userInfo.name,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 15.0)),
          );
        });
  }
}

class CityGestureDetector extends EditProfileScreen {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          return GestureDetector(
            onTap: () {
              setCity(context);
            },
            child: Text(userInfo.city,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 15.0)),
          );
        });
  }
}
class CountryGestureDetector extends EditProfileScreen {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          return GestureDetector(
            onTap: () {
              setCountry(context);
            },
            child: Text(userInfo.country,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 15.0)),
          );
        });
  }
}


