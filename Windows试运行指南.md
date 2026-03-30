# Windows试运行指南 - Android模拟器方案

本指南将帮助你在Windows电脑上通过Android模拟器运行立体几何学习应用，无需真实手机。

## 整体流程
1. ✅ **已拥有**：GitHub仓库中的Flutter代码
2. ⚡ **快速完成**：触发GitHub Actions构建APK（5-10分钟）
3. 📥 **下载**：获取生成的APK文件
4. 🖥️ **安装**：安装Android Studio和设置模拟器（30分钟）
5. ▶️ **运行**：在模拟器中安装并运行应用

## 第一步：触发GitHub构建APK（如未完成）

### 检查构建状态
1. 访问你的仓库Actions页面：https://github.com/luoyabo/Geometry3DApp/actions
2. 查看是否有"Build Android APK"工作流
3. 检查最新运行状态：
   - ✅ 绿色对勾：构建成功，跳到第二步
   - 🟡 黄色圆圈：正在构建，等待完成
   - ❌ 红色叉叉：构建失败，查看错误

### 手动触发构建（如无成功构建）
1. 在Actions页面，点击"Build Android APK"
2. 点击"Run workflow" → "Run workflow"
3. 等待5-10分钟构建完成

## 第二步：下载APK文件

构建成功后：
1. 点击完成的工作流运行
2. 滚动到"Artifacts"部分
3. 下载以下文件之一：
   - **app-release-apk**（推荐：`app-release.apk`，约15MB）
   - **app-debug-apk**（`app-debug.apk`，约30MB）
   - **app-split-apks**（`app-arm64-v8a-release.apk`，约8MB，最推荐）

**保存APK文件**到容易找到的位置，如桌面或下载文件夹。

## 第三步：安装Android Studio（如未安装）

### 下载Android Studio
1. 访问：https://developer.android.com/studio
2. 点击"Download Android Studio"
3. 下载Windows版本（约1GB）

### 安装步骤
1. 运行安装程序，点击"Next"
2. 选择安装位置（默认即可）
3. 确保勾选：
   - Android Virtual Device（必须）
   - Android SDK Platform（必须）
   - Performance（Intel® HAXM，推荐）
4. 点击"Next"直到安装完成
5. 启动Android Studio

### 首次运行配置
1. 选择"Don't import settings"
2. 点击"Next"完成初始向导
3. 选择"Standard"安装类型
4. 选择主题（Light或Dark）
5. 点击"Finish"，等待组件下载（可能需要VPN）

## 第四步：创建Android模拟器

### 打开AVD Manager
1. 在Android Studio中：Tools → AVD Manager
2. 或点击工具栏的手机图标

### 创建虚拟设备
1. 点击"Create Virtual Device"
2. **选择设备**：
   - 推荐：Pixel 5（性能适中）
   - 或：Pixel 6、Samsung Galaxy S21
3. **选择系统镜像**：
   - 推荐：R（API 30，Android 11.0)
   - 或：最新稳定版本
   - 点击"Download"下载系统镜像（约1-2GB）
4. **验证配置**：
   - 名称：Pixel_5_API_30
   - 确保"Enable Device Frame"已勾选
5. 点击"Finish"

### 启动模拟器
1. 在AVD Manager中，点击创建的设备旁边的"三角播放按钮"
2. 等待模拟器启动（首次较慢，约2-3分钟）
3. 模拟器启动后，你会看到Android主屏幕

## 第五步：安装APK到模拟器

### 方法A：拖拽安装（最简单）
1. 将下载的APK文件（如`app-release.apk`）拖拽到运行的模拟器窗口
2. 模拟器会自动开始安装
3. 安装完成后，点击"Open"或"Done"

### 方法B：使用ADB命令
1. 打开命令提示符或PowerShell
2. 导航到APK文件所在目录：
   ```cmd
   cd C:\Users\你的用户名\Downloads
   ```
3. 运行安装命令：
   ```cmd
   adb install app-release.apk
   ```
4. 看到"Success"表示安装成功

### 方法C：使用Android Studio
1. 在Android Studio中：Run → Edit Configurations
2. 点击"+" → "Android App"
3. 在"General"选项卡，点击"..."选择APK文件
4. 点击"OK"，然后点击运行按钮

## 第六步：运行应用

### 在模拟器中打开应用
1. 在模拟器主屏幕，点击"App Drawer"（所有应用）
2. 找到"立体几何学习"应用图标
3. 点击图标启动应用

### 应用功能测试
测试以下功能是否正常：
1. **主菜单**：点击各个功能卡片
2. **3D形状**：旋转、缩放立方体
3. **线面角**：拖动滑块，观察角度变化
4. **三垂线定理**：查看定理图解
5. **知识点**：滚动查看内容

## 常见问题解决

### 1. 模拟器启动失败
- **错误**: "HAXM not installed"
  - 解决方案：安装Intel HAXM
    1. 打开SDK Manager：Tools → SDK Manager
    2. 点击"SDK Tools"选项卡
    3. 勾选"Intel x86 Emulator Accelerator (HAXM installer)"
    4. 点击"Apply"安装

- **错误**: "VT-x is disabled"
  - 解决方案：启用CPU虚拟化
    1. 重启电脑，进入BIOS（通常按F2、F10、Del键）
    2. 找到Virtualization Technology（VT-x/AMD-V）
    3. 设置为Enabled
    4. 保存并重启

### 2. APK安装失败
- **错误**: "INSTALL_FAILED_INSUFFICIENT_STORAGE"
  - 解决方案：增加模拟器存储
    1. 在AVD Manager中，点击设备旁边的"铅笔图标"
    2. 点击"Show Advanced Settings"
    3. 增加"Internal Storage"到4096MB

- **错误**: "INSTALL_FAILED_UPDATE_INCOMPATIBLE"
  - 解决方案：卸载旧版本
    ```cmd
    adb uninstall com.example.geometry_3d_app
    ```

### 3. 应用运行问题
- **3D图形不显示**：确保模拟器使用硬件加速
- **动画卡顿**：尝试使用性能更好的模拟器配置
- **触摸不灵敏**：在模拟器设置中启用"Use mouse as touchpad"

## 优化建议

### 提高模拟器性能
1. **分配更多内存**：
   - 编辑虚拟设备 → "Show Advanced Settings"
   - RAM: 至少2048MB（推荐4096MB）

2. **使用硬件加速**：
   - 在AVD创建时选择"x86_64"系统镜像
   - 确保HAXM已安装

3. **关闭不必要的功能**：
   - 关闭"Device Frame"（边框）
   - 降低屏幕分辨率

### 快速测试技巧
1. **保存快照**：启动模拟器后，点击"相机图标"保存状态，下次秒启动
2. **多设备测试**：创建不同尺寸和安卓版本的模拟器
3. **截图功能**：点击模拟器工具栏的"相机图标"截图

## 备选方案

### 1. 使用第三方模拟器（更简单）
- **BlueStacks**（游戏玩家常用）：
  1. 下载：https://www.bluestacks.com
  2. 安装并启动
  3. 直接将APK拖拽到窗口安装
  4. 运行应用

- **NoxPlayer**（性能优秀）：
  1. 下载：https://www.bignox.com
  2. 类似步骤安装运行

### 2. Web版本运行（无需模拟器）
如需在浏览器中直接运行，我可以帮你配置Flutter Web支持。

### 3. 真实手机测试
将APK发送到真实安卓手机安装，步骤类似。

## 下一步操作

### 立即开始：
1. **检查GitHub构建**：https://github.com/luoyabo/Geometry3DApp/actions
2. **下载APK**：选择`app-arm64-v8a-release.apk`
3. **安装Android Studio**（如未安装）
4. **创建Pixel 5模拟器**（API 30）

### 预计时间：
- 第一次：60-90分钟（安装和配置）
- 后续：2-3分钟（启动模拟器运行）

## 技术支持

**如遇到问题**：
1. 截图错误信息
2. 查看Android Studio的"Logcat"输出
3. 检查模拟器设置

**重要提示**：第一次设置可能需要较长时间，但一旦配置完成，后续测试会非常快速。