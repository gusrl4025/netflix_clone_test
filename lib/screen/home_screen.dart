import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone_test/model/model_movie.dart';
import 'package:netflix_clone_test/widget/box_slider.dart';
import 'package:netflix_clone_test/widget/carousel_slider.dart';
import 'package:netflix_clone_test/widget/circle_slider.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 강의에서는 Firestore firestore = Firestore.instance; 라 했는데 버전 업이되어 FirebaseFirestore로 바뀐 듯하다
  // Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // streamData 선언
  Stream<QuerySnapshot> streamData;
  @override
  void initState() {
    super.initState();
    // 'movie'는 콘솔에서 생성한 collection
    streamData = firestore.collection('movie').snapshots();
  }

  // streamData로부터 데이터를 추출하여 위젯으로 만드는 과정
  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // streamData
      stream: FirebaseFirestore.instance.collection('movie').snapshots(),
      builder: (context, snapshot) {
        // movie를 아직 못가져왔다면 로딩화면
        if (!snapshot.hasData) return LinearProgressIndicator();
        // 가져왔으면 실제위젯을 만듦
        // snapshot.data.document가 에러가 나서 snapshot.data.docs로 했음
        return _buildBody(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<Movie> movies = snapshot.map((d) => Movie.fromSnapshot(d)).toList();
    return ListView(
      children: <Widget>[
        Stack(children: <Widget>[
          CarouselImage(
            movies: movies),
            TopBar(),
          ],
        ),
        CircleSlider(movies: movies),
        BoxSlider(movies: movies),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            'images/bbongflix_logo.png',
            fit: BoxFit.contain,
            height: 25,
          ),
          Container(
            padding: EdgeInsets.only(right: 1),
            child: Text(
              'TV 프로그램',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 1),
            child: Text(
              '영화',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 1),
            child: Text(
              '내가 찜한 콘텐츠',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      )
    );
  }
}
