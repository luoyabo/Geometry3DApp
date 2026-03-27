# APK打包与分发指南

本指南将帮助你将Flutter立体几何应用打包成APK文件，并分发给其他人的安卓手机安装。

## 准备工作

### 1. 确保Flutter环境已搭建
按照 `README.md` 中的步骤完成：
- Flutter SDK安装
- Android Studio安装
- Android模拟器/真机连接配置
- 运行 `flutter doctor` 检查环境

### 2. 添加应用图标（可选但推荐）
在 `android/app/src/main/res/` 目录下创建不同分辨率的图标：
```
mipmap-hdpi/ic_launcher.png      (72x72)
mipmap-mdpi/ic_launcher.png      (48x48)
mipmap-xhdpi/ic_launcher.png     (96x96)
mipmap-xxhdpi/ic_launcher.png    (144x144)
mipmap-xxxhdpi/ic_launcher.png   (192x192)
```

## APK打包步骤

### 方案一：生成调试版APK（最简单，适合测试）

调试版APK可以在任何设备上安装，但需要开启"USB调试"或"开发者选项"。

1. **打开命令行**，进入项目目录：
   ```bash
   cd "C:\Users\14359\Documents\Geometry3DApp"
   ```

2. **安装依赖**（如果还没安装）：
   ```bash
   flutter pub get
   ```

3. **生成调试版APK**：
   ```bash
   flutter build apk --debug
   ```

4. **找到生成的APK文件**：
   ```
   build/app/outputs/flutter-apk/app-debug.apk
   ```

5. **文件大小**：约30-50MB

### 方案二：生成发布版APK（推荐用于分发）

发布版APK更小、更快，需要应用签名。

#### 步骤1：创建签名密钥（仅第一次需要）

1. **打开命令行**，运行：
   ```bash
   keytool -genkey -v -keystore geometry_key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias geometry
   ```

   按提示输入：
   - 密钥库密码：设置一个安全的密码
   - 姓名：你的姓名
   - 组织单位：可留空
   - 组织名称：可留空
   - 城市：你的城市
   - 省份：你的省份
   - 国家代码：CN（中国）

2. **将生成的密钥文件** `geometry_key.jks` 移动到 `android/app/` 目录下

#### 步骤2：配置签名信息

1. **编辑** `android/key.properties`（如不存在则创建）：
   ```properties
   storePassword=你设置的密码
   keyPassword=你设置的密码
   keyAlias=geometry
   storeFile=geometry_key.jks
   ```

2. **修改** `android/app/build.gradle`，在 `android {` 部分之前添加：
   ```gradle
   def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }

   android {
   ```

3. **修改** `android/app/build.gradle` 中的 `buildTypes` 部分，替换为：
   ```gradle
   signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
           storePassword keystoreProperties['storePassword']
       }
   }
   buildTypes {
       release {
           signingConfig signingConfigs.release
       }
   }
   ```

#### 步骤3：生成发布版APK

1. **运行打包命令**：
   ```bash
   flutter build apk --release
   ```

2. **找到生成的APK文件**：
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

3. **文件大小**：约10-20MB（比调试版小很多）

#### 步骤4：生成分割APK（针对不同CPU架构，可选）

为了进一步减小APK体积，可以生成特定CPU架构的APK：
```bash
flutter build apk --release --split-per-abi
```

这会生成三个APK：
```
build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
build/app/outputs/flutter-apk/app-x86_64-release.apk
```

**推荐**：分发 `app-arm64-v8a-release.apk`，兼容大多数现代安卓手机。

## APK分发与安装

### 方法一：直接文件传输（最简单）

1. 将生成的APK文件通过以下方式发送到目标手机：
   - 微信/QQ文件传输
   - 数据线连接电脑复制
   - 蓝牙传输
   - 上传到网盘（百度云等）

2. 在目标手机上安装：
   - 使用"文件管理器"找到APK文件
   - 点击安装
   - 如提示"禁止安装未知来源应用"，需要开启设置：
     ```
     设置 → 安全 → 允许安装未知来源应用 → 开启
     ```

### 方法二：生成可安装的链接（通过二维码）

1. 将APK上传到文件分享服务，如：
   - 腾讯微云
   - 百度网盘
   - Google Drive（需要VPN）

2. 生成下载链接，然后用二维码生成器生成二维码

3. 对方用手机扫描二维码即可下载安装

### 方法三：发布到应用商店（最正规）

1. **准备材料**：
   - 应用图标（1024×1024 PNG）
   - 应用截图（至少3张，1280×720以上）
   - 应用描述
   - 隐私政策链接（如需）

2. **发布平台**：
   - 华为应用市场
   - 小米应用商店
   - 腾讯应用宝
   - Google Play（需要VPN）

## 安装注意事项

### 1. 安卓版本兼容性
- 项目已配置 `minSdkVersion: flutter.minSdkVersion`（通常为API 19，安卓4.4+）
- 支持大多数安卓手机（2014年后的设备）

### 2. 权限说明
应用仅需要网络权限（用于加载依赖），不需要其他敏感权限。

### 3. 安装失败常见原因
- **存储空间不足**：确保手机有至少100MB可用空间
- **安卓版本过低**：需要安卓4.4以上
- **签名冲突**：如已安装测试版，需先卸载再安装正式版
- **未知来源应用未开启**：需在设置中开启

## 优化建议

### 1. 减小APK体积
- 使用 `flutter build apk --release --split-per-abi`
- 移除未使用的资源文件
- 启用代码混淆（已配置 `android.enableR8=true`）

### 2. 添加应用信息
在 `android/app/src/main/AndroidManifest.xml` 中添加：
```xml
<application
    android:label="立体几何学习"
    android:icon="@mipmap/ic_launcher"
    android:allowBackup="true"
    android:theme="@style/LaunchTheme">
    <meta-data
        android:name="com.google.android.gms.version"
        android:value="@integer/google_play_services_version" />
</application>
```

### 3. 测试安装
建议在不同型号手机上测试安装：
- 华为/荣耀
- 小米/红米
- OPPO/vivo
- 三星

## 快速开始（推荐）

如果你只想快速生成一个可用的APK：

1. **安装Flutter环境**（参考README.md）
2. **生成调试版APK**：
   ```bash
   cd "C:\Users\14359\Documents\Geometry3DApp"
   flutter pub get
   flutter build apk --debug
   ```
3. **发送APK文件**：将 `build/app/outputs/flutter-apk/app-debug.apk` 发送给别人
4. **指导安装**：让对方开启"允许安装未知来源应用"

## 技术支持

如遇到问题：
1. 检查 `flutter doctor` 输出
2. 查看 `flutter build apk` 的错误信息
3. 确保项目路径没有中文或特殊字符
4. 确认Android SDK已正确安装

**注意**：第一次打包可能需要较长时间（10-30分钟），因为需要下载Gradle依赖和编译原生代码。