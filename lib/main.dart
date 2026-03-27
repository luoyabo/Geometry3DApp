import 'package:flutter/material.dart';
import 'package:flutter_3d_view/flutter_3d_view.dart';
import 'screens/angle_demo.dart';
import 'screens/theorem_demo.dart';
import 'screens/knowledge_screen.dart';

void main() {
  runApp(const Geometry3DApp());
}

class Geometry3DApp extends StatelessWidget {
  const Geometry3DApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '立体几何学习',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('立体几何学习'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '欢迎使用立体几何学习App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '选择以下模块开始学习：',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                children: [
                  _buildFeatureCard(
                    context,
                    title: '3D形状',
                    subtitle: '立方体、球体等',
                    icon: Icons.cube,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShapeViewScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    title: '线面角',
                    subtitle: '直线与平面的夹角',
                    icon: Icons.angle_right,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AngleDemoScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    title: '二面角',
                    subtitle: '两个平面的夹角',
                    icon: Icons.vertical_align_center,
                    color: Colors.orange,
                    onTap: () {
                      // TODO: 添加二面角演示
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('二面角演示正在开发中'),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    title: '三垂线定理',
                    subtitle: '空间几何重要定理',
                    icon: Icons.call_made,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TheoremDemoScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    title: '知识点',
                    subtitle: '立体几何概念讲解',
                    icon: Icons.menu_book,
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KnowledgeScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    title: '练习题',
                    subtitle: '巩固所学知识',
                    icon: Icons.quiz,
                    color: Colors.teal,
                    onTap: () {
                      // TODO: 添加练习题
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('练习题模块正在开发中'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 原有的形状查看屏幕
class ShapeViewScreen extends StatefulWidget {
  const ShapeViewScreen({super.key});

  @override
  State<ShapeViewScreen> createState() => _ShapeViewScreenState();
}

class _ShapeViewScreenState extends State<ShapeViewScreen> {
  double _rotateX = 0.0;
  double _rotateY = 0.0;
  double _scale = 1.0;
  ThreeDShape _currentShape = ThreeDShape.cube;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _rotateY += details.delta.dx * 0.01;
      _rotateX += details.delta.dy * 0.01;
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale *= details.scale;
    });
  }

  void _nextShape() {
    setState(() {
      // 切换形状：立方体 -> 球体 -> 圆柱体 -> 圆锥体 -> 立方体
      switch (_currentShape) {
        case ThreeDShape.cube:
          _currentShape = ThreeDShape.sphere;
          break;
        case ThreeDShape.sphere:
          _currentShape = ThreeDShape.cylinder;
          break;
        case ThreeDShape.cylinder:
          _currentShape = ThreeDShape.cone;
          break;
        case ThreeDShape.cone:
          _currentShape = ThreeDShape.cube;
          break;
        default:
          _currentShape = ThreeDShape.cube;
      }
      // 重置视图
      _rotateX = 0;
      _rotateY = 0;
      _scale = 1.0;
    });
  }

  String _getShapeName(ThreeDShape shape) {
    switch (shape) {
      case ThreeDShape.cube:
        return '立方体';
      case ThreeDShape.sphere:
        return '球体';
      case ThreeDShape.cylinder:
        return '圆柱体';
      case ThreeDShape.cone:
        return '圆锥体';
      default:
        return '未知';
    }
  }

  String _getShapeDescription(ThreeDShape shape) {
    switch (shape) {
      case ThreeDShape.cube:
        return '立方体有6个面、12条棱、8个顶点。每个面都是正方形，相对的面互相平行。';
      case ThreeDShape.sphere:
        return '球体是一个完全对称的立体图形，表面每一点到球心的距离都相等。';
      case ThreeDShape.cylinder:
        return '圆柱体有两个平行的圆形底面和一个侧面，侧面展开是矩形。';
      case ThreeDShape.cone:
        return '圆锥体有一个圆形底面和一个顶点，侧面展开是扇形。';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3D形状 - ${_getShapeName(_currentShape)}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              onScaleUpdate: _onScaleUpdate,
              child: Transform.scale(
                scale: _scale,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationX(_rotateX)..rotateY(_rotateY),
                  child: Container(
                    color: Colors.black12,
                    child: ThreeDView(
                      shape: _currentShape,
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getShapeName(_currentShape),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _getShapeDescription(_currentShape),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _rotateX = 0;
                          _rotateY = 0;
                          _scale = 1.0;
                        });
                      },
                      child: const Text('重置视图'),
                    ),
                    ElevatedButton(
                      onPressed: _nextShape,
                      child: const Text('下一个形状'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('返回'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}