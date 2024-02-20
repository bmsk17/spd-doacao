class UserModel {
  String? nome;
  String? email;
  String? senha;
  String? avatar;
  String? telefonePessoal; // Adicionando o campo telefonePessoal

  UserModel(
      {this.nome, this.email, this.senha, this.avatar, this.telefonePessoal});

  UserModel.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    email = json['email'];
    senha = json['senha'];
    avatar = json['avatar'];
    telefonePessoal = json[
        'telefonePessoal']; // Adicionando o telefonePessoal ao construtor fromJson
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['avatar'] = this.avatar;
    data['telefonePessoal'] =
        this.telefonePessoal; // Adicionando o telefonePessoal ao método toJson
    return data;
  }
}
