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
  int questionNumber = 0;
  String verseText = ''; 
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

  void submitAnswer() {
    int questionScore = scoreRef(answerController.text);
    double newGrade = updateRefGrade(questionScore);
    debugPrint('Answer submitted: ${answerController.text}, Score: $questionScore, New Grade: $newGrade');
  }

  bool isValidVerseRef(String text) {
    return text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    answerFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(bottom: 8.0),
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
                              Container(
                                key: const Key('reftestVerse'),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(verseText),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                            Autocomplete<String>(
                              optionsBuilder: (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                return bookSuggestions.where((String option) {
                                  return option.toLowerCase().startsWith(
                                        textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (String selection) {
                                answerController.text = selection;
                              },
                              fieldViewBuilder: (
                                BuildContext context,
                                TextEditingController fieldController,
                                FocusNode fieldFocusNode,
                                VoidCallback onFieldSubmitted,
                              ) {
                                answerController.addListener(() {
                                  if (fieldController.text != answerController.text) {
                                    fieldController.text = answerController.text;
                                  }
                                });
                                
                                fieldController.text = answerController.text;
                                
                                return TextField(
                                  controller: fieldController,
                                  focusNode: fieldFocusNode,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter reference',
                                  ),
                                  onChanged: (value) {
                                    answerController.text = value;
                                  },
                                  onSubmitted: (value) {
                                    answerController.text = value;
                                    submitAnswer();
                                  },
                                );
                              },
                              optionsViewBuilder: (
                                BuildContext context,
                                AutocompleteOnSelected<String> onSelected,
                                Iterable<String> options,
                              ) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 4.0,
                                    child: Container(
                                      constraints: const BoxConstraints(maxHeight: 200),
                                      width: MediaQuery.of(context).size.width * 0.4,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(8.0),
                                        itemCount: options.length > 5 ? 5 : options.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          final String option = options.elementAt(index);
                                          return ListTile(
                                            dense: true,
                                            title: Text(option),
                                            onTap: () {
                                              onSelected(option);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8.0),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                key: const Key('submit-ref'),
                                onPressed: submitAnswer,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                ),
                                child: const Text('Submit'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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