# 🌌 Rick & Morty Character Explorer

Welcome to the ultimate guide for exploring the characters of the Rick and Morty multiverse! This app is designed to be fast, beautiful, and easy to use.

---

## 🚀 How to Start the App

### **1. Get the Code**
Download or clone this folder to your computer.

### **2. Prepare Your Tools**
*   **For VS Code:** Install the **Flutter** and **Dart** extensions from the Extensions marketplace.
*   **For Android Studio:** Go to `Plugins`, search for **Flutter**, and click install. This will also install Dart.
*   **For Your Phone (Physical Device):**
    *   Go to `Settings` -> `About Phone`.
    *   Tap `Build Number` **7 times** until you see "You are now a developer."
    *   Go to `Developer Options` and enable **USB Debugging**.

### **3. Install the App Dependencies**
Open your terminal (in VS Code or Android Studio) and type:
```bash
flutter pub get
```

### **4. Launch the Multiverse**
Plug in your phone or start an emulator and type:
```bash
flutter run
```
*Tip: If the app gets stuck on the loading screen, just **Stop** it and **Start** it again.*

---

## 🧠 Why We Built It This Way

### **State Management: The Smart Brain (Provider)**
We chose **Provider** to manage the app’s "brain." 
*   **Reasoning:** It is reliable, fast, and ensures that when you edit a character, the whole app updates instantly without any glitches. It keeps the code clean and easy to follow.

### **Storage: The Digital Notebook (GetStorage)**
We use **GetStorage** to save your changes and favorites.
*   **Explanation:** Think of it as a super-fast digital notebook. Every time you change a character's name or heart them, the app writes it down instantly. Even if you turn off your phone, your multiverse remains exactly how you left it.

### **Network: Zero-Latency Search**
Traditional apps make you wait while searching. We designed our search to be **Local-First**. We search through characters you've already seen on your device, which means zero waiting and no "Rate Limit" errors from the server while you explore.

---

## ✨ Main Features
*   **Favorites:** Tap the heart icon to save characters you love.
*   **Edit Characters:** Change names, status, or species locally.
*   **The Safety Net:** Tap the **Restore Icon $(\circlearrowleft)$** on any edited card to bring back the original data.
*   **Offline Mode:** Browse the characters you've already found even without internet.

---

## ⚠️ Known Limitations
*   **New Discoveries:** You still need internet to find new characters you haven't seen before.
*   **Search Scope:** Currently, the search only looks through characters that have already been loaded into your list.
*   **Images:** Photos of characters might not appear offline if they were never loaded while you had internet.

---
*Built with love for the multiverse.*
