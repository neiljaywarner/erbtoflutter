import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ref Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const RefTestScreen(),
    );
  }
}

class RefTestScreen extends StatefulWidget {
  const RefTestScreen({super.key});

  @override
  _RefTestScreenState createState() => _RefTestScreenState();
}

class _RefTestScreenState extends State<RefTestScreen> {
  String pageTitle = 'Reference Test'; 
  int questionNumber = 1;
  String verseText = "In the beginning God created the heavens and the earth.";
  String verseAttribution = "NLT";
  String expectedReference = "Genesis 1:1";
  final TextEditingController answerController = TextEditingController();
  double referenceRecallGrade = 60.0; 
  int overdueReferences = 5; 
  List<String> pastQuestions = ['Question 1', 'Question 2']; 
  String memverseUserID = 'user123'; 

  final List<String> bookSuggestions = [
    'Genesis', 'Exodus', 'Leviticus', 'Numbers', 'Deuteronomy', 'Joshua', 'Judges', 'Ruth', '1 Samuel', '2 Samuel',
    '1 Kings', '2 Kings','1 Chronicles', '2 Chronicles', 'Ezra', 'Nehemiah', 'Esther', 'Job', 'Psalm', 'Proverbs',
    'Ecclesiastes', 'Song of Songs', 'Isaiah', 'Jeremiah', 'Lamentations', 'Ezekiel', 'Daniel', 'Hosea', 'Joel',
    'Amos', 'Obadiah', 'Jonah', 'Micah', 'Nahum', 'Habakkuk', 'Zephaniah', 'Haggai', 'Zechariah', 'Malachi', 'Matthew',
    'Mark', 'Luke', 'John', 'Acts', 'Romans', '1 Corinthians', '2 Corinthians', 'Galatians', 'Ephesians', 'Philippians',
    'Colossians', '1 Thessalonians', '2 Thessalonians', '1 Timothy', '2 Timothy', 'Titus', 'Philemon', 'Hebrews', 'James',
    '1 Peter', '2 Peter', '1 John', '2 John', '3 John', 'Jude', 'Revelation'
  ];
  final FocusNode answerFocusNode = FocusNode();

  int scoreRef(String answer) {
    return answer.toLowerCase().contains('genesis') ? 100 : 0;
  }

  double updateRefGrade(int questionScore) {
    setState(() {
      referenceRecallGrade = (referenceRecallGrade + questionScore) / 2;
    });
    return referenceRecallGrade;
  }

  bool isReferenceValid = true;
  String validationMessage = '';
  bool hasSubmittedAnswer = false;
  bool isAnswerCorrect = false;

  bool isValidVerseRef(String text) {
    if (text.isEmpty) {
      setState(() {
        isReferenceValid = false;
        validationMessage = 'Reference cannot be empty';
      });
      return false;
    }

    final bookChapterVersePattern = RegExp(
      r'^(([1-3]\s+)?[A-Za-z]+(\s+[A-Za-z]+)*)\s+(\d+):(\d+)(-\d+)?$'
    );
    
    if (bookChapterVersePattern.hasMatch(text)) {
      final match = bookChapterVersePattern.firstMatch(text);
      final bookName = match?.group(1)?.trim() ?? '';
      
      if (bookSuggestions.any((book) => 
          book.toLowerCase() == bookName.toLowerCase())) {
        setState(() {
          isReferenceValid = true;
          validationMessage = '';
        });
        return true;
      } else {
        setState(() {
          isReferenceValid = false;
          validationMessage = 'Invalid book name';
        });
        return false;
      }
    } else {
      setState(() {
        isReferenceValid = false;
        validationMessage = 'Format should be "Book Chapter:Verse"';
      });
      return false;
    }
  }

  void submitAnswer() {
    if (isValidVerseRef(answerController.text)) {
      setState(() {
        hasSubmittedAnswer = true;
        isAnswerCorrect = answerController.text.trim().toLowerCase() == expectedReference.toLowerCase();
        
        if (isAnswerCorrect) {
          referenceRecallGrade = (referenceRecallGrade + 100) / 2;
          if (referenceRecallGrade > 100) referenceRecallGrade = 100;
        }
      });
      
      debugPrint('Answer submitted: ${answerController.text}, Correct: $isAnswerCorrect, Grade: $referenceRecallGrade');
    } else {
      debugPrint('Invalid reference: ${answerController.text}');
    }
  }

