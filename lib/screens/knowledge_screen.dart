import 'package:flutter/material.dart';

class KnowledgeScreen extends StatelessWidget {
  const KnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('立体几何知识点'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          KnowledgeItem(
            title: '基本几何体',
            content: '立方体、长方体、球体、圆柱体、圆锥体、棱柱、棱锥等。',
          ),
          KnowledgeItem(
            title: '空间几何关系',
            content: '点、线、面的位置关系：点在线上、点在面内、线线平行、线面平行、面面平行、线线垂直、线面垂直、面面垂直。',
          ),
          KnowledgeItem(
            title: '线面角',
            content: '一条直线与它在平面内的射影所成的锐角，称为这条直线与这个平面所成的角。范围：0°～90°。',
          ),
          KnowledgeItem(
            title: '二面角',
            content: '从一条直线出发的两个半平面所组成的图形叫做二面角。二面角的平面角：在二面角的棱上任取一点，在两个面内分别作垂直于棱的射线，这两条射线所成的角。',
          ),
          KnowledgeItem(
            title: '三垂线定理',
            content: '在平面内的一条直线，如果和这个平面的一条斜线的射影垂直，那么它也和这条斜线垂直。',
          ),
          KnowledgeItem(
            title: '空间向量',
            content: '用有向线段表示空间向量，可以进行加减、数乘、点积、叉积运算，用于解决空间几何问题。',
          ),
          KnowledgeItem(
            title: '空间直角坐标系',
            content: '在空间中选定一点O和三个两两垂直的单位向量i、j、k，就建立了空间直角坐标系O-xyz。',
          ),
          KnowledgeItem(
            title: '立体几何公式',
            content: '体积公式：\n'
                '• 柱体体积 V = Sh\n'
                '• 锥体体积 V = 1/3 Sh\n'
                '• 球体体积 V = 4/3 πr³\n'
                '表面积公式：\n'
                '• 柱体侧面积 S侧 = 2πrh\n'
                '• 锥体侧面积 S侧 = πrl\n'
                '• 球体表面积 S = 4πr²',
          ),
        ],
      ),
    );
  }
}

class KnowledgeItem extends StatelessWidget {
  final String title;
  final String content;

  const KnowledgeItem({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}