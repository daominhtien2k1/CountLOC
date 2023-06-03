import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostInfo extends StatelessWidget {
  final String avtUrl;
  final String name;
  final String? status;
  PostInfo({Key? key, required this.avtUrl, required this.name, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("#Post_info: $status");
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22.0,
            backgroundImage: CachedNetworkImageProvider(avtUrl),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(text: '$name ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                        if(status != null) TextSpan(text: 'hiện đang cảm thấy ',  style: TextStyle(color: Colors.black, fontSize: 16)),
                        if(status != null) TextSpan(text: '$status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis
                  ),
                  SizedBox(height: 8),
                  TextButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black45),
                        foregroundColor: Colors.black45,
                        splashFactory: NoSplash.splashFactory,
                        padding: EdgeInsets.all(12)
                      ),
                      onPressed: () {},
                      child: Text('Góc hỏi đáp')
                  )
                ],
              ),
            ),
          )
        ]
      )
    );
  }


}
