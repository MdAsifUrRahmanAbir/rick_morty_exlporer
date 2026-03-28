# 🌌 Rick & Morty Character Explorer

A premium, modern Flutter application for exploring the Rick and Morty multiverse, featuring real-time synchronization, advanced filtering, and a robust offline experience.

---

## 📺 Video Demo
Check out the full app walkthrough and feature demonstration on YouTube:
**[Watch the Demo Video](https://youtu.be/CF0OkhvU-uI)**

---

## 🚀 Getting Started

Follow these steps to set up and run the application on your local machine:

### **1. Prerequisites**
*   **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install) (version 3.x recommended).
*   **IDE**: [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio).
*   **Environment**: An Android emulator or a physical device with **USB Debugging** enabled.

### **2. Setup Instructions**
1.  **Clone the repository**:
    ```bash
    git clone https://github.com/MdAsifUrRahmanAbir/rick_morty_exlporer.git
    cd rick_morty_exlporer
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the application**:
    ```bash
    flutter run
    ```

---

## 🏗️ Architecture & Choices

### **State Management: Provider**
We chose **Provider** for its industry-standard reliability and lightweight footprint.
*   **Reasoning**: It provides a clean "source of truth" for character data across different screens (List, Details, Favorites), ensuring that local edits are reflected instantly without complex boilerplate.

### **Storage: SharedPreferences (JSON Cache)**
We use a wrapped **SharedPreferences** service for persistent data.
*   **Explanation**: Character data, favorites, and local overrides (edits) are serialized to JSON and stored locally. This approach ensures high-speed access and a seamless offline-first experience.

### **Loading Experience: Skeletonizer**
The app features a premium **Skeleton Loading** effect.
*   **Reasoning**: Instead of generic spinners, we use shimmer-based placeholders that match the UI layout, providing a smoother perceived performance during API fetches.

---

## ✨ Core Features
*   **Live Filtering**: Search by name or filter by status (Alive/Dead) and species (Human/Alien) with automatic API synchronization.
*   **Local Overrides**: Edit any character's details locally. Changes stay on your device even after app restarts.
*   **True Persistence**: Favorite characters are cached and remain accessible even when you're offline.
*   **Smart Navigation**: Optimized for a deep-linking feel, including automatic removal of intermediate routes when returning to the main list.

---

## ⚠️ Known Limitations
*   **Offline New Content**: Internet is required to fetch characters you haven't previously cached.
*   **Local Search Scope**: The search bar queries the characters currently loaded in the list to maintain zero-latency performance.
*   **Media Caching**: Character images rely on the `cached_network_image` library; images that haven't been viewed while online may not appear in offline mode.

---
*Built with love for the multiverse.*
