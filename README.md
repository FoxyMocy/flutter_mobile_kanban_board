Kanban Board App
This is a simple Kanban board app built with Flutter. It allows you to create, move and delete tasks across different stages of your workflow. The app uses Firebase to store and sync the data across multiple devices.

Features
Create new tasks with a title and description
Move tasks across different stages of your workflow (To Do, In Progress, Done)
Edit and delete existing tasks
Real-time data sync with Firebase
Offline support (tasks are stored locally and synced when online)
Screenshots
Kanban Board App Screenshots

Getting Started
To use this app, you'll need to have a Firebase project set up. Follow these steps to get started:

Clone this repository:

bash
Copy code
git clone https://github.com/your-username/kanban-board-app.git
Create a new Firebase project and enable the Firestore and Authentication services.

Copy the google-services.json file to the android/app directory.

Copy the GoogleService-Info.plist file to the ios/Runner directory.

Run the app on your device or emulator:

Copy code
flutter run
Contributing
Contributions are welcome! If you have an idea for a new feature or want to fix a bug, feel free to open a pull request. If you find a bug or have a feature request, please open an issue.

License
This project is licensed under the MIT License. Feel free to use the code for your own projects or modify it to fit your needs.

Acknowledgements
This app was built using the following open-source packages:

Flutter
Firebase
provider
cloud_firestore
intl