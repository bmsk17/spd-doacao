class DoacaoModel {
  String? id_doacao; // Renomeado para usar snake_case
  String? descricao;
  String? endereco;
  bool? status;
  String? imagemUrl;

  // Construtor
  DoacaoModel({
    this.id_doacao,
    this.descricao,
    this.endereco,
    this.status,
    this.imagemUrl,
  });

  // Método para criar uma instância de DoacaoModel a partir de um mapa JSON
  DoacaoModel.fromJson(Map<String, dynamic> json) {
    id_doacao = json['id_doacao'] as String?;
    descricao = json['descricao'] as String?;
    endereco = json['endereco'] as String?;
    status = json['status'] as bool?;
    imagemUrl = json['imagemUrl'] as String?;
  }

  // Método para converter uma instância de DoacaoModel em um mapa JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_doacao'] = id_doacao;
    data['descricao'] = descricao;
    data['endereco'] = endereco;
    data['status'] = status;
    data['imagemUrl'] = imagemUrl;
    return data;
  }
}
