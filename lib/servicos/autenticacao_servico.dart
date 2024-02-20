import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/Models/usuario_model.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AutenticacaoServico {
  AutenticacaoServico(this._context);

  late final BuildContext _context;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> createUserWithEmailAndPassword(String nome, String email,
      String senha, File? avatar, String telefonePessoal) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      String? fileURL;

      await credential.user?.updateDisplayName(nome);

      if (avatar != null) {
        final fileName = '${const Uuid().v4()}}${avatar!.path.split('.').last}';
        final fileRef = _firebaseStorage.ref(fileName);
        await fileRef.putFile(avatar!);
        final fileURL = await fileRef.getDownloadURL();
        //imagem do avatar
        await credential.user?.updatePhotoURL(fileURL);
      }

      final user = UserModel(
        avatar: fileURL,
        nome: nome,
        email: email,
        telefonePessoal: telefonePessoal,
      );

      // Salvar o usuário no Firestore na coleção "usuario"
      await _firestore
          .collection('usuario')
          .doc(credential.user!.uid)
          .set(user.toJson());

      return user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.toString() ?? 'Ocorreu um erro desconhecido')),
      );
    } catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
    return null;
  }

  Future<UserModel?> signInWithEmailAndPassword(
      String senha, String email) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      return UserModel(
        nome: credential.user?.displayName,
        avatar: credential.user?.photoURL,
        email: credential.user?.email,
        telefonePessoal: "", // Não temos o telefone ao fazer login
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.toString() ?? 'Ocorreu um erro desconhecido')),
      );
    } catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
    return null;
  }

  UserModel? getLoggerUser() {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }
    return UserModel(
        nome: user.displayName,
        email: user.email,
        avatar: user.photoURL,
        telefonePessoal:
            ""); // Não temos o telefone do usuário atualmente logado
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