  InputDecoration getInputDecoration() {
    final bool showSuccessStyle = hasSubmittedAnswer && isAnswerCorrect;
    final bool showErrorStyle = hasSubmittedAnswer && !isAnswerCorrect;
    
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: showSuccessStyle ? Colors.green : 
                 showErrorStyle ? Colors.orange : 
                 Colors.grey[300]!,
          width: (showSuccessStyle || showErrorStyle) ? 2.0 : 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: showSuccessStyle ? Colors.green : 
                 showErrorStyle ? Colors.orange : 
                 Colors.grey[300]!,
          width: (showSuccessStyle || showErrorStyle) ? 2.0 : 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: showSuccessStyle ? Colors.green : 
                 showErrorStyle ? Colors.orange : 
                 Colors.blue,
          width: 2.0,
        ),
      ),
      hintText: 'Enter reference (e.g., Genesis 1:1)',
      errorText: isReferenceValid ? null : validationMessage,
      helperText: showSuccessStyle ? 'Correct!' : 
                  showErrorStyle ? 'Incorrect' : 
                  'Format: Book Chapter:Verse',
      helperStyle: TextStyle(
        color: showSuccessStyle ? Colors.green : 
               showErrorStyle ? Colors.orange : 
               Colors.grey[600],
        fontWeight: (showSuccessStyle || showErrorStyle) ? FontWeight.bold : FontWeight.normal,
      ),
      suffixIcon: showSuccessStyle 
          ? const Icon(Icons.check_circle, color: Colors.green)
          : showErrorStyle 
              ? const Icon(Icons.cancel, color: Colors.orange) 
              : null,
      filled: showSuccessStyle || showErrorStyle,
      fillColor: showSuccessStyle ? Colors.green.withOpacity(0.1) : 
                 showErrorStyle ? Colors.orange.withOpacity(0.1) : 
                 null,
    );
  }

  @override
  void initState() {
    super.initState();
    answerFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          margin: const EdgeInsets.all(16.0),
          child: isSmallScreen
              ? Column(
                  children: [
                    _buildQuestionSection(),
                    const SizedBox(height: 24.0),
                    _buildStatsAndHistorySection(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: _buildQuestionSection()),
                    const SizedBox(width: 16.0),
                    Expanded(child: _buildStatsAndHistorySection()),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildQuestionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                const TextSpan(text: 'Question: '),
                TextSpan(
                  text: '$questionNumber',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        
        // Verse text with NLT attribution - explicitly above the reference field
        Container(
          key: const Key('reftestVerse'),
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 24.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.grey[50],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                verseText,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    verseAttribution,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Reference label
        Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: const Text(
            'Reference:',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ),
        
        // Simple text field with autocomplete options displayed below
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: answerController,
              focusNode: answerFocusNode,
              decoration: getInputDecoration(),
              onChanged: (value) {
                // Reset submission state when typing
                if (hasSubmittedAnswer) {
                  setState(() {
                    hasSubmittedAnswer = false;
                    isAnswerCorrect = false;
                  });
                }
                
                // Show autocomplete suggestions if we're typing a book name
                setState(() {});
              },
              onSubmitted: (value) {
                submitAnswer();
              },
            ),
            
            // Show book suggestions if relevant
            if (_shouldShowSuggestions())
              Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(
                  maxHeight: 200,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: _getFilteredSuggestions().map((book) {
                    return ListTile(
                      dense: true,
                      title: Text(book),
                      onTap: () {
                        _selectBookSuggestion(book);
                      },
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
        
        const SizedBox(height: 16.0),
        
        // Submit button
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            key: const Key('submit-ref'),
            onPressed: submitAnswer,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          ),
        ),
        
        // Success/failure message (only shown after submission)
        if (hasSubmittedAnswer)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                Icon(
                  isAnswerCorrect ? Icons.thumb_up : Icons.error_outline,
                  color: isAnswerCorrect ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isAnswerCorrect 
                        ? 'Great job! You correctly identified this verse as $expectedReference.'
                        : 'That\'s not quite right. The correct reference is $expectedReference.',
                    style: TextStyle(
                      color: isAnswerCorrect ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  bool _shouldShowSuggestions() {
    // Show suggestions if text is not empty and doesn't contain a space yet
    final text = answerController.text.trim();
    return text.isNotEmpty && !text.contains(' ') && _getFilteredSuggestions().isNotEmpty;
  }
  
  List<String> _getFilteredSuggestions() {
    final text = answerController.text.trim().toLowerCase();
    if (text.isEmpty) return [];
    
    // Filter books that start with the current text
    return bookSuggestions
        .where((book) => book.toLowerCase().startsWith(text))
        .take(5) // Limit to 5 suggestions
        .toList();
  }
  
  void _selectBookSuggestion(String book) {
    setState(() {
      // Add a space after the book name to prepare for entering chapter:verse
      answerController.text = '$book ';
      
      // Position cursor at the end
      answerController.selection = TextSelection.fromPosition(
        TextPosition(offset: answerController.text.length),
      );
      
      // Reset submission state if needed
      if (hasSubmittedAnswer) {
        hasSubmittedAnswer = false;
        isAnswerCorrect = false;
      }
    });
    
    // Ensure focus returns to the text field
    answerFocusNode.requestFocus();
  }

  Widget _buildStatsAndHistorySection() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 160,
                child: _buildGauge(),
              ),
              const SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey[100],
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      '$overdueReferences',
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'References Due Today',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Prior Questions',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Container(
                key: const Key('past-questions'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pastQuestions.map((question) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(question),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGauge() {
    Color gaugeColor;
    if (referenceRecallGrade < 33) {
      gaugeColor = Colors.red[400]!;
    } else if (referenceRecallGrade < 66) {
      gaugeColor = Colors.orange[400]!;
    } else {
      gaugeColor = Colors.green[400]!;
    }
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Reference Recall', style: TextStyle(fontSize: 14)),
        const SizedBox(height: 10),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: referenceRecallGrade / 100,
                strokeWidth: 15,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
              ),
            ),
            Text(
              '${referenceRecallGrade.toInt()}%',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    answerController.dispose();
    answerFocusNode.dispose();
    super.dispose();
  }
}