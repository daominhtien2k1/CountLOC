import 'package:flutter/material.dart';

import '../../../routes.dart';

class FancyFab extends StatefulWidget {
  final String productId;

  FancyFab({required this.productId});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  final double _fabHeight = 56.0;

  @override
  initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });

    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _buttonColor = ColorTween(
      begin: Color(0xFF67DD8D),
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));

    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: Curves.linear,
      ),
    ));

    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: _buttonColor.value,
      onPressed: animate,
      tooltip: 'Mở',
      heroTag: "primary",
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3,
            0.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(isOpened) Chip(label: Text('Hướng dẫn và chia sẻ cảm nhận')),
              if(isOpened) SizedBox(width: 8),
              FloatingActionButton(
                heroTag: "btn3",
                elevation: 0,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.instruction_create_review_screen, arguments: widget.productId);
                },
                tooltip: 'Hướng dẫn và chia sẻ cảm nhận',
                child: Icon(Icons.newspaper),
              ),
            ],
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2,
            0.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(isOpened) Chip(label: Text('Đánh giá sản phẩm')),
              if(isOpened) SizedBox(width: 8),
              FloatingActionButton(
                heroTag: "btn2",
                elevation: 0,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.quick_create_review_screen, arguments: widget.productId);
                },
                tooltip: 'Đánh giá sản phẩm',
                child: Icon(Icons.reviews_outlined),
              ),
            ],
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(isOpened) Chip(label: Text('Tạo bài viết')),
              if(isOpened) SizedBox(width: 8),
              FloatingActionButton(
                heroTag: "btn1",
                elevation: 0,
                onPressed: null,
                tooltip: 'Tạo bài viết',
                child: Icon(Icons.edit_note, size: 30)
              ),
            ],
          ),
        ),
        toggle(),
      ],
    );
  }
}