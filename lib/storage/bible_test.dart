import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class BibleTest extends StatelessWidget {
  final String _xml = '''<?xml version="1.0"?>
    <bookshelf>
      <book id="2">
        <title lang="english">Genesis</title>
        <price>30.00</price>
      </book>
      <book id="GEN">
        <title lang="english">Learning XML</title>
        <price>40.00</price>
      </book>
      <price>132.00</price>
    </bookshelf>''';

  @override
  Widget build(BuildContext context) {
    final XmlDocument document = XmlDocument.parse(_xml);

    final String textual = document.descendants
        .where((node) => node is XmlText && node.text.trim().isNotEmpty)
        .join('\n');
    print(textual);

    final titleNodes = document.findAllElements('title');

    titleNodes.map((node) {
      return node.text;
    }).forEach(print);

    print('Attribute is: ');
    print(
        document.nodes.map((node) => node.findAllElements('book')).toString());
    // document.getAttributeNode('book', namespace: 'id="2"');
    // print(document.getAttribute('book'));

    //  print(document.getAttributeNode('book').findElements('title').single.toString());

    // .map((node) {
    //   // print(node.findElements('title').single.text);
    //   //
    //   // node.findElements('book').where((element) {
    //   //   element.attributes.last.value == 'id="2"';
    //   // });

    //   // return node.getElement('title').value;
    //   // return node.attributes.first.toString();
    //   print(node.name.toString());
    //   return node.findElements('title').single.toString();
    // }).forEach(print);

    // final totalPrice =
    //     document.findAllElements('book', namespace: 'id="GEN"').map((node) {
    //   return double.parse(node.findElements('price').single.text);
    // }).reduce((value, element) => value + element);
    // print(totalPrice);
    //
    CachedNetworkImage(
      cacheKey: '1',
      imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/goconnect-745e7.appspot.com/o/images%2Ffashion.png?alt=media&token=f2e8484d-6874-420c-9401-615063e53b8d",
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),value: downloadProgress.progress),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: CachedNetworkImageProvider(
                  'https://firebasestorage.googleapis.com/v0/b/goconnect-745e7.appspot.com/o/images%2Ffashion.png?alt=media&token=f2e8484d-6874-420c-9401-615063e53b8d',
                  cacheKey: '1'),
            ),
            // Image.network(
            //   'https://firebasestorage.googleapis.com/v0/b/goconnect-745e7.appspot.com/o/images%2Ffashion.png?alt=media&token=f2e8484d-6874-420c-9401-615063e53b8d',
            //   scale: 0.1,
            // ),
          ],
        ),
      ),
    );
  }
}
