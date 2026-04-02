import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.blue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: const Text(
          "PaymentVerifier",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [

                // STATUS CARD

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [

                      const CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: const [

                          Text(
                            "Service Online",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Ready to verify payments",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // BUTTONS

                buildButton(
                  text: "Create Payment",
                  icon: Icons.payment,
                  color: Colors.blue,
                  onTap: () {
                    print("Create Payment");
                  },
                ),

                buildButton(
                  text: "Verify Payment",
                  icon: Icons.verified,
                  color: Colors.green,
                  onTap: () {
                    print("Verify Payment");
                  },
                ),

                buildButton(
                  text: "Recent Transactions",
                  icon: Icons.history,
                  color: Colors.orange,
                  onTap: () {
                    print("History");
                  },
                ),

                const Spacer(),

                // FOOTER

                const Text(
                  "Payment Verification Service",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 10),

              ],
            ),
          ),
        ),
      ),
    );
  }
}