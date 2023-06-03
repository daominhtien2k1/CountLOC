import 'package:cosmetic_frontend/routes.dart';
import 'package:flutter/material.dart';

import '../../../models/models.dart' hide Image;

class EventContainer extends StatelessWidget {
  final Event event;
  EventContainer({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.event_detail_screen, arguments: event.id);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Theme.of(context).colorScheme.tertiaryContainer
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                // child: Image.asset("assets/images/event1.png", height: 150,  fit: BoxFit.fill)
                child: Image.network("${event.image.url}", height: 150,  fit: BoxFit.fill),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4, top: 12),
              child: Text("${event.title}",
              style: Theme.of(context).textTheme.titleSmall),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Row(
                children: [
                  Icon(Icons.remove_red_eye_outlined),
                  SizedBox(width: 4),
                  Text("${event.clicks}"),
                  Spacer(),
                  Icon(Icons.access_time),
                  SizedBox(width: 4),
                  Text("${event.remainingTime}")
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
