import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart'; // PDF 렌더링을 위한 패키지

void main() {
  runApp(const WoraApp());
}

class WoraApp extends StatelessWidget {
  const WoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WORA - Worship Sheet Alliance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 1. 로그인 및 회원가입 화면
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.music_note_rounded, size: 56, color: Colors.deepPurple),
                const SizedBox(height: 12),
                const Text(
                  'WORA',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
                const Text(
                  '실시간 찬양 악보 협업 플랫폼',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: '이메일 주소',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LobbyScreen()),
                      );
                    },
                    child: Text(
                      _isLogin ? '로그인' : '회원가입',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin ? '계정이 없으신가요? 회원가입' : '이미 계정이 있으신가요? 로그인'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 2. 로비 화면 (방 생성 / 참가 코드 입력)
class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('WORA 로비', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SheetCollaborationScreen(isLeader: true),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.deepPurple.shade200, width: 2),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add_circle_outline, size: 48, color: Colors.deepPurple),
                          SizedBox(height: 16),
                          Text(
                            '새로운 방 만들기',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '리더로서 악보를 공유하고 제어합니다.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: InkWell(
                    onTap: () => _showJoinCodeDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.group_outlined, size: 48, color: Colors.black54),
                          SizedBox(height: 16),
                          Text(
                            '참가 코드로 입장',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '코드를 입력하여 세션에 참여합니다.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showJoinCodeDialog(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('참가 코드 입력'),
        content: TextField(
          controller: codeController,
          decoration: InputDecoration(
            hintText: '6자리 코드 입력 (예: 482910)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SheetCollaborationScreen(isLeader: false),
                ),
              );
            },
            child: const Text('입장'),
          ),
        ],
      ),
    );
  }
}

// 3. 실제 PDF 악보 뷰어 및 실시간 협업 화면
class SheetCollaborationScreen extends StatefulWidget {
  final bool isLeader;
  const SheetCollaborationScreen({super.key, required this.isLeader});

  @override
  State<SheetCollaborationScreen> createState() => _SheetCollaborationScreenState();
}

class _SheetCollaborationScreenState extends State<SheetCollaborationScreen> {
  late PdfControllerPinch? _pdfController;
  bool _isPdfLoaded = false;
  String _currentChord = 'G Code';
  bool _isHighlighterActive = false;
  bool _isLaserActive = false;

  @override
  void initState() {
    super.initState();
    _loadPdfSample();
  }

  // PDF 샘플 로드 (실제 기기에서는 업로드된 PDF 파일 경로 또는 URL 연결)
  Future<void> _loadPdfSample() async {
    try {
      // 예시용 자산 또는 네트워크 PDF 초기화 (실제 구현 시 파일 업로드 연동)
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openAsset('assets/sample_sheet.pdf'), 
      );
      setState(() {
        _isPdfLoaded = true;
      });
    } catch (e) {
      // PDF 파일이 아직 없는 초기 상태를 위한 예외 처리 (시뮬레이션 모드 유지)
      setState(() {
        _isPdfLoaded = false;
      });
    }
  }

  @override
  void dispose() {
    if (_isPdfLoaded) {
      _pdfController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isLeader ? 'WORA 세션 [방 코드: 482910] (리더 모드)' : 'WORA 세션 (팀원 모드)'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Row(
        children: [
          // 좌측 도구 모음 (형광펜, 레이저포인터, Key 변경)
          Container(
            width: 70,
            color: Colors.grey.shade100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: _isHighlighterActive ? Colors.deepPurple : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _isHighlighterActive = !_isHighlighterActive;
                      _isLaserActive = false;
                    });
                  },
                  tooltip: '형광펜/메모',
                ),
                const SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.highlight_alt, color: _isLaserActive ? Colors.red : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _isLaserActive = !_isLaserActive;
                      _isHighlighterActive = false;
                    });
                  },
                  tooltip: '레이저 포인터',
                ),
                const SizedBox(height: 20),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      _currentChord = 'A Code (Key 변경)';
                    });
                  },
                  tooltip: 'Key 변경',
                ),
              ],
            ),
          ),
          // 중앙 실제 PDF 악보 뷰어 영역
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _isPdfLoaded && _pdfController != null
                          ? PdfViewPinch(
                              controller: _pdfController!,
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.picture_as_pdf, size: 64, color: Colors.deepPurple),
                                  const SizedBox(height: 16),
                                  Text(
                                    '[주님 말씀하시면] - $_currentChord',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'PDF 악보 파일 연동 대기 중 (상단 툴바에서 제어 가능)',
                                    style: TextStyle(color: Colors.grey, fontSize: 13),
                                  ),
                                  if (_isHighlighterActive)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Text('✏️ [형광펜 모드 활성화됨]', style: TextStyle(color: Colors.deepPurple)),
                                    ),
                                  if (_isLaserActive)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Text('🔴 [레이저 포인터 위치 송출 중]', style: TextStyle(color: Colors.red)),
                                    ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
                // 하단 상태 표시 바
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.isLeader ? '리더 제어 모드 (페이지 동기화 송출 중)' : '팀원 수신 모드 (리더 화면 자동 동기화)',
                        style: TextStyle(
                          color: widget.isLeader ? Colors.green : Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
