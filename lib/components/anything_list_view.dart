import 'package:flutter/material.dart';

class AnythingListView extends StatelessWidget {
  AnythingListView(
      {required this.titles,
      this.subtitles,
      this.icons,
      required this.onTapTile});

  final List titles;
  final List? subtitles;
  final List? icons;
  final Function onTapTile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: onTapTile as void Function()?,
              title: Text(titles[index]),
              subtitle: Text(subtitles![index]),
              leading: CircleAvatar(
                child: Image.asset('images/logo.png'),
              ),
              trailing: Icon(
                icons![index],
              ),
            ),
          );
        },
      ),
    );
  }
}
