import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const NabdApp());
}

class NabdApp extends StatelessWidget {
  const NabdApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نَبْض',
      theme: ThemeData.dark(useMaterial3: true, fontFamily: 'Tahoma'),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          DashboardTab(),
          TasksTab(),
          HabitsTab(),
          FocusTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF1E293B),
        indicatorColor: const Color(0xFF10B981).withOpacity(0.2),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: Color(0xFF10B981)), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.check_circle_outline), selectedIcon: Icon(Icons.check_circle, color: Color(0xFF10B981)), label: 'المهام'),
          NavigationDestination(icon: Icon(Icons.local_fire_department_outlined), selectedIcon: Icon(Icons.local_fire_department, color: Color(0xFF10B981)), label: 'العادات'),
          NavigationDestination(icon: Icon(Icons.timer_outlined), selectedIcon: Icon(Icons.timer, color: Color(0xFF10B981)), label: 'التركيز'),
        ],
      ),
    );
  }
}

// 1. لوحة التحكم الرئيسية
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('مساء الخير، هاشم', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text('كيف حالك اليوم؟', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              const CircleAvatar(backgroundColor: Color(0xFF10B981), child: Text('H', style: TextStyle(color: Colors.white))),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF0EA5E9)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 70, height: 70,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(width: 70, height: 70, child: CircularProgressIndicator(value: 0.75, strokeWidth: 8, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(Colors.white))),
                      const Text('75%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('إنجاز اليوم', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('عمل رائع! استمر في التقدم', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _statCard('مهام', '3/5', Icons.check_circle, const Color(0xFF10B981)),
              const SizedBox(width: 10),
              _statCard('عادات', '2/4', Icons.local_fire_department, Colors.orangeAccent),
              const SizedBox(width: 10),
              _statCard('تركيز', '45د', Icons.timer, const Color(0xFF0EA5E9)),
            ],
          ),
          const SizedBox(height: 24),
          const Text('حكمة اليوم', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
            ),
            child: const Text('"الانضباط هو الجسر بين الأهداف والإنجاز."', style: TextStyle(color: Colors.white, fontSize: 15, fontStyle: FontStyle.italic)),
          )
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// 2. شاشة المهام
class TasksTab extends StatefulWidget {
  const TasksTab({super.key});
  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'قراءة 10 صفحات', 'done': true},
    {'title': 'إنهاء تقرير العمل', 'done': false},
    {'title': 'ممارسة الرياضة', 'done': false},
  ];
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _ctrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'أضف مهمة جديدة...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true, fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFF10B981)),
                  onPressed: () {
                    if (_ctrl.text.isNotEmpty) {
                      setState(() { _tasks.add({'title': _ctrl.text, 'done': false}); _ctrl.clear(); });
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, i) {
                final t = _tasks[i];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Checkbox(
                      value: t['done'], activeColor: const Color(0xFF10B981),
                      onChanged: (v) => setState(() => _tasks[i]['done'] = v),
                    ),
                    title: Text(
                      t['title'], style: TextStyle(color: t['done'] ? Colors.white54 : Colors.white, decoration: t['done'] ? TextDecoration.lineThrough : null),
                    ),
                    trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => setState(() => _tasks.removeAt(i))),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 3. شاشة العادات
class HabitsTab extends StatefulWidget {
  const HabitsTab({super.key});
  @override
  State<HabitsTab> createState() => _HabitsTabState();
}

class _HabitsTabState extends State<HabitsTab> {
  final List<Map<String, dynamic>> _habits = [
    {'name': 'شرب الماء', 'streak': 5, 'done': true, 'color': const Color(0xFF0EA5E9)},
    {'name': 'القراءة', 'streak': 12, 'done': false, 'color': Colors.amber},
    {'name': 'المشي', 'streak': 3, 'done': false, 'color': const Color(0xFF10B981)},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _habits.length,
        itemBuilder: (context, i) {
          final h = _habits[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: GestureDetector(
                onTap: () => setState(() => _habits[i]['done'] = !_habits[i]['done']),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: h['done'] ? h['color'] : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: h['color'], width: 2),
                  ),
                  child: h['done'] ? const Icon(Icons.check, color: Colors.white) : null,
                ),
              ),
              title: Text(h['name'], style: TextStyle(color: h['done'] ? Colors.white54 : Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 16),
                  const SizedBox(width: 4),
                  Text('${h['streak']} أيام متتالية', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// 4. شاشة التركيز
class FocusTab extends StatefulWidget {
  const FocusTab({super.key});
  @override
  State<FocusTab> createState() => _FocusTabState();
}

class _FocusTabState extends State<FocusTab> {
  int _seconds = 25 * 60;
  bool _isRunning = false;
  Timer? _timer;

  void _toggle() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_seconds > 0) {
          setState(() => _seconds--);
        } else {
          t.cancel();
          setState(() => _isRunning = false);
        }
      });
    }
    setState(() => _isRunning = !_isRunning);
  }

  String get _timeString {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('وقت التركيز', style: TextStyle(color: Colors.white70, fontSize: 18)),
            const SizedBox(height: 32),
            SizedBox(
              width: 240, height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(width: 240, height: 240, child: CircularProgressIndicator(value: _seconds / (25 * 60), strokeWidth: 12, backgroundColor: Colors.white12, valueColor: const AlwaysStoppedAnimation(Color(0xFF10B981)))),
                  Text(_timeString, style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _toggle,
              icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
              label: Text(_isRunning ? 'إيقاف مؤقت' : 'ابدأ التركيز', style: const TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            )
          ],
        ),
      ),
    );
  }
}