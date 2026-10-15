# EcclSync Flutter Demo

This is a standalone, local-only Flutter demo of the church community app. It
does not use MongoDB, another database, a backend API, or real accounts.
Sign-in uses the built-in demo credentials below. Events, prayer requests, and
chat messages are kept in memory and reset when the app restarts.

## Run

Install the Flutter SDK and run these commands from the repository root:

```powershell
flutter pub get
flutter run
```

Run the automated checks and produce a web build with:

```powershell
flutter analyze
flutter test
flutter build web
```

## Demo accounts

| Role | Email | Password |
|---|---|---|
| Admin | `admin@ecclsync.demo` | `Admin123!` |
| Ministry Leader | `leader@ecclsync.demo` | `Leader123!` |
| Member | `member@ecclsync.demo` | `Member123!` |

These accounts only select a demo profile; there is no real authentication or
role-based authorization.

The demo includes event RSVP, prayer requests and support, searchable
directories, a sample Bible section, announcements, notifications, and local
chat. Other areas show sample information. Payments, persistence, push
notifications, and server-backed management actions are not implemented.
