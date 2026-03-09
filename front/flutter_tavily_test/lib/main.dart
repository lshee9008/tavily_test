import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const ProSearchApp());
}

class ProSearchApp extends StatelessWidget {
  const ProSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Pretendard', // 폰트가 있다면 적용
      ),
      home: const MainSearchScreen(),
    );
  }
}

// --- 공통 글라스모피즘 컨테이너 ---
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 15.0,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}

// --- 메인 화면 ---
class MainSearchScreen extends StatefulWidget {
  const MainSearchScreen({super.key});

  @override
  State<MainSearchScreen> createState() => _MainSearchScreenState();
}

class _MainSearchScreenState extends State<MainSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _answer;
  List<dynamic> _results = [];

  String get apiUrl => Platform.isAndroid
      ? "http://10.0.2.2:8000/api/v1/search"
      : "http://localhost:8000/api/v1/search";

  Future<void> _onSearch() async {
    if (_controller.text.isEmpty) return;
    HapticFeedback.mediumImpact(); // 진동 효과

    setState(() {
      _isLoading = true;
      _answer = null;
      _results = [];
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"query": _controller.text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _answer = data['answer'];
          _results = data['results'];
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // 배경 배경 빛 효과
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.2),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _isLoading ? _buildLoading() : _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GlassContainer(
        opacity: 0.05,
        child: TextField(
          controller: _controller,
          onSubmitted: (_) => _onSearch(),
          decoration: InputDecoration(
            hintText: "AI에게 무엇이든 물어보세요...",
            hintStyle: const TextStyle(color: Colors.white38),
            prefixIcon: const Icon(
              Icons.auto_awesome,
              color: Colors.blueAccent,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send, color: Colors.blueAccent),
              onPressed: _onSearch,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.blueAccent),
          SizedBox(height: 20),
          Text("웹 데이터를 분석 중입니다...", style: TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_answer == null && _results.isEmpty) {
      return const Center(
        child: Text("결과가 여기에 표시됩니다.", style: TextStyle(color: Colors.white24)),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        if (_answer != null) ...[
          _buildAiCard(_answer!),
          const SizedBox(height: 25),
        ],
        ..._results.asMap().entries.map(
          (entry) => _buildResultItem(entry.value, entry.key),
        ),
      ],
    );
  }

  Widget _buildAiCard(String text) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GlassContainer(
        opacity: 0.15,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "🤖 AI SUMMARY",
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultItem(dynamic res, int index) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.elasticOut, // 튀어오르는 효과
      builder: (context, value, child) {
        return Transform.scale(
          scale: value.clamp(0.0, 1.0), // 에러 방지용 clamp
          child: Opacity(
            opacity: value.clamp(0.0, 1.0), // 에러 방지용 clamp
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(res['url'])),
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                res['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                res['content'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white38, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Text(
                res['url'],
                style: const TextStyle(color: Colors.blueAccent, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
