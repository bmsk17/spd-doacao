class InstituicaoModel {
  String? nome;
  String? descricao;
  String? endereco;
  String? telefone;
  String? longitude;
  String? latitude;
  String? site;
  String? imagem;

  InstituicaoModel(
      {this.nome,
      this.descricao,
      this.endereco,
      this.telefone,
      this.longitude,
      this.latitude,
      this.site,
      this.imagem});

  InstituicaoModel.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    descricao = json['descricao'];
    endereco = json['endereco'];
    telefone = json['telefone'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    site = json['site'];
    imagem = json['imagem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['endereco'] = this.endereco;
    data['telefone'] = this.telefone;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['site'] = this.site;
    data['imagem'] = this.imagem;
    return data;
  }
}

/*  var instt = instituicaoModel(
      nome:
          "Congregação das Irmãs Missionárias da Caridade - Madre Tereza de Calcutá",
      descricao:
          "Congregação das Irmãs Missionárias da Caridade - Madre Tereza de Calcutá",
      endereco: "R. Dom Bôsco, 129 - Coroado, Manaus - AM, 69080-370",
      telefone: "09236441972",
      longitude: "-59.98453804483101",
      latitude: "-3.086530591032546",
      site: "",
      imagem: "",
    );

    await db.collection("instituicao").add(instt.toJson()); */