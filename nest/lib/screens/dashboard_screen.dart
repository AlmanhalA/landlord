import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/landlord_provider.dart';
import '../widgets/app_modals.dart';
import 'profile_screen.dart';

// Tabs
import 'tabs/listings_tab.dart';
import 'tabs/requests_tab.dart';
import 'tabs/agreements_tab.dart'; 
import 'tabs/payments_tab.dart';   
import 'tabs/notifications_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // REMOVED 'const' keyword here. 
  // Lists containing Widgets usually shouldn't be const in stateful widgets.
  final List<Widget> _pages = [
    const ListingsTab(),
    const LeaseRequestsTab(),
    const AgreementsTab(),
    const PaymentsTab(),
    const NotificationsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context);
    // Removed unused 'isDark' variable
    final isEn = provider.language == 'en';

    return Scaffold(
      appBar: AppBar(
        title: Text(isEn ? 'Landlord' : 'المالك'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showDialog(context: context, builder: (_) => const SettingsDialog()),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.list), label: isEn ? 'Listings' : 'قوائم'),
          NavigationDestination(icon: const Icon(Icons.description), label: isEn ? 'Requests' : 'طلبات'),
          NavigationDestination(icon: const Icon(Icons.fact_check), label: isEn ? 'Contracts' : 'عقود'),
          NavigationDestination(icon: const Icon(Icons.attach_money), label: isEn ? 'Payments' : 'دفع'),
          NavigationDestination(
            // Accessing provider.notifications is now safe
            icon: Badge(
              isLabelVisible: provider.notifications.any((n) => n['read'] == false),
              child: const Icon(Icons.notifications),
            ),
            label: isEn ? 'Alerts' : 'تنبيهات',
          ),
        ],
      ),
    );
  }
}