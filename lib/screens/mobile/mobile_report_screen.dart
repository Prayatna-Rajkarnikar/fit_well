import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  final List<int> monthlyData = [5, 10, 9, 8, 3, 8, 6, 6];
  final List<String> monthLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Report', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Workout History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                  Row(
                    children: [
                      Text('Month', style: TextStyle(color: Colors.white70)),
                      Icon(Icons.arrow_drop_down, color: Colors.white70),
                    ],
                  )
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  FilterChip(label: Text('Water'), selected: true, onSelected: (_) {}, backgroundColor: Colors.grey[800], selectedColor: Colors.white),
                  SizedBox(width: 8),
                  FilterChip(label: Text('Step'), selected: false, onSelected: (_) {}, backgroundColor: Colors.grey[800]),
                ],
              ),
              SizedBox(height: 40),
              Expanded(
                child: CustomPaint(
                  painter: BarChartPainter(monthlyData: monthlyData, monthLabels: monthLabels),
                  child: Container(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: 1,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<int> monthlyData;
  final List<String> monthLabels;

  BarChartPainter({required this.monthlyData, required this.monthLabels});

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / (monthlyData.length * 2);
    final maxHeight = monthlyData.reduce((a, b) => a > b ? a : b).toDouble();

    final paint = Paint()
      ..color = Colors.orange
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    final textStyle = TextStyle(color: Colors.white, fontSize: 10);
    final textPainter = TextPainter(textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    for (int i = 0; i < monthlyData.length; i++) {
      final x = (i * 2 + 1) * barWidth;
      final heightRatio = monthlyData[i] / maxHeight;
      final barHeight = size.height * heightRatio * 0.7;

      final rect = Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight);
      canvas.drawRect(rect, paint);

      final label = monthLabels[i];
      textPainter.text = TextSpan(text: label, style: textStyle);
      textPainter.layout();
      textPainter.paint(canvas, Offset(x + barWidth / 2 - textPainter.width / 2, size.height - textPainter.height));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
