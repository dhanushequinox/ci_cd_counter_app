import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CI/CD Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto', // or use GoogleFonts if added
      ),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage>
    with SingleTickerProviderStateMixin {
  int _count = 0;

  // For smooth count text animation
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 1, end: 1.2)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _count++;
    });
    _controller.forward();
  }

  void _decrement() {
    if (_count == 0) return;
    setState(() {
      _count--;
    });
    _controller.forward();
  }

  Widget buildCounter() {
    return ScaleTransition(
      scale: _animation,
      child: Text(
        '$_count',
        style: const TextStyle(
          fontSize: 100,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
          shadows: [
            Shadow(
              blurRadius: 8,
              color: Colors.deepPurpleAccent,
              offset: Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(
      {required IconData icon,
      required VoidCallback onPressed,
      required Color color,
      String? tooltip}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: color,
        elevation: 6,
        shadowColor: color.withOpacity(0.6),
      ),
      child: Icon(icon, size: 32, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text("CI/CD Counter App"),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Card(
          elevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'count for ci cd',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                buildCounter(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildButton(
              icon: Icons.remove,
              onPressed: _decrement,
              color: _count > 0 ? Colors.redAccent : Colors.grey.shade400,
              tooltip: 'Decrement',
            ),
            buildButton(
              icon: Icons.add,
              onPressed: _increment,
              color: Colors.yellow,
              tooltip: 'Increment',
            ),
          ],
        ),
      ),
    );
  }
}
