import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'auth/login_screen.dart';
import 'edit_profile_screen.dart';
import 'home_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authP = context.watch<AuthProvider>();
    final themeP = context.watch<ThemeProvider>();
    final user = authP.user!;

    return Scaffold(
      backgroundColor:
      themeP.isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor:
        themeP.isDarkMode ? Colors.grey[850] : Colors.white,
        foregroundColor:
        themeP.isDarkMode ? Colors.white : Colors.black87,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- Avatar ---
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.indigo.shade400,
              child: Text(
                user.username.isNotEmpty
                    ? user.username[0].toUpperCase()
                    : "?",
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- User Info ---
            Text(
              user.username,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: themeP.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 15,
                color: themeP.isDarkMode
                    ? Colors.grey[400]
                    : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),

            // --- Card Section ---
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: themeP.isDarkMode ? Colors.grey[850] : Colors.white,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // --- Edit Profile ---
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text("Edit Profile"),
                      trailing:
                      const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    Divider(
                      color: themeP.isDarkMode
                          ? Colors.grey[700]
                          : Colors.grey[300],
                    ),

                    // --- Theme Switch ---
                    ListTile(
                      leading: Icon(
                        themeP.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                      title: Text(
                        themeP.isDarkMode
                            ? "Switch to Light Mode"
                            : "Switch to Dark Mode",
                      ),
                      onTap: () {
                        context.read<ThemeProvider>().toggleTheme();
                      },
                    ),
                    Divider(
                      color: themeP.isDarkMode
                          ? Colors.grey[700]
                          : Colors.grey[300],
                    ),

                    // --- Logout ---
                    ListTile(
                      leading:
                      const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        context.read<AuthProvider>().logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                              (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // --- Back to Dashboard Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.dashboard),
                label: const Text("Back to Dashboard"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // --- Footer ---
            Text(
              "TaskMate v1.0.0",
              style: TextStyle(
                fontSize: 13,
                color: themeP.isDarkMode
                    ? Colors.grey[500]
                    : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
