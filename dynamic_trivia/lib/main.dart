// ignore_for_file: avoid_print, void_checks

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TriviaGame(),
    );
  }
}

// Type for Category
class Category {
  final String name;
  final Color color;
  bool enabled =
      true; // It will be disable if the user already answered all the questions

  Category({required this.name, required this.color, this.enabled = true});
}

// Type for Question
class Question {
  final String text;
  final List<String> answers;
  final int correctAnswerIndex;

  Question(
      {required this.text,
      required this.answers,
      required this.correctAnswerIndex});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['question'],
      answers: List<String>.from(json['answers']),
      correctAnswerIndex: json['correctAnswer'],
    );
  }
}

class TriviaGame extends StatefulWidget {
  const TriviaGame({super.key});

  @override
  State<TriviaGame> createState() => _TriviaGameState();
}

class _TriviaGameState extends State<TriviaGame> {
  // Game state variables
  List<Category> categories = [];
  Category? selectedCategory;
  List<Question> questionsForCategory =
      []; // Questions for the selected category
  int currentQuestionIndex = 0; // Index of the currently displayed question
  int score = 0; // User score
  int? selectedAnswerIndex; // Store selected answer index
  bool showResult = false;
  bool isLoading = false;
  String resultMessage = ''; // Store the result message

  final int _numberCategories = 5;
  final int _numberQuestions = 10;

  final List<Color> predefinedColors = [
    Colors.red,
    Colors.yellow,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.brown,
  ]; // Predefined distinct colors

  final List<String> correctMessages = [
    'Awesome!',
    'That\'s right!',
    'You\'re a genius!',
    'Correct!',
    'Spot on!',
  ];
  final List<String> incorrectMessages = [
    'Oops!',
    'Not quite.',
    'Try again!',
    'Wrong answer.',
    'Incorrect.',
  ];

  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    initializeModel().then(initializeGame);
  }

  Future<void> initializeModel() async {
    _model =
        FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');
  }

  Future<void> initializeGame(void value) async {
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      isLoading = true;
    });

    final prompt = Content.text('''We are playing trivia pursuit for nerds,
        who love music, role play games, computing, science, TV Series, comics, videogames, history, and a large etc. 
        Generate $_numberCategories random categories and return them as a JSON array: 
        ['category1', 'category2', ...]''');

    final response = await _model.generateContent(
      [prompt],
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );

    setState(() {
      // Parse the JSON response
      final List<dynamic> parsedJson = jsonDecode(response.text!);

      // Convert the parsed JSON to a List<Category>
      categories = List<String>.from(parsedJson).map((categoryName) {
        return Category(
          name: categoryName,
          color: predefinedColors[
              parsedJson.indexOf(categoryName) % predefinedColors.length],
        );
      }).toList();

      isLoading = false;
    });
  }

  // Function to generate 10 questions for the selected category
  Future<void> _generateQuestionsForCategory(Category category) async {
    setState(() {
      isLoading = true;
      showResult = false;
    });

    List<Question> newQuestions = [];

    final prompt = Content.text('''
        Generate $_numberQuestions different trivia questions about ${category.name} along with 4 possible answers (one correct). 
        Return the data in JSON format like this: 
        [{'question': '...', 'answers': ['...', '...', '...', '...'], 'correctAnswer': index}, {...}]
        ''');

    final response = await _model.generateContent(
      [prompt],
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );

    // Parse the JSON response
    final List<dynamic> parsedJson = jsonDecode(response.text!);
    for (var questionJson in parsedJson) {
      final newQuestion = Question.fromJson(questionJson);
      newQuestions.add(newQuestion);
    }

    setState(() {
      questionsForCategory = newQuestions;
      currentQuestionIndex = 0; // Start from the first question
      isLoading = false;
    });
  }

  // Function to move to the next question
  void _nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questionsForCategory.length - 1) {
        currentQuestionIndex++;
      } else {
        // If all questions answered, disable the category
        selectedCategory!.enabled = false;
        selectedCategory = null; // Go back to category selection
      }
      showResult = false; // Hide result display
    });
  }

  // Function to restart the game
  void _restartGame() {
    setState(() {
      score = 0;
      selectedCategory = null;
      showResult = false;
      currentQuestionIndex = 0;
      questionsForCategory.clear(); // Clear questions
      for (var category in categories) {
        category.enabled = true; // Re-enable all categories
      }
      _fetchCategories(); // Regenerate categories
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedCategory != null
              ? selectedCategory!.name
              : 'Nerd Trivia Game',
        ),
        actions: [
          // Restart button in AppBar
          IconButton(
            onPressed: _restartGame,
            icon: const Icon(Icons.refresh),
          ),
        ],
        backgroundColor: selectedCategory?.color,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Show categories or question based on state
                  if (selectedCategory == null)
                    _buildCategorySelection()
                  else if (showResult)
                    _buildResult()
                  else
                    _buildQuestion(),
                ],
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: selectedCategory?.color.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Text(
                'Score: $score',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display category selection buttons
  Widget _buildCategorySelection() {
    return Column(
      children: categories.map((category) {
        return Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 8.0), // Add padding here
          child: ElevatedButton(
            onPressed: category.enabled
                ? () {
                    setState(() {
                      selectedCategory = category;
                    });
                    _generateQuestionsForCategory(category);
                  }
                : null, // Disable button if category is disabled
            style: ElevatedButton.styleFrom(
              backgroundColor: category.color.withOpacity(0.5),
            ),
            child: Text(
              category.name,
              style: TextStyle(color: _getContrastColor(category.color)),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Widget to display the question and answer buttons
  Widget _buildQuestion() {
    return Column(
      children: [
        // Question number display
        Text(
          'Question ${currentQuestionIndex + 1} of ${questionsForCategory.length}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.all(16.0), // Add padding to the question
          child: Text(
            questionsForCategory[currentQuestionIndex].text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center, // Center the question text
          ),
        ),
        const SizedBox(height: 20),
        ...questionsForCategory[currentQuestionIndex]
            .answers
            .asMap()
            .entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0), // Add padding here
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedAnswerIndex = entry.key;
                      showResult = true;
                      // Generate a random result message
                      final Random random = Random();
                      if (selectedAnswerIndex ==
                          questionsForCategory[currentQuestionIndex]
                              .correctAnswerIndex) {
                        resultMessage = correctMessages[
                            random.nextInt(correctMessages.length)];
                        score++;
                      } else {
                        resultMessage = incorrectMessages[
                            random.nextInt(incorrectMessages.length)];
                        score--;
                      }
                    });
                  },
                  child: Text(entry.value),
                ),
              ),
            ),
      ],
    );
  }

  // Widget to display the result and navigation buttons
  Widget _buildResult() {
    return Column(
      children: [
        Text(
          resultMessage, // Display the result message
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: selectedAnswerIndex ==
                    questionsForCategory[currentQuestionIndex]
                        .correctAnswerIndex
                ? Colors.green
                : Colors.red,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _nextQuestion, // Move to the next question
          child: const Text('Next Question'),
        ),
      ],
    );
  }

  // Helper function to get contrasting color for text
  Color _getContrastColor(Color color) {
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
