import 'package:cosmetic_frontend/blocs/auth/auth_bloc.dart';
import 'package:cosmetic_frontend/blocs/auth/auth_event.dart';
import 'package:cosmetic_frontend/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';



class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  late PageController pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        body: SafeArea(
          child: PageView.builder(
            itemCount: 2,
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                _pageIndex = index;
              });
            },
            itemBuilder: (ctx,index) {
              if (index == 0)
                return OnboardWelcome(pageController: pageController);
              else
                return OnboardStart();
            }
          ),
        )
    );
  }
}

class OnboardWelcome extends StatelessWidget {
  final PageController pageController;

  OnboardWelcome({Key? key, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chào mừng !'),
        bottom: PreferredSize(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 72),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Vui lòng giới thiệu bản thân"),
                ],
              ),
            ),
            preferredSize: Size.zero),
        leading: BackButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            final firstTimeUseApp = await prefs.getBool('firstTimeUseApp');
            prefs.setBool('firstTimeUseApp', true); // nếu thoát thì vẫn là đăng nhập lần đầu
            if (context.mounted) {
              BlocProvider.of<AuthBloc>(context).add(BackFromOnboard());

            }
          },
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 380,
              height: 240,
              child: SvgPicture.asset("assets/illustrations/onboard1.svg"),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tên của bạn", style: Theme.of(context).textTheme.titleMedium),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Điền tên bạn',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text("Năm sinh", style: Theme.of(context).textTheme.titleMedium),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Điền năm sinh',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text("Giới tính", style: Theme.of(context).textTheme.titleMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 60,
                          width: 112,
                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, style: BorderStyle.solid),
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4))
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.male),
                              Text("Nam")
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 60,
                          width: 112,
                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, style: BorderStyle.solid),
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.female),
                              Text("Nữ")
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 60,
                          width: 112,
                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, style: BorderStyle.solid),
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4))
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.transgender),
                              Text("Khác")
                            ],
                          ),
                        ),
                      )
                    ],
                  )

                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  pageController.nextPage(duration: const Duration(microseconds: 300), curve: Curves.ease);
                },
                child: Text("Tiếp"),
              ),
            )
          ],
        ),
      )
    );
  }
}

class OnboardStart extends StatelessWidget {
  const OnboardStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 380,
              height: 240,
              child: SvgPicture.asset("assets/illustrations/onboard2.svg"),
            ),
            SizedBox(height: 20),
            Text("Chào mừng tới...!", style: Theme.of(context).textTheme.displaySmall),
            Text("Vui lòng trả lời câu hỏi để tìm ra bạn thuộc loại\nlàn da nào và nhận được những gợi ý tốt nhất"),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: FilledButton(onPressed: (){}, child: Text("Bắt đầu"))
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(onPressed: (){}, child: Text("Tôi đã biết loại da của tôi"))
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextButton(onPressed: (){
                BlocProvider.of<AuthBloc>(context).add(NextFromOnboard());
              }, child: Text("Bỏ qua và đi đến màn hình chính")),
            )
          ]
        ),
      ),
    );
  }
}
