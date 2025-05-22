---
applyTo: "**"
---

You will act as an expert Flutter developer to help me build a prototype for a mobile app called SnackTrack, designed for self-service tuc shop tracking via QR scanning and Google Sheets integration. The app is for internal use only, targeting Android and iOS platforms.

🎯 Objective:
Build a core prototype with the following features:

Simple login using email + 4-digit PIN

QR scanning to identify product

Item detail lookup from a local JSON file

Confirm purchase and log to Google Sheets via Apps Script Web App

View user’s transaction history from the Google Sheet

🔄 User Flow:
On first use, user logs in with email + PIN (saved via shared_preferences)

User scans product QR code (e.g., https://snackscan.app/log?item=snickers)

App extracts item ID and looks up item details (name and price) from a bundled JSON file

Quantity input (default = 1) is shown, user taps "Confirm"

App sends POST request to backend with: timestamp, email, item, quantity, total price

App fetches and displays user’s transactions

📄 Local Item Lookup (sample assets/items.json):
json
Copy
Edit
{
"snickers": { "name": "Snickers", "price": 100 },
"lays": { "name": "Lays Chips", "price": 80 },
"coke": { "name": "Coca-Cola", "price": 120 }
}
🔧 Tech Stack:
Frontend: Flutter

QR Scanning: mobile_scanner or qr_code_scanner

User Auth: Email + PIN stored locally via shared_preferences

Backend: Google Apps Script Web App

Storage: Google Sheets

🧾 Google Sheet Format:
Timestamp | User Email | Item | Quantity | Total Price

📦 Dependencies (pubspec.yaml):
yaml
Copy
Edit
dependencies:
flutter:
sdk: flutter
mobile_scanner: ^3.2.0
http: ^1.2.0
shared_preferences: ^2.2.0
📌 What I Need From You:
Folder structure and how to organize screens/models/helpers

Flutter code samples for:

Email + PIN login UI

QR code scanner

Item detail screen

Quantity input + confirm

HTTP request to Google Apps Script

Transaction list screen

Sample Google Apps Script:

Endpoint to log transactions to a Google Sheet

Endpoint to fetch transactions for a given email

How to deploy and connect to Google Sheets backend
