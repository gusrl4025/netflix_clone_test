import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String title;
  final String keyword;
  final String poster;
  final bool like;
  // DocumentReference는 실제 Firebase firestore에 있는 데이터 컬럼을 참조할 수 있는 링크
  final DocumentReference reference;

  // 이 reference를 통해 해당 데이터에 대한 CRUD 기능을 아주 간단히 처리할 수 있다.
  Movie.fromMap(Map<String, dynamic> map, {this.reference})
      : title = map['title'],
        keyword = map['keyword'],
        poster = map['poster'],
        like = map['like'];

  Movie.fromSnapshot(DocumentSnapshot snapshot)
    // 강의에서는 snapshot.data로 되어있었는데 에러가 나서 snapshot.data()로 바꿨다
    : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Movie<$title:$keyword>";
}
