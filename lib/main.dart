import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Tahoma',
      ),
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
        indicatorColor: const Color(0xFF10B981),
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

// 1. لوحة التحكم
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
                  Text('مرحباً بك', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14)),
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
                      SizedBox(width: 70, height: 70, child: CircularProgressIndicator(value: 0.5, strokeWidth: 8, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(Colors.white))),
                      const Text('50%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      Text('استمر في التقدم!', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
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
}

// 2. شاشة المهام (مع الحفظ)
class TasksTab extends StatefulWidget {
  const TasksTab({super.key});
  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  List<Map<String, dynamic>> _tasks = [];
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      setState(() {
        _tasks = List<Map<String, dynamic>>.from(jsonDecode(tasksString));
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', jsonEncode(_tasks));
  }

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
                      _saveTasks();
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: _tasks.isEmpty 
              ? const Center(child: Text('لا توجد مهام بعد', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, i) {
                final t = _tasks[i];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Checkbox(
                      value: t['done'], activeColor: const Color(0xFF10B981),
                      onChanged: (v) {
                        setState(() => _tasks[i]['done'] = v);
                        _saveTasks();
                      },
                    ),
                    title: Text(
                      t['title'], style: TextStyle(color: t['done'] ? Colors.white54 : Colors.white, decoration: t['done'] ? TextDecoration.lineThrough : null),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        setState(() => _tasks.removeAt(i));
                        _saveTasks();
                      },
                    ),
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

// 3. شاشة العادات (مع الحفظ)
class HabitsTab extends StatefulWidget {
  const HabitsTab({super.key});
  @override
  State<HabitsTab> createState() => _HabitsTabState();
}

class _HabitsTabState extends State<HabitsTab> {
  List<Map<String, dynamic>> _habits = [];
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsString = prefs.getString('habits');
    if (habitsString != null) {
      setState(() {
        _habits = List<Map<String, dynamic>>.from(jsonDecode(habitsString));
      });
    }
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('habits', jsonEncode(_habits));
  }

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
                hintText: 'أضف عادة جديدة...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true, fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFF10B981)),
                  onPressed: () {
                    if (_ctrl.text.isNotEmpty) {
                      setState(() => _habits.add({'name': _ctrl.text, 'done': false, 'color': '0xFF10B981'}));
                      _ctrl.clear();
                      _saveHabits();
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: _habits.isEmpty 
              ? const Center(child: Text('لا توجد عادات بعد', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _habits.length,
              itemBuilder: (context, i) {
                final h = _habits[i];
                final color = Color(int.parse(h['color']));
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        setState(() => _habits[i]['done'] = !_habits[i]['done']);
                        _saveHabits();
                      },
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: h['done'] ? color : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: color, width: 2),
                        ),
                        child: h['done'] ? const Icon(Icons.check, color: Colors.white) : null,
                      ),
                    ),
                    title: Text(h['name'], style: TextStyle(color: h['done'] ? Colors.white54 : Colors.white, fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        setState(() => _habits.removeAt(i));
                        _saveHabits();
                      },
                    ),
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