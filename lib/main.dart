import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const AceLedApp());
}

class AceLedApp extends StatelessWidget {
  const AceLedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String text = "ACELED";
  double position = 300;
  Color textColor = Colors.red;
  double speed = 2;
  bool blink = false;
  bool isVisible = true;

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    startRunningText();
    startBlink();
  }

  void startRunningText() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 30));
      setState(() {
        position -= speed;
        if (position < -800) {
          position = 300;
        }
      });
      return true;
    });
  }

  void startBlink() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (blink) {
        setState(() {
          isVisible = !isVisible;
        });
      }
      return true;
    });
  }

  void updateText() {
    setState(() {
      text = controller.text.isEmpty ? "ACELED" : controller.text;
      position = 300;
    });
  }

  Widget colorButton(Color color) {
    return GestureDetector(
      onTap: () => setState(() => textColor = color),
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 30,
        height: 30,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  Widget dotText() {
    return isVisible
        ? Text(
      text,
      style: TextStyle(
        fontSize: 50,
        color: textColor,
        fontWeight: FontWeight.bold,
        letterSpacing: 3,
        shadows: [
          Shadow(
            blurRadius: 10,
            color: textColor,
          )
        ],
      ),
    )
        : const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Masukkan teks...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            ElevatedButton(
              onPressed: updateText,
              child: const Text("Tampilkan"),
            ),

            ElevatedButton(
              onPressed: () => setState(() => blink = !blink),
              child: Text(blink ? "Blink ON" : "Blink OFF"),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                colorButton(Colors.red),
                colorButton(Colors.green),
                colorButton(Colors.blue),
                colorButton(Colors.yellow),
              ],
            ),

            const Text("Kecepatan",
                style: TextStyle(color: Colors.white)),

            Slider(
              value: speed,
              min: 1,
              max: 10,
              onChanged: (value) => setState(() => speed = value),
            ),

            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    left: position,
                    top: MediaQuery.of(context).size.height / 3,
                    child: dotText(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}