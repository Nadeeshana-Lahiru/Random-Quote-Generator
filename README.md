# 🎯 Random Quote Generator

[![Flutter](https://img.shields.io/badge/Flutter-3.10.1+-blue?logo=flutter)]()
[![License](https://img.shields.io/badge/License-MIT-green)]()
[![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-brightgreen)]()

A beautifully crafted Flutter application that delivers inspiring random quotes with stunning visual effects, ambient sounds, and comprehensive customization options. Perfect for daily motivation and inspiration!

## 📸 App Screenshots

| Splash Screen | Splash Screen | Splash Screen |
|---------------|------------|-------------|
| <img width="353" height="792" alt="image" src="https://github.com/user-attachments/assets/d5f9de0d-8fac-40de-a660-230c9de2563c" /> | <img width="353" height="787" alt="image" src="https://github.com/user-attachments/assets/27f60303-4447-4854-9129-d1b7ea42ce20" /> | <img width="357" height="791" alt="image" src="https://github.com/user-attachments/assets/86f40cb6-9a68-47e3-b33b-425c98ad842f" /> |

| Home Screen | Quote of the Day | Favourites |
|----------|------------|---------|
| <img width="356" height="786" alt="image" src="https://github.com/user-attachments/assets/4b91453c-3b79-4bbb-bad2-921eb20e581f" /> | <img width="353" height="787" alt="image" src="https://github.com/user-attachments/assets/0f0dda82-1760-47a3-ab20-7a3036139a8d" /> | <img width="359" height="793" alt="image" src="https://github.com/user-attachments/assets/bccc36d4-8a65-43b6-88fb-aae3e5961a11" /> |

| History | Settings | Light Theme |
|-----------------|--------------|-------------|
| <img width="354" height="786" alt="image" src="https://github.com/user-attachments/assets/c1bef1d9-419f-4c2e-bbed-a20b1098369a" /> | <img width="356" height="790" alt="image" src="https://github.com/user-attachments/assets/a35e3d87-3c47-40c2-b628-959d345ecb86" /> | <img width="354" height="789" alt="image" src="https://github.com/user-attachments/assets/50ca72d4-f28f-440a-827d-59ad2036c6b9" /> |

---

## ✨ Features

### 🎨 **Visual Excellence**
- **Dynamic Animated Backgrounds** - Smooth gradient animations create an immersive atmosphere
- **Dark/Light Theme Support** - System-aware theme switching with customizable modes
- **Skeleton Loading Animation** - Smooth shimmer effects while fetching quotes
- **Material Design 3** - Latest Flutter design patterns with rounded corners and modern aesthetics

### 💬 **Quote Management**
- **Random Quote Generation** - Get inspired with quotes fetched from an offline database
- **Quote of the Day** - Daily special quote with visual distinction
- **Global Quote Library** - Browse through hundreds of curated quotes
- **Advanced Search** - Search by keywords in quote text and author names
- **Favorites System** - Save and manage your favorite quotes for quick access
- **Offline Support** - All quotes available without internet connection

### 🎤 **Audio Features**
- **Text-to-Speech (TTS)** - Hear quotes read aloud with natural voice synthesis
- **Adjustable Voice Gender** - Choose between male and female voice profiles
- **Customizable Speech Rate** - Control narration speed (0.5x normal)
- **Ambient Sounds** - Relaxing rain loop background to set the mood
- **Toggle Ambience** - Switch between full silence or ambient rain environments

### 🎛️ **Customization & Settings**
- **Auto-Refresh Toggle** - Automatic quote updates every 30 seconds
- **Font Family Selection** - Choose from Google Fonts collection
- **Adjustable Font Size** - Perfect readability for different preferences
- **Language Support** - Multi-language quote content
- **User Personalization** - Customize your username for personalized greetings

### 📤 **Sharing & Export**
- **Share Quotes** - One-tap sharing via all available platforms
- **Image Export** - Convert quotes into beautifully styled images
- **Export Studio** - Advanced quote image editor with customization options
- **Social Media Integration** - Direct sharing to WhatsApp, Twitter, Instagram, and more

### 🔔 **User Experience**
- **Interactive Onboarding** - Welcome carousel for first-time users
- **Gesture Controls** - Swipe gestures for intuitive navigation
- **Real-time Search** - Instant filtering as you type
- **Responsive Layout** - Optimized for all screen sizes and orientations

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: Version 3.10.1 or higher
- **Dart SDK**: Included with Flutter
- **Android Studio** or **Xcode** (for testing on devices)
- **Git**: For version control

### Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/random_quote_generator.git
   cd random_quote_generator
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the Application**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

---

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | 6.1.5+ | State Management |
| `shared_preferences` | 2.5.5 | Local Data Persistence |
| `google_fonts` | 8.0.2 | Custom Typography |
| `share_plus` | 13.1.0 | Social Media Sharing |
| `http` | 1.6.0 | API Calls & Data Fetching |
| `flutter_tts` | 4.2.5 | Text-to-Speech Engine |
| `audioplayers` | 6.6.0 | Audio Playback (Ambient Sounds) |
| `shimmer` | 3.0.0 | Loading Animation Effects |
| `package_info_plus` | 10.1.0 | App Version Information |
| `home_widget` | 0.9.1 | Widget Support |
| `cupertino_icons` | 1.0.8 | iOS Design Icons |

---

## 🏗️ Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   └── quote.dart                     # Quote data model
├── providers/                         # State management
│   ├── theme_provider.dart           # Theme & settings
│   ├── quotes_provider.dart          # Quote management & search
│   └── audio_provider.dart           # Audio playback control
├── screens/                           # App pages
│   ├── home_page.dart                # Main quote display
│   ├── onboarding_page.dart          # Welcome carousel
│   ├── favorites_page.dart           # Saved quotes
│   ├── library_page.dart             # Quote search
│   ├── export_studio_page.dart       # Image generation
│   └── settings_page.dart            # User preferences
├── widgets/                           # Reusable components
│   └── quote_skeleton.dart           # Loading skeleton
├── services/
│   └── api_service.dart              # API integration
└── data/
    └── quotes_data.dart              # Quote database
```

---

## 🎯 Usage Guide

### Getting Started with Quotes
1. **Launch the App** - Complete the onboarding carousel on first run
2. **View Quotes** - Swipe or tap buttons to generate random quotes
3. **Hear Quotes** - Click the speaker icon to have quotes read aloud
4. **Save Favorites** - Tap the heart icon to save memorable quotes

### Customizing Your Experience
1. **Open Settings** - Tap the gear icon in the top right
2. **Choose Theme** - Select Light, Dark, or System Default mode
3. **Set Font** - Pick your favorite font family from Google Fonts
4. **Adjust Size** - Increase or decrease text size for comfort
5. **Audio Settings** - Toggle ambient sounds and TTS voice preferences

### Sharing & Exporting
1. **Quick Share** - Use the share button for instant social media posting
2. **Custom Images** - Go to Export Studio for advanced image customization
3. **Save Locally** - Export quotes as images to your device gallery

### Advanced Features
- **Search Library** - Use the search icon to find quotes by keyword or author
- **Quote of the Day** - Check the daily featured quote in the home page banner
- **Auto-Refresh** - Enable auto-refresh in settings for continuous motivation
- **Background Ambience** - Toggle rain sounds for a relaxing atmosphere

---

## 🎨 Theming

The app supports full Material Design 3 theming with:
- **Light Theme** - Bright, energetic color scheme
- **Dark Theme** - Eye-friendly dark backgrounds
- **System Theme** - Automatic adaptation to device settings
- **Custom Fonts** - 900+ Google Fonts to choose from

### Customize Colors
Edit the primary color seed in `main.dart`:
```dart
ColorScheme.fromSeed(
  seedColor: const Color(0xFF2C3E50), // Change this value
  brightness: Brightness.light,
),
```

---

## 🔧 Configuration

### App Version
Update in `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

### Change App Name
**Android**: Edit `android/app/build.gradle`
**iOS**: Edit `ios/Runner/Info.plist`

### Add More Quotes
Edit `lib/data/quotes_data.dart` and add to the quotes list:
```dart
Quote(
  text: 'Your quote text',
  author: 'Author name',
  category: 'inspirational',
),
```

---

## 📱 Supported Platforms

- ✅ **Android** 5.0+
- ✅ **iOS** 12.0+
- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **Windows** 10+
- ✅ **macOS** 10.15+

---

## 💡 Performance Optimizations

- **Lazy Loading** - Quotes load only when needed
- **Efficient State Management** - Provider pattern for optimal rebuilds
- **Cached Data** - Local storage reduces repeated fetches
- **Optimized Animations** - Smooth, performance-conscious transitions

---

## 🐛 Known Issues & Limitations

- TTS availability depends on device language packs
- Ambient sounds require sufficient device storage
- Some fonts may not display correctly on older Android versions

---

## 🤝 Contributing

Contributions are welcome! Here's how to get started:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### Contribution Guidelines
- Follow Flutter best practices and style guide
- Write clean, documented code
- Test on multiple devices/platforms
- Update README for new features

---

## 📄 License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

---

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing cross-platform framework
- **Quote Contributors** - For inspiring quotes from around the world
- **Google Fonts** - For beautiful typography options
- **Community** - For feedback and feature suggestions

---

## 📞 Support & Contact

For issues, feature requests, or questions:

- **Open an Issue** - [GitHub Issues](https://github.com/Nadeeshana-Lahiru/random_quote_generator/issues)
- **Email** - nadeeshana1998@gmail.com

---

## 🌟 Changelog

### Version 1.0.0 - Latest Release
- ✨ Dynamic visual backgrounds with animated gradients
- 🎡 Onboarding carousel for new users
- 🎵 Ambient sounds feature (relaxing rain loops)
- 🎤 Text-to-speech with gender selection
- ⚡ Auto-refresh quotes every 30 seconds
- 📸 Share quotes with custom edited images
- 📚 Full quote library with advanced search
- ⏰ Quote of the Day feature
- 🎨 Multiple theme and font options
- 🔄 Swipe gestures for intuitive navigation

---
