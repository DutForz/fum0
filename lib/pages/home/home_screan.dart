import 'package:flutter/material.dart';
import 'package:fumo/components/MyDrawer.dart';
import 'package:fumo/core/auth/auth_service.dart';
import 'package:fumo/extensions/context_extensions.dart';

class HomeScrean extends StatelessWidget {
  const HomeScrean({super.key});
  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localizations.home),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      drawer: Mydrawer(selectedLocale: Locale('en')),
    );
  }
}
