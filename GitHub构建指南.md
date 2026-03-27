# GitHub在线构建APK指南

无需安装任何开发环境，使用GitHub Actions在线构建你的立体几何应用APK。

## 准备工作

1. **GitHub账号**：如果没有，请访问 [GitHub官网](https://github.com) 注册
2. **Git软件**（可选）：用于上传代码，如果不想安装，可以使用GitHub网页上传

## 第一步：创建GitHub仓库

1. 登录GitHub
2. 点击右上角"+" → "New repository"
3. 填写仓库信息：
   - **Repository name**: Geometry3DApp（或其他名称）
   - **Description**: 高中立体几何学习应用
   - 选择 **Public**（公开，免费）
   - **不要**勾选"Initialize this repository with a README"
   - 点击"Create repository"

## 第二步：上传代码到GitHub

### 方法A：使用Git命令行（推荐）

如果你已经安装了Git：

```bash
# 1. 进入项目目录
cd "C:\Users\14359\Documents\Geometry3DApp"

# 2. 初始化Git仓库
git init

# 3. 添加所有文件
git add .

# 4. 提交更改
git commit -m "Initial commit: 立体几何学习应用"

# 5. 添加远程仓库（替换YOUR_USERNAME为你的GitHub用户名）
git remote add origin https://github.com/YOUR_USERNAME/Geometry3DApp.git

# 6. 推送代码
git branch -M main
git push -u origin main
```

### 方法B：使用GitHub网页上传

1. 在新建的仓库页面，点击"uploading an existing file"
2. 打开文件资源管理器，进入 `C:\Users\14359\Documents\Geometry3DApp`
3. 选择**所有文件和文件夹**（包括`.github`目录），拖拽到GitHub上传区域
4. 点击"Commit changes"

**重要**：确保上传以下文件和目录：
- `.github/workflows/build-apk.yml`
- `lib/`
- `android/`
- `assets/`
- `pubspec.yaml`
- `README.md`

## 第三步：触发构建

1. 进入你的仓库页面
2. 点击顶部"Actions"选项卡
3. 你会看到"Build Android APK"工作流
4. 点击"Run workflow" → "Run workflow"（手动触发）

或者，如果你已经推送了代码，GitHub Actions会自动开始构建。

## 第四步：下载APK文件

1. 在"Actions"页面，点击正在运行或已完成的工作流
2. 等待所有步骤完成（约5-10分钟）
3. 完成后，在"Artifacts"部分下载APK文件：
   - **app-debug-apk**：调试版APK（约30MB）
   - **app-release-apk**：发布版APK（约15MB）
   - **app-split-apks**：分割APK（针对不同CPU）

## 第五步：安装APK到手机

### 推荐下载：`app-release.apk` 或 `app-arm64-v8a-release.apk`

1. **下载APK**到电脑，然后发送到手机：
   - 微信/QQ文件传输
   - 数据线连接
   - 蓝牙传输

2. **在手机上安装**：
   - 使用"文件管理器"找到APK文件
   - 点击安装
   - 如提示"禁止安装未知来源应用"，需要开启：
     ```
     设置 → 安全 → 允许安装未知来源应用 → 开启
     ```

## 不同APK版本说明

| APK文件 | 大小 | 用途 | 推荐 |
|---------|------|------|------|
| `app-debug.apk` | ~30MB | 调试版本，可在任何设备安装 | 快速测试 |
| `app-release.apk` | ~15MB | 发布版本，体积小，性能好 | 正式分发 |
| `app-arm64-v8a-release.apk` | ~8MB | 仅64位ARM设备 | **最推荐** |
| `app-armeabi-v7a-release.apk` | ~7MB | 32位ARM设备 | 旧手机 |
| `app-x86_64-release.apk` | ~8MB | Intel/AMD设备 | 模拟器 |

## 常见问题解决

### 1. 构建失败
- **错误**: "flutter: command not found"
  - 解决方案：确保`.github/workflows/build-apk.yml`文件已上传
- **错误**: "Minimum supported Gradle version"
  - 解决方案：这通常会自动解决，等待构建完成

### 2. 找不到Artifacts
- 确保工作流**完全完成**（所有绿色对勾）
- 点击"Artifacts"旁边的刷新按钮
- 如果超过7天，Artifacts会被自动删除，需要重新构建

### 3. 上传代码失败
- 检查是否上传了所有必要文件
- 确保`.github`目录被上传（这是个隐藏目录）
- 可以尝试删除仓库重新创建

### 4. 手机安装失败
- **存储空间不足**：确保有至少100MB空间
- **安卓版本过低**：需要安卓4.4以上
- **签名冲突**：如已安装测试版，先卸载再安装新版

## 高级选项

### 自动构建（每次推送代码）
默认配置为每次推送到main分支时自动构建，你可以在`.github/workflows/build-apk.yml`中修改。

### 添加应用签名
如需生成签名的APK，需要配置签名密钥。联系我获取详细指南。

### 构建App Bundle
如需发布到Google Play，可以构建App Bundle：
```yaml
- name: Build App Bundle
  run: flutter build appbundle --release
```

## 快速验证

1. **检查文件结构**：确保项目包含`.github/workflows/build-apk.yml`
2. **推送到GitHub**：使用Git或网页上传
3. **等待5分钟**：GitHub Actions自动构建
4. **下载APK**：从Artifacts下载`app-arm64-v8a-release.apk`
5. **安装测试**：发送到手机安装

## 技术支持

如遇到问题：
1. 查看GitHub Actions的详细错误信息
2. 确保所有文件已正确上传
3. 检查`.github/workflows/build-apk.yml`语法是否正确
4. 可以尝试删除`.github`目录重新创建

**注意**：第一次构建可能需要较长时间（10-15分钟），因为GitHub需要下载Flutter和Android SDK。