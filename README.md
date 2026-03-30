# 立体几何学习App (Flutter)

这是一个用于高中立体几何教学的交互式Android应用程序，包含3D图形、动画和知识点讲解。

## 功能特点

- 3D图形展示（立方体、球体等）
- 手势交互（旋转、缩放）
- 空间几何关系动画（线面角、二面角）
- 立体几何定理演示（三垂线定理等）
- 知识点讲解界面

## 开发环境搭建

### 1. 安装Flutter SDK

1. 访问 [Flutter官网](https://flutter.dev/docs/get-started/install/windows) 下载Flutter SDK
2. 解压到任意目录（例如 `C:\flutter`）
3. 添加Flutter到系统环境变量PATH：
   - 右键点击"此电脑" -> 属性 -> 高级系统设置 -> 环境变量
   - 在"用户变量"或"系统变量"中找到Path，点击编辑
   - 添加Flutter的bin目录路径（例如 `C:\flutter\bin`）
4. 打开命令提示符，运行 `flutter --version` 验证安装

### 2. 安装Android Studio

1. 下载并安装 [Android Studio](https://developer.android.com/studio)
2. 启动Android Studio，完成初始设置
3. 安装Android SDK：
   - 打开SDK Manager（Tools -> SDK Manager）
   - 确保已安装Android SDK Platform（API 33或更高）
   - 安装Android SDK Build-Tools
4. 设置Android模拟器：
   - 打开AVD Manager（Tools -> AVD Manager）
   - 创建虚拟设备（建议Pixel 5，API 33）

### 3. 配置Flutter

1. 运行 `flutter doctor` 检查环境
2. 根据提示安装缺少的组件
3. 确保Android许可证已接受：`flutter doctor --android-licenses`

## 快速开始（无需安装开发环境）

### 使用GitHub Actions在线构建APK

本仓库已配置GitHub Actions，可自动构建APK文件：

1. **访问仓库Actions页面**: https://github.com/luoyabo/Geometry3DApp/actions
2. **触发构建**: 点击"Build Android APK" → "Run workflow"
3. **等待构建完成**: 约5-10分钟
4. **下载APK**: 在"Artifacts"区域下载生成的APK文件
5. **安装到手机**: 发送APK到安卓手机，开启"允许安装未知来源应用"后安装

### 在Windows上通过Android模拟器运行

如需在Windows电脑上测试，请参考 [Windows试运行指南.md](Windows试运行指南.md)：
1. 安装Android Studio
2. 创建Android虚拟设备（模拟器）
3. 将APK拖拽到模拟器窗口安装
4. 运行应用

## 项目运行

1. 打开Android Studio
2. 选择"Open an existing project"
3. 导航到本项目的 `Geometry3DApp` 目录
4. 等待依赖下载完成（可能需要VPN）
5. 连接Android设备或启动模拟器
6. 点击运行按钮（或运行 `flutter run`）

## 项目结构

```
Geometry3DApp/
├── assets/              # 3D模型文件
├── lib/
│   ├── main.dart       # 主入口文件
│   ├── models/         # 数据模型
│   ├── widgets/        # 自定义组件
│   └── utils/          # 工具类
├── android/            # Android平台代码
├── ios/                # iOS平台代码
└── pubspec.yaml        # 依赖配置
```

## 依赖包

- `flutter_3d_view`: 3D模型渲染（立方体、球体、圆柱体、圆锥体）
- `vector_math`: 数学计算
- `provider`: 状态管理
- `flutter_animate`: 动画效果

## 下一步开发

1. 添加更多3D形状（球体、圆柱体、圆锥体）✓ 已实现
2. 实现几何关系可视化（角度标注、距离测量）✓ 线面角已实现
3. 添加定理动画演示 ✓ 三垂线定理已实现
4. 完善知识点讲解内容 ✓ 已实现
5. 优化用户界面和交互体验 ✓ 已实现

## 相关文档

- [APK打包指南.md](APK打包指南.md) - 详细APK构建和分发指南
- [GitHub构建指南.md](GitHub构建指南.md) - 使用GitHub Actions在线构建
- [Windows试运行指南.md](Windows试运行指南.md) - 在Windows模拟器中运行应用

## 注意事项

- 确保Flutter版本 >= 3.0.0
- 运行前执行 `flutter pub get` 获取依赖
- 首次构建可能需要较长时间