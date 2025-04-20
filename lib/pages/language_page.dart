import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eluthozhi_v3/providers/login_state_provider.dart';
import 'package:provider/provider.dart';
import 'package:eluthozhi_v3/models/language_data.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final CollectionReference _languagesCollection = FirebaseFirestore.instance
      .collection('languages');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Language'),
              StreamBuilder<DocumentSnapshot>(
                stream: _languagesCollection.doc('tamil').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error fetching languages: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text('No languages available');
                  }

                  final data = snapshot.data!.get('data') as List<dynamic>;
                  final languages =
                      data.map((item) {
                        return LanguageData.fromFirestore(item);
                      }).toList();
                  print(languages);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final language = languages[index];
                      return ListTile(title: Text(language.name));
                    },
                  );
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Provider.of<LoginStateProvider>(
                    context,
                    listen: false,
                  ).logOut();
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, '/Login');
                  }
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
