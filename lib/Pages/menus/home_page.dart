import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final news = [
    {
      'title':
          'Saiba onde e como doar para famílias que perderam casas em incêndio no Bairro do Céu, em Manaus; confira os postos',
      'thumbnail':
          'https://s2-g1.glbimg.com/_i5qJl67pJKBTaau44224AmgLN0=/0x0:1600x902/1000x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_59edd422c0c84a879bd37670ae4f538a/internal_photos/bs/2024/q/N/2dCtGtT2yybsdYsUF5gQ/whatsapp-image-2024-01-21-at-12.36.39.jpeg',
      'url':
          'https://g1.globo.com/am/amazonas/noticia/2024/01/21/saiba-onde-e-como-doar-para-familias-que-perderam-casas-em-incendio-no-bairro-do-ceu-em-manaus-confira-os-postos.ghtml'
    },
    {
      'title':
          'Arquidiocese de Manaus reúne grupos vulneráveis durante abertura da Campanha da Fraternidade 2024',
      'thumbnail':
          'https://s2-g1.glbimg.com/xAhAXvJ31xOXZQS74oJuBEob-mI=/0x0:1345x713/1000x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_59edd422c0c84a879bd37670ae4f538a/internal_photos/bs/2024/U/j/7toiJmTYOu964Im0phmw/abertura-cf.png',
      'url':
          'https://g1.globo.com/am/amazonas/noticia/2024/02/14/arquidiocese-de-manaus-reune-grupos-de-vulneraveis-durante-abertura-da-campanha-da-fraternidade-2024.ghtml'
    },
    {
      'title':
          'Celebrando 60 anos de história, Campanha da Fraternidade 2024 é lançada em Porto Alegre',
      'thumbnail':
          'https://www.rbsdirect.com.br/filestore/5/8/8/5/1/9/4_2dcc88b160048e0/4915885_d78e2b1b9f8e241.jpg?w=700',
      'url':
          'https://gauchazh.clicrbs.com.br/comportamento/noticia/2024/02/celebrando-60-anos-de-historia-campanha-da-fraternidade-2024-e-lancada-em-porto-alegre-clsm756oi008d014lcxfzgk4w.html'
    }
  ];

  HomePage({super.key});

  Widget _buildCarousel(BuildContext context, int carouselIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          // you may want to use an aspect ratio here for tablet support
          height: 270.0,
          child: PageView.builder(
            itemCount: news.length,
            // store this controller in a State to save the carousel scroll position
            controller: PageController(viewportFraction: 0.9),
            itemBuilder: (BuildContext context, int itemIndex) {
              return _buildCarouselItem(context, carouselIndex, itemIndex);
            },
          ),
        )
      ],
    );
  }

  Widget _buildCarouselItem(
      BuildContext context, int carouselIndex, int itemIndex) {
    final thumbnail = news[itemIndex]['thumbnail'];
    final title = news[itemIndex]['title'];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 7,
              offset: const Offset(4, 8), // changes position of shadow
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 170,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  image: thumbnail != null
                      ? DecorationImage(
                          image: NetworkImage(news[itemIndex]['thumbnail']!),
                          fit: BoxFit.cover)
                      : null,
                  color: Colors.grey,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                title ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notícias',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        _buildCarousel(context, 0),
      ],
    );
  }
}
