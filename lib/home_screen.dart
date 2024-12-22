import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('images/silence.jpg'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Silent Mode Automation',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/settings'),
                child: const Text('Go to Settings'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/about'),
                child: const Text('About App'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/sound'),
                child: const Text('Sound Screen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
