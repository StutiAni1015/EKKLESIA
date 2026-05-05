# Ekklesia

A cross-platform church community app built with Flutter and Node.js, designed to help congregations connect, grow spiritually, and manage church life digitally.

## Features

- **Spiritual Growth** — Daily Bible reading plans, verse of the day, devotional content
- **Bible Reader** — Full Bible access (WEB, KJV, BBE, OEB, Darby) with highlights and bookmarks
- **Ezer AI** — AI-powered spiritual companion for Bible Q&A, counselling, quizzing, and journaling
- **Prayer Community** — Submit, browse, and pray for community prayer requests with a global prayer map
- **Church Management** — Pastors can create and manage churches, approve members, moderate content, and broadcast announcements
- **Church Events** — Browse and add events to your calendar
- **Giving & Treasury** — Track personal giving; pastor/committee access to church treasury
- **Spiritual Journal** — Private journaling with favourites and shared entries
- **Kids Mode** — Safe, age-appropriate content for younger members
- **Verification** — Face scan + OTP-based identity verification
- **Notifications** — Real-time push notifications via WebSockets
- **Dark Mode** — Full dark/light theme support across all screens

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter (Dart) |
| Backend | Node.js + Express |
| Database | MongoDB (Mongoose) |
| Auth | JWT + bcrypt |
| Real-time | Socket.IO |
| Bible API | bible-api.com |
| AI | Claude API (Anthropic) |

## Project Structure

```
ekklesia/
├── lib/
│   ├── core/           # App colours, localisation, session state
│   ├── screens/        # ~68 screens (auth, dashboard, Bible, church, etc.)
│   ├── service/        # ApiService, SocketService
│   └── widgets/        # Shared widgets (AppBottomBar, TapScale, etc.)
├── backend/
│   ├── models/         # Mongoose schemas (User, Church, Prayer, etc.)
│   ├── routes/         # Express route handlers
│   └── middleware/     # JWT auth middleware
└── test/
    └── widget_test.dart
```

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.x
- Node.js ≥ 18
- MongoDB (local or Atlas)

### Run the backend

```bash
cd backend
npm install
node server.js
```

The backend runs on port **4000** by default. Update `ApiService._base` in `lib/service/api_service.dart` to match your local IP if testing on a physical device.

### Run the Flutter app

```bash
flutter pub get
flutter run
```

## Environment

Create a `backend/.env` file with:

```
MONGO_URI=mongodb://localhost:27017/ekklesia
JWT_SECRET=your_jwt_secret
PORT=4000
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](LICENSE)
