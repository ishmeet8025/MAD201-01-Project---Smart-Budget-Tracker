# MAD201-01-Project---Smart-Budget-Tracker
MAD201-01 Project - Smart Budget Tracker

# Smart Budget Tracker Lite

**Course:** MAD201-01  
**Student Name:** Ishmeet Singh  
**Student ID:** A00202436  

## Project Overview
Smart Budget Tracker Lite is a Flutter-based application that allows users to track daily income and expenses, view current balance, and analyze spending through reports. The app demonstrates multi-screen navigation, state management, local storage with Hive, SharedPreferences, and simple API integration.

## Features
- **Splash Screen:** 2-second welcome screen before navigating to the Home Dashboard.
- **Home Screen:** Displays total income, expenses, and balance in summary cards. Provides navigation buttons for adding transactions, viewing transaction history, reports, and settings.
- **Add Transaction:** Form to add or edit transactions with fields for title, amount, type (Income/Expense), category, and date.
- **Transactions List:** View all recorded transactions with edit and delete functionality. Income shown in green, Expense in red.
- **Reports & Summary:** Totals by category and by month displayed using Cards and ListTile.
- **Settings:** Toggle Light/Dark theme and select currency preference. Optionally fetches currency conversion rates via API.
- **Persistent Storage:** Transactions stored locally using Hive. Preferences saved with SharedPreferences.
- **State Management:** UI updates dynamically using `setState()` after transactions are added, edited, or deleted.

## Technology Stack
- Flutter & Dart
- Hive (local database)
- SharedPreferences (user settings)
- HTTP (optional API integration)
- Intl (currency formatting)

## Folder Structure

lib/
├─ db/
│ └─ db_helper.dart
├─ models/
│ ├─ transaction_model.dart
│ └─ transaction_model.g.dart
├─ screens/
│ ├─ splash_screen.dart
│ ├─ home_screen.dart
│ ├─ add_transaction_screen.dart
│ ├─ transactions_list_screen.dart
│ ├─ reports_screen.dart
│ └─ settings_screen.dart
├─ utils/
│ └─ shared_prefs_helper.dart
main.dart
pubspec.yaml
