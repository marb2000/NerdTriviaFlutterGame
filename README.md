# Nerd Trivia Game

This is a dynamic trivia game built with Flutter, powered by Google's Gemini model through Vertex AI in Firebase. 

## Features

- **Dynamic Categories:** The game generates random categories for a unique experience every time.
- **Multiple Choice Questions:** Each question has four possible answers, with one correct answer.
- **Scoring System:** Players earn points for correct answers and lose points for incorrect ones.
- **Category Completion:**  Categories are disabled once all questions have been answered, encouraging exploration of different topics.
- **Game Restart:** Players can restart the game to generate new categories and start fresh.
- **Engaging Feedback:** The app provides random encouraging or funny messages based on the answer.

## How to Run

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-username/NerdTriviaFlutterGame.git
Use code with caution.

2. Set Up Firebase:
- Create a Firebase project and configure it for your Flutter app.
- Enable Vertex AI in Firebase in your project.
- Add your Firebase configuration files to the project (usually android/app/google-services.json for Android and ios/Runner/GoogleService-Info.plist for iOS).
3. Install Dependencies:
  ```bash
  flutter pub get
4. Run the App:
  ```bash
  flutter run
