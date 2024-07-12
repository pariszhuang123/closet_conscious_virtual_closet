import 'package:flutter/material.dart';
import '../../core/widgets/button/navigation_type_button.dart';
import '../../core/data/type_data.dart';
import '../core/config/supabase_config.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final achievementsList = TypeDataList.drawerAchievements(context);
    final insightsList = TypeDataList.drawerInsights(context);
    final policyList = TypeDataList.drawerPolicy(context);
    final newsList = TypeDataList.drawerNews(context);
    final faqList = TypeDataList.drawerFaq(context);
    final contactUsList = TypeDataList.drawerContactUs(context);
    final deleteAccountList = TypeDataList.drawerDeleteAccount(context);
    final logOutList = TypeDataList.drawerLogOut(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Closet Conscious'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text('Menu'),
            ),
            NavigationTypeButton(
              label: achievementsList[0].getName(context),
              selectedLabel: '',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/achievements');
              },
              imagePath: achievementsList[0].imagePath!,
              isSelected: false,
              isAsset: true,
            ),
            NavigationTypeButton(
              label: insightsList[0].getName(context),
              selectedLabel: '',
              onPressed: () {
                Navigator.pop(context);
                _showUsageInsightsBottomSheet(context);
              },
              imagePath: insightsList[0].imagePath!,
              isSelected: false,
              isAsset: true,
            ),
            NavigationTypeButton(
              label: policyList[0].getName(context),
              selectedLabel: '',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/policy');
              },
              imagePath: policyList[0].imagePath!,
              isSelected: false,
              isAsset: policyList[0].isAsset,
            ),
            NavigationTypeButton(
              label: newsList[0].getName(context),
              selectedLabel: '',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/news');
              },
              imagePath: newsList[0].imagePath!,
              isSelected: false,
              isAsset: newsList[0].isAsset,
            ),
            NavigationTypeButton(
              label: faqList[0].getName(context),
              selectedLabel: '',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/faq');
              },
              imagePath: faqList[0].imagePath!,
              isSelected: false,
              isAsset: faqList[0].isAsset,
            ),
            NavigationTypeButton(
              label: contactUsList[0].getName(context),
              selectedLabel: '',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contact_us');
              },
              imagePath: contactUsList[0].imagePath!,
              isSelected: false,
              isAsset: contactUsList[0].isAsset,
            ),
            NavigationTypeButton(
              label: deleteAccountList[0].getName(context),
              selectedLabel: '',
              onPressed: () {
                Navigator.pop(context);
                _showDeleteAccountDialog(context);
              },
              imagePath: deleteAccountList[0].imagePath!,
              isSelected: false,
              isAsset: deleteAccountList[0].isAsset,
            ),
            NavigationTypeButton(
              label: logOutList[0].getName(context),
              selectedLabel: '',
              onPressed: () {
                Navigator.pop(context);
                _logOut(context);
              },
              imagePath: logOutList[0].imagePath!,
              isSelected: false,
              isAsset: logOutList[0].isAsset,
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Welcome to Closet Conscious!'),
      ),
    );
  }

  void _showUsageInsightsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const SizedBox(
          height: 200,
          child: Center(
            child: Text('Usage Insights Details Here'),
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Perform delete account action
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logOut(BuildContext context) async {
    // Capture the Navigator state
    final navigator = Navigator.of(context);

    // Perform log out action, e.g., Supabase sign out
    await SupabaseConfig.client.auth.signOut();

    // Use the captured Navigator state
    navigator.pushNamedAndRemoveUntil('/', (route) => false);
  }
}
