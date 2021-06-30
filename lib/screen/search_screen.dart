import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone_test/model/model_movie.dart';
import 'package:netflix_clone_test/screen/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // 검색 위젯을 컨트롤한다
  final TextEditingController _filter = TextEditingController();
  // 현재 검색 위젯에 커서가 있는지 없는지에 대한 상태를 가지고 있는 위젯
  FocusNode focusNode = FocusNode();
  String _searchText = "";

  _SearchScreenState() {
    // 검색 창에 Listener를 붙여 사용자가 검색하고 있는 텍스트의 상태 변화를 감지하고 가져온다
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  // Stream 데이터를 가져와 _buildList 호출
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('movie').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  // 검색 결과에 따라 데이터를 처리해 GridView를 생성
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<DocumentSnapshot> searchResults = [];
    for (DocumentSnapshot d in snapshot) {
      // data를 불러올 때 강의에서는 d.data.toString() 으로 되어있는데 d.data().toString()으로 버전업되면서 바꼈다
      if (d.data().toString().contains(_searchText)) {  
        searchResults.add(d);
      }
    }
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1/1.5,
        padding: EdgeInsets.all(3),
        children: searchResults
          .map((data) => _buildListItem(context, data))
          .toList()
      ),
    );
  }

  // GridView에 들어갈 아이템들을 만들고 각각 DetailScreen을 띄울 수 있도록 함
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final movie = Movie.fromSnapshot(data);
    return InkWell(
      child: Image.network(movie.poster),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<Null>(
          fullscreenDialog: true,
          builder: (BuildContext context) {
            return DetailScreen(movie: movie);
          }
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(30),
          ),
          Container(
            color: Colors.black,
            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: TextField(
                    focusNode: focusNode,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    autofocus: true,
                    controller: _filter,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white12,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white60,
                        size: 20,
                      ),
                      suffixIcon: focusNode.hasFocus
                        ? IconButton(
                            icon: Icon(
                              Icons.cancel,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _filter.clear();
                                _searchText = "";
                              });
                            },
                          )
                        : Container(),
                      hintText: '검색',
                      labelStyle: TextStyle(
                        color: Colors.white
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
                focusNode.hasFocus
                  ? Expanded(
                      child: FlatButton(
                        child: Text('취소'),
                        onPressed: () {
                          setState(() {
                            _filter.clear();
                            _searchText = "";
                            focusNode.unfocus();
                          });
                        },
                      ),
                    ) 
                  : Expanded(
                      flex: 0,
                      child: Container(),
                    )
              ],
            ),
          ),
          _buildBody(context)
        ],
      ),
    );
  }
}