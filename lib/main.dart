import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Super40 Academy',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.indigo,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x8c8a37c1),
      body: Center(
        child: Hero(
          tag: 'app_logo',
          child: Image.asset(
            'assets/logo.png',
            width: 350,
            height: 350,
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'app_logo',
              child: Image.asset(
                'assets/logo.png',
                width: 32,
                height: 32,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Super40 Academy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          return;
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildWelcomeSection(context),
              _buildFacultySection(context),
              _buildSocialLinks(context),
              const SizedBox(height: 32),
              _buildGetStartedButton(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLinks(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connect With Us',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(
                context,
                icon: Icons.facebook,
                color: const Color(0xFF1877F2),
                url: 'https://www.facebook.com/super40school',
              ),
              _buildSocialButton(
                context,
                icon: Icons.ondemand_video,
                color: const Color(0xFFFF0000),
                url: 'https://www.youtube.com/@super40govindsir99',
              ),
              _buildSocialButton(
                context,
                icon: Icons.camera_alt,
                color: const Color(0xff8e205a),
                url: 'https://www.instagram.com/super40schoolvns',
              ),
              _buildSocialButton(
                context,
                icon: Icons.language,
                color: const Color(0xFF2196F3),
                url: 'https://www.thesuper40.com',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context,
      {required IconData icon, required Color color, required String url}) {
    return InkWell(
      onTap: () async {
        try {
          final Uri uri = Uri.parse(url);
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('An error occurred while opening the link'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      children: [
        // Image Slider Section
        Container(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 4,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                'assets/slid${index + 1}.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50),
                ),
              );
            },
          ),
        ),

        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      'Welcome to Excellence',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Premier Sainik School Entrance Exam Coaching',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Why Choose Us Section
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why Choose Us?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Column(
                      children: [
                        _buildDetailItem(
                            'CBSE Pattern (Play Group to Class 8th)',
                            'Quality education from the foundation years'),
                        _buildDetailItem(
                            'Foundation Classes (9th, 10th, 11th, and 12th)',
                            'Strong preparation for board exams and competitive exams'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Available Courses Section
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Courses',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Column(
                      children: [
                        _buildListItem('IIT-JEE'),
                        _buildListItem('NEET'),
                        _buildListItem('CUET'),
                        _buildListItem('Crash Course for Classes 10th & 12th'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Special Entrance Exam Section
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Special Entrance Exam Preparation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Column(
                      children: [
                        _buildListItem('CHS (Central Hindu School)'),
                        _buildListItem('RMS (Rashtriya Military School)'),
                        _buildListItem(
                            'RIMC (Rashtriya Indian Military College)'),
                        _buildListItem('All India Sainik School Entrance Exam'),
                        _buildListItem('Banasthali Vidyapith'),
                        _buildListItem('Rai Sports School'),
                        _buildListItem('Gurukul School'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Scholarship Program Section
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scholarship Program',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(text: '🎓 '),
                              TextSpan(
                                text:
                                    'Free Education for 40 Meritorious Students\n',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '💰 Scholarships worth '),
                              TextSpan(
                                text: 'up to ₹12 Lakhs annually',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '📅 Scholarship Exam Date: 23rd February 2025 (Sunday)',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '📅 Form Distribution Starts: 25th December 2024',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Features Section
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our Features',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Column(
                      children: [
                        _buildDetailItem('AC Classrooms & AC Transport',
                            'Comfortable learning environment'),
                        _buildDetailItem('Smart Classes',
                            'Modern education with smart boards'),
                        _buildDetailItem('Computer Lab & Library',
                            'Fully equipped for research and study'),
                        _buildDetailItem('Hostel Facility',
                            'Separate for boys and girls with 24x7 security'),
                        _buildDetailItem('Weekly Tests',
                            'Regular evaluation for better performance'),
                        _buildDetailItem('English-Speaking Course',
                            'Build confidence in communication'),
                        _buildDetailItem('Cultural and Sports Activities',
                            'Dedicated playground and physical education'),
                        _buildDetailItem('CCTV Secured Campus',
                            'Complete safety and surveillance'),
                        _buildDetailItem('24x7 Medical Facility',
                            'Immediate health assistance'),
                        _buildDetailItem('RO Water & Wi-Fi Campus',
                            'Modern amenities for students'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Branches Section
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our Branches',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Column(
                      children: [
                        _buildBranchItem(
                            'Main Branch', 'Benipur, Pahariya, Varanasi'),
                        _buildBranchItem('S.R.S. Junior High School'),
                        _buildBranchItem('S.D. Public School'),
                        _buildBranchItem('Triumph Education Hub'),
                        _buildBranchItem('Rafale Academy'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Quick Actions Section
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuickActionButton(
                      context,
                      Icons.video_library,
                      'Video Lectures',
                    ),
                    _buildQuickActionButton(
                      context,
                      Icons.assignment,
                      'Practice Tests',
                    ),
                    _buildQuickActionButton(
                      context,
                      Icons.support_agent,
                      'Support',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// Helper methods for building list items
  Widget _buildDetailItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchItem(String name, [String? location]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (location != null) TextSpan(text: ': $location'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
      BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFacultySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Expert Faculty',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return _buildFacultyTile(
                _getFacultyData(index),
                Colors.primaries[index % Colors.primaries.length],
              );
            },
          ),
        ],
      ),
    );
  }

  Map<String, String> _getFacultyData(int index) {
    final List<Map<String, String>> facultyData = [
      {
        'name': 'Govind Sir',
        'role': 'Director',
        'description': 'Leading expert in entrance exam preparation',
        'color': 'blue',
        'image': 'assets/teacher1.jpg'
      },
      {
        'name': 'Rajeev Sir',
        'role': 'Managing Director',
        'description': 'Strategic leadership and management',
        'color': 'deepPurple',
        'image': 'assets/teacher2.jpg'
      },
      {
        'name': 'Col. SK Dixit Sir Retd.',
        'role': 'Principal Advisor',
        'description': 'Military and academic excellence advisor',
        'color': 'red',
        'image': 'assets/teacher3.jpg'
      },
      {
        'name': 'Pooja Ma\'am',
        'role': 'Director of Special Projects',
        'description': 'Strategic initiatives and project management',
        'color': 'green',
        'image': 'assets/teacher4.jpg'
      },
      {
        'name': 'Rathour Sir',
        'role': 'Mathematics Expert',
        'description': 'Specialized in advanced mathematics',
        'color': 'amber',
        'image': 'assets/teacher5.jpg'
      },
      {
        'name': 'Sandeep Sir',
        'role': 'Reasoning Expert',
        'description': 'Master of logical and analytical reasoning',
        'color': 'orange',
        'image': 'assets/teacher6.jpg'
      },
      {
        'name': 'Himanshu Sir',
        'role': 'Science & Mathematics',
        'description': 'Dual expertise in science and mathematics',
        'color': 'teal',
        'image': 'assets/teacher7.jpg'
      },
      {
        'name': 'Roshni Ma\'am',
        'role': 'Science Specialist',
        'description': 'Expert in scientific concepts and applications',
        'color': 'purple',
        'image': 'assets/teacher8.jpg'
      },
      {
        'name': 'Puneet Sir',
        'role': 'GS Expert',
        'description': 'Specialized in General Studies',
        'color': 'indigo',
        'image': 'assets/teacher9.jpg'
      },
      {
        'name': 'Anjali Ma\'am',
        'role': 'Hindi Language',
        'description': 'Expert in Hindi literature and grammar',
        'color': 'pink',
        'image': 'assets/teacher10.jpg'
      },
    ];

    return facultyData[index % facultyData.length];
  }

  Widget _buildFacultyTile(Map<String, String> data, Color color) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(data['image']!),
          onBackgroundImageError: (exception, stackTrace) => Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
            ),
            child: Icon(Icons.person, color: color),
          ),
        ),
        title: Text(
          data['name']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['role']!,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
            Text(
              data['description']!,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildGetStartedButton(BuildContext context) {
  return Center(
    child: ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
      icon: const Icon(Icons.login),
      label: const Text(
        'Get Started',
        style: TextStyle(fontSize: 18),
      ),
    ),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildLoginForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Hero(
              tag: 'app_logo',
              child: Icon(
                Icons.school,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isLogin ? 'Welcome Back' : 'Create Account',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              obscureText: !isPasswordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            if (!isLogin) ...[
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardPage()),
                  );
                }
              },
              child: Text(
                isLogin ? 'Login' : 'Register',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(
                isLogin ? 'Create new account' : 'Already have an account?',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  final List<Widget> _pages = const [
    StudentProfilePage(),
    VideosPage(),
    PDFsPage(),
    TestSheetsPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _tabController.animateTo(index);
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library),
              label: 'Videos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.picture_as_pdf),
              label: 'PDFs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Tests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({Key? key}) : super(key: key);

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  Widget _buildTextField(String label,
      {int maxLines = 1, bool readOnly = false, String? initialValue}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        maxLines: maxLines,
        readOnly: !_isEditing || readOnly,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isEditing = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile Updated Successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildProfileImage(),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildTextField('Name', initialValue: 'John Doe'),
                        _buildTextField('Father Name', initialValue: 'Mr. Doe'),
                        _buildTextField('Date of Birth',
                            initialValue: '01/01/2010'),
                        _buildTextField('Address',
                            maxLines: 3,
                            initialValue:
                                '123 Main Street\nCity, State\nPIN: 123456'),
                        _buildTextField('Mobile',
                            initialValue: '+91 9876543210'),
                        _buildTextField('School',
                            initialValue: 'City Public School'),
                        _buildTextField('Class', initialValue: 'Class 8'),
                        _buildTextField('Subscription Details',
                            readOnly: true,
                            initialValue: 'Premium Plan (Valid till Dec 2025)'),
                      ],
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

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),
          if (_isEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.camera_alt, size: 20, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class VideosPage extends StatelessWidget {
  const VideosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Lectures')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.play_circle_filled,
                    color: Colors.white, size: 32),
              ),
              title: Text(
                'Lecture ${index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text('Duration: 45 minutes'),
                  const SizedBox(height: 4),
                  Text(
                    'Click to watch',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Video Player...')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class PDFsPage extends StatelessWidget {
  const PDFsPage({Key? key}) : super(key: key);

  static const List<String> subjects = [
    'English',
    'Hindi',
    'Social Science',
    'GK',
    'History',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Materials')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return Card(
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Icon(
                  Icons.subject,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(
                subjects[index],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              children: [
                _buildPDFTile(context, 'Chapter 1: Introduction', '2.5 MB'),
                _buildPDFTile(
                    context, 'Chapter 2: Advanced Concepts', '3.1 MB'),
                _buildPDFTile(context, 'Practice Questions', '1.8 MB'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPDFTile(BuildContext context, String title, String size) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
      title: Text(title),
      subtitle: Text('Size: $size'),
      trailing: IconButton(
        icon: Icon(Icons.download, color: Theme.of(context).primaryColor),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Downloading PDF...'),
              action: SnackBarAction(
                label: 'CANCEL',
                onPressed: () {},
              ),
            ),
          );
        },
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening PDF...')),
        );
      },
    );
  }
}

class TestSheetsPage extends StatelessWidget {
  const TestSheetsPage({Key? key}) : super(key: key);

  static const List<String> subjects = [
    'English',
    'Hindi',
    'Social Science',
    'GK',
    'History',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Sheets')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return Card(
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green[100],
                child: const Icon(
                  Icons.assignment,
                  color: Colors.green,
                ),
              ),
              title: Text(
                subjects[index],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              children: [
                _buildTestTile(
                    context, 'Practice Test 1', '45 minutes', '25 questions'),
                _buildTestTile(
                    context, 'Practice Test 2', '60 minutes', '30 questions'),
                _buildTestTile(
                    context, 'Final Test', '90 minutes', '50 questions'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTestTile(
      BuildContext context, String title, String duration, String questions) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      leading: const Icon(Icons.edit_note, color: Colors.green),
      title: Text(title),
      subtitle: Text('$duration • $questions'),
      trailing: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Starting Test...')),
          );
        },
        child: const Text('Start'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Duration: $duration'),
                Text('Questions: $questions'),
                const SizedBox(height: 16),
                const Text('Are you ready to start the test?'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Starting Test...')),
                  );
                },
                child: const Text('START'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange[100],
                    child:
                        const Icon(Icons.notifications, color: Colors.orange),
                  ),
                  title: const Text('Notifications'),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple[100],
                    child: const Icon(Icons.language, color: Colors.purple),
                  ),
                  title: const Text('Language'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: const Icon(Icons.help, color: Colors.blue),
                  ),
                  title: const Text('Help & Support'),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal[100],
                    child: const Icon(Icons.info, color: Colors.teal),
                  ),
                  title: const Text('About Us'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.red),
                    title: Text('Email'),
                    subtitle: Text('support@super40academy.com'),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, color: Colors.green),
                    title: Text('Phone'),
                    subtitle: Text('+91 1234567890'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
