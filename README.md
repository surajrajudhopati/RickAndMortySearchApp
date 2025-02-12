# RickAndMortySearchApp

## 📱 About the App
RickAndMortySearchApp is an iOS app that allows users to browse characters from the **Rick and Morty** universe. The app is built using **SwiftUI** and **Swift Concurrency (async/await)** and supports features such as filtering, searching, and smooth UI animations.

## 🎯 Features

✅ **Character List View**
- Displays a list of characters with names and species.
- Supports **Grid View and List View toggling**.

✅ **Character Search & Filters**
- Search by **Name, Status, Species, and Type**.
- Instant results update as the user types.

✅ **Detailed Character View**
- Shows character details like **status, species, origin, and creation date**.
- **Async image loading** with placeholder handling.

✅ **Smooth Navigation & Animations**
- Uses **NavigationStack** for a seamless experience.
- Includes **matchedGeometryEffect** for smooth transitions.

✅ **Favorites & State Management**
- Uses **@StateObject and @ObservedObject** for proper SwiftUI state management.

✅ **API Integration**
- Fetches data from the [Rick and Morty API](https://rickandmortyapi.com/).
- Uses **async/await** for efficient network calls.

✅ **Optimized for Performance**
- Uses **LazyVStack & LazyVGrid** for efficient scrolling.
- Implements **pagination** to load data dynamically.

✅ **Accessibility Features**
- Includes **VoiceOver** labels for better UX.
- Uses **Dynamic Type** for adjustable text sizes.

✅ **Dark Mode Support**
- Fully supports iOS **Dark Mode**.

## 🛠 Tech Stack
- **Language:** Swift
- **Frameworks:** SwiftUI
- **Networking:** URLSession (async/await)
- **Architecture:** MVVM (Model-View-ViewModel)
- **Version Control:** Git & GitHub

## 🚀 How to Run the App
1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/RickAndMortySearchApp.git
   ```
2. Open `RickAndMortySearchApp.xcodeproj` in Xcode.
3. Run the app on the **iOS Simulator** or a real device.

## 📸 Screenshots
(Attach screenshots here)

## 🤝 Contributing
Pull requests are welcome. For major changes, please open an issue first.

## 📜 License
This project is **open-source** and available under the MIT License.


