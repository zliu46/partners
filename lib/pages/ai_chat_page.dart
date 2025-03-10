import 'package:flutter/material.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class AIChatPage extends StatefulWidget {
  @override
  _AIChatPageState createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAI();
  }
  final model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-2.0-flash');

  Future<void> _initializeAI() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty || _isLoading) return;

    final userMessage = _controller.text;
    setState(() {
      _messages.add({"user": userMessage});
      _isLoading = true;
    });
    _controller.clear();

    try {
      final prompt = [Content.text(userMessage)];
      final response = await model.generateContent(prompt);

      setState(() {
        _messages.add({"ai": response.text ?? "Sorry, I didn't understand that."});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({"ai": "Error: ${e.toString()}"});
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('AI Chat',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[100],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.containsKey("user") ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.containsKey("user") ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message.values.first,
                      style: TextStyle(color: message.containsKey("user") ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator()),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue[100]),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
