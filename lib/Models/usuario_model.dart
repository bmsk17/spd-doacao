class UserModel {
  String? nome;
  String? email;
  String? senha;
  String? avatar;

  UserModel({this.nome, this.email, this.senha, this.avatar});

  UserModel.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    email = json['email'];
    senha = json['senha'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['avatar'] = this.avatar;
    return data;
  }
}
