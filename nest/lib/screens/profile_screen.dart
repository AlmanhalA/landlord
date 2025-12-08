import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/landlord_provider.dart';
import '../widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context);
    final isEn = provider.language == 'en';

    return Scaffold(
      appBar: AppBar(title: Text(isEn ? 'Profile' : 'الملف الشخصي')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, backgroundColor: Colors.cyan, child: Icon(Icons.person, size: 40, color: Colors.white)),
            const SizedBox(height: 24),
            ProfileField(label: isEn ? 'Full Name' : 'الاسم', hint: 'Enter name'),
            ProfileField(label: isEn ? 'Email' : 'بريد', hint: 'Enter email'),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {},
              child: Text(isEn ? 'Save Changes' : 'حفظ'),
            ),
            const Divider(height: 48),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                provider.logout();
              }, 
            ),
          ],
        ),
      ),
    );
  }
}