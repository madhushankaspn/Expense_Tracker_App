import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // අලුතින් එකතු කළා
import 'dart:convert'; // අලුතින් එකතු කළා

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  // Python ML එකෙන් එන ඇත්තම අගය දාන්න Variables හදාගන්නවා
  double _mlForecastAmount =
      4850.00; // API එක වැඩ නොකරුවොත් පරණ ගානම Default තියෙනවා
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMLForecast(); // Screen එක open වෙද්දීම API එකට කෝල් කරනවා
  }

  // Node.js හරහා Database එකේ තියෙන ML Forecast එක ගන්නා ශ්‍රිතය
  Future<void> _fetchMLForecast() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/forecast/2'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _mlForecastAmount = data['forecast'];
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching forecast: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark Background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFD700)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'FINANCE',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[800],
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analytics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Precision insights for your curated lifestyle.',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 24),

            // 1. Next Month Forecast Card (දැන් මේක ඇත්තම දත්ත එක්ක වැඩ කරනවා)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.sensors, color: Color(0xFFFFD700), size: 16),
                      SizedBox(width: 8),
                      Text(
                        'NEXT MONTH FORECAST',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // දත්ත लोड වෙනකන් 'Loading...' පෙන්වනවා, ආවට පස්සේ ඇත්තම ගාන පෙන්වනවා
                      Text(
                        _isLoading
                            ? "Loading..."
                            : "\$${_mlForecastAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Fake mini chart line
                      SizedBox(
                        width: 60,
                        height: 30,
                        child: CustomPaint(painter: _MiniChartPainter()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(
                        Icons.trending_down,
                        color: Color(0xFF2EBC84),
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Predicted 4% decrease',
                        style: TextStyle(
                          color: Color(0xFF2EBC84),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Spending by Category Card (Monthly Summary)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SPENDING BY CATEGORY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Custom Doughnut Chart
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 20,
                            color: Colors.grey[800], // Background ring
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: CircularProgressIndicator(
                            value: 0.7, // 70%
                            strokeWidth: 20,
                            color: const Color(0xFF2EBC84), // Green part
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: CircularProgressIndicator(
                            value: 0.45, // 45%
                            strokeWidth: 20,
                            color: const Color(0xFFFFD700), // Gold part
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'TOTAL',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              '\$5,240',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Category Breakdown (Legend)
                  _buildLegendItem(
                    const Color(0xFFFFD700),
                    'Food & Dining',
                    '\$2,358',
                  ),
                  const SizedBox(height: 12),
                  _buildLegendItem(Colors.grey, 'Rent & Living', '\$1,834'),
                  const SizedBox(height: 12),
                  _buildLegendItem(
                    const Color(0xFF2EBC84),
                    'Travel',
                    '\$1,048',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Weekly Trends Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'WEEKLY TRENDS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        'Last 7 Days',
                        style: TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Bar Chart Placeholder
                  SizedBox(
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBar('M', 60),
                        _buildBar('T', 40),
                        _buildBar('W', 80),
                        _buildBar('T', 120, isHighlighted: true),
                        _buildBar('F', 50),
                        _buildBar('S', 90),
                        _buildBar('S', 30),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Insight Box inside Trends
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(
                          Icons.lightbulb,
                          color: Color(0xFFFFD700),
                          size: 16,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Your spending peaked on Thursday due to dining. Consider adjusting next week's travel budget.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white54,
        currentIndex: 1, // Reports Selected
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 4, backgroundColor: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        Text(
          amount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBar(String day, double height, {bool isHighlighted = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 8,
          height: height,
          decoration: BoxDecoration(
            color: isHighlighted ? const Color(0xFFFFD700) : Colors.white24,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            color: isHighlighted ? Colors.white : Colors.white54,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _MiniChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFFFD700)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
      size.width * 0.25,
      0,
      size.width * 0.5,
      size.height / 2,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height,
      size.width,
      size.height / 4,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
