import 'package:cosmetic_frontend/blocs/event_detail/event_detail_bloc.dart';
import 'package:cosmetic_frontend/blocs/event_detail/event_detail_event.dart';
import 'package:cosmetic_frontend/blocs/event_detail/event_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../models/models.dart' hide Image;

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  EventDetailScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));
  }
  
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<EventDetailBloc>(context).add(EventDetailFetched(eventId: widget.eventId));
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Chi tiết sự kiện"),
        actions: [
          IconButton(
            onPressed: () async{
              await Share.share('https://youtu.be/EAs2A3h0Sd4');
            },
            icon: Icon(Icons.share_outlined)
          )
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<EventDetailBloc, EventDetailState>(
          builder: (context, state) {
            switch (state.eventDetailStatus) {
              case EventDetailStatus.initial:
                return CircularProgressIndicator();
              case EventDetailStatus.loading:
                return CircularProgressIndicator();
              case EventDetailStatus.failure:
                return Text("Failed");
              case EventDetailStatus.success: {
                final EventDetail eventDetail = state.eventDetail!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Image.network("${eventDetail.image.url}", height: 200, fit: BoxFit.fill)
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Tên sự kiện", style: Theme.of(context).textTheme.titleMedium),
                            Text(eventDetail.title, style: Theme.of(context).textTheme.bodyMedium),
                            SizedBox(height: 8),
                            Text("Thời gian", style: Theme.of(context).textTheme.titleMedium),
                            Text(eventDetail.time, style: Theme.of(context).textTheme.bodyMedium),
                            SizedBox(height: 8),
                            Text("Điều kiện tham gian", style: Theme.of(context).textTheme.titleMedium),
                            Text(eventDetail.participationCondition, style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      Html(
                          data: eventDetail.description,
                      )
                    ],
                  ),
                );
              }
            }
          },
        )
      ),
    );
  }
}
