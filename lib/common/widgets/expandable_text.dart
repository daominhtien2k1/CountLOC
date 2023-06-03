import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';


class ExpandableTextWidget extends StatefulWidget {
  final String text;
  final bool isHtml;

  ExpandableTextWidget({required this.text, required this.isHtml});

  @override
  _ExpandableTextWidgetState createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool isNotExpanded = true;

  Widget textOrHtmlWidget(String data) {
    if (widget.isHtml) {
      return Html(
          data: data,
          // body thì được nhưng còn top, html thì không được
          style: {"*": Style(padding: EdgeInsets.zero, margin: Margins.zero) }
      );
    } else {
      return Text(data);
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 100) {
      firstHalf = widget.text.substring(0, 100);
      secondHalf = widget.text.substring(100, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isNotExpanded = !isNotExpanded;
        });
      },
      child: Container(
        child: secondHalf.isEmpty
            ? textOrHtmlWidget(firstHalf)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  textOrHtmlWidget(isNotExpanded
                      ? (firstHalf + "...")
                      : (firstHalf + secondHalf)),
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          isNotExpanded ? "Xem thêm" : "Thu gọn",
                          style: TextStyle(color: Colors.pinkAccent),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        isNotExpanded = !isNotExpanded;
                      });
                    },
                  ),
                ],
        ),
      ),
    );
  }
}