import 'package:cloud_firestore/cloud_firestore.dart';

class DoacaoModel {
  String? idDoacao; // Renomeado para usar camelCase
  String? descricao;
  String? endereco;
  String? emailDoador;
  String? emailReceptor;
  String? status;
  String? imageUrl;
  DateTime dataCriacao = DateTime.now();
  DateTime dataConclusao = DateTime.now();

  // Construtor
  DoacaoModel({
    this.idDoacao,
    this.descricao,
    this.endereco,
    this.emailDoador,
    this.emailReceptor,
    this.status,
    this.imageUrl,
  });

  // Método para criar uma instância de DoacaoModel a partir de um mapa JSON
  DoacaoModel.fromJson(Map<String, dynamic> json) {
    idDoacao = json['id_doacao'] as String?;
    descricao = json['descricao'] as String?;
    endereco = json['endereco'] as String?;
    emailDoador = json['email_doador'] as String?;
    emailReceptor = json['email_receptor'] as String?;
    status = json['status'] as String?;
    imageUrl = json['imagemUrl'] as String?;
    dataCriacao = (json['data_criacao'] as Timestamp).toDate();
    dataConclusao = (json['data_conclusao'] as Timestamp).toDate();
  }

  // Método para converter uma instância de DoacaoModel em um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id_doacao': idDoacao,
      'descricao': descricao,
      'endereco': endereco,
      'email_doador': emailDoador,
      'email_receptor': emailReceptor,
      'status': status,
      'imagemUrl': imageUrl,
      'data_criacao': Timestamp.fromDate(dataCriacao),
      'data_conclusao': Timestamp.fromDate(dataConclusao),
    };
  }
}
