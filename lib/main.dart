import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Joke {
  final String content;
  bool liked;

  Joke(this.content, {this.liked = false});
}

class JokeApp extends StatefulWidget {
  @override
  _JokeAppState createState() => _JokeAppState();
}

class _JokeAppState extends State<JokeApp> {
  List<Joke> jokes = [];
  int currentIndex = 0;
  bool noMoreJokes = false;

  void _fetchJokes() {
    jokes = [
      Joke(
        "A child asked his father, 'How were people born?' So his father said, 'Adam and Eve made babies, then their babies became adults and made babies, and so on.'",
      ),
      Joke(
        "The child then went to his mother, asked her the same question and she told him, 'We were monkeys then we evolved to become like we are now.'",
      ),
      Joke(
        "The child ran back to his father and said, 'You lied to me!' His father replied, 'No, your mom was talking about her side of the family.'",
      ),
      Joke(
        "Teacher: 'Kids, what does the chicken give you?' Student: 'Meat!' Teacher: 'Very good! Now what does the pig give you?' Student: 'Bacon!' Teacher: 'Great! And what does the fat cow give you?' Student: 'Homework!'",
      ),
      Joke(
        "The teacher asked Jimmy, 'Why is your cat at school today Jimmy?' Jimmy replied crying, 'Because I heard my daddy tell my mommy, 'I am going to eat that pussy once Jimmy leaves for school today!''",
      ),
      Joke(
        "A housewife, an accountant and a lawyer were asked 'How much is 2+2?' The housewife replies: 'Four!'. The accountant says: 'I think it's either 3 or 4. Let me run those figures through my spreadsheet one more time.' The lawyer pulls the drapes, dims the lights and asks in a hushed voice, 'How much do you want it to be?'",
      ),
    ];
  }

  void _likeJoke() {
    setState(() {
      jokes[currentIndex].liked = true;
      currentIndex = (currentIndex + 1) % jokes.length;
      if (currentIndex == 0) {
        noMoreJokes = true;
      }
    });

    _saveVote(true);
  }

  void _dislikeJoke() {
    setState(() {
      jokes[currentIndex].liked = false;
      currentIndex = (currentIndex + 1) % jokes.length;
      if (currentIndex == 0) {
        noMoreJokes = true;
      }
    });

    _saveVote(false);
  }

  void _saveVote(bool liked) {
    FirebaseFirestore.instance.collection('votes').add({
      'jokeIndex': currentIndex,
      'liked': liked,
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchJokes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke App'),
      ),
      body: Column(
        children: [
          SizedBox(
            height:
                MediaQuery.of(context).size.height * 0.3, 
            child: Container(
              color: Colors.greenAccent,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Joke of the Day',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.7, // 70% for the content
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      jokes[currentIndex].content,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _likeJoke,
                          child: Text('Like'),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _dislikeJoke,
                          child: Text('Dislike'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.red,
                          ),
                        ),
                      ],
                    ),
                    if (noMoreJokes)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Text(
                          "That's all the jokes for today! Come back another day!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Joke App',
    home: JokeApp(),
  ));
}
