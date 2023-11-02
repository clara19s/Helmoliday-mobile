import 'package:flutter/material.dart';

class ThumbnailTileItem extends StatelessWidget {
  const ThumbnailTileItem({
    super.key,
    required this.thumbnail,
    required this.title,
    required this.body,
    required this.footer,
  });

  final Widget thumbnail;
  final String title;
  final String body;
  final String footer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _TileBody(
                  title: title,
                  body: body,
                  footer: footer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TileBody extends StatelessWidget {
  const _TileBody(
      {required this.title, required this.body, required this.footer});

  final String title;
  final String body;
  final String footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 2.0)),
        Expanded(
          child: Text(
            body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
        ),
        Text(
          footer,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
