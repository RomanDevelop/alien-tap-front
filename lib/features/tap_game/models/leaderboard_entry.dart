
import 'package:equatable/equatable.dart';


class LeaderboardEntry extends Equatable {
  final String userId;
  final String? username;
  final String? firstName;
  final int score;

  const LeaderboardEntry({required this.userId, this.username, this.firstName, required this.score});

  
  String get displayName => username ?? firstName ?? 'Игрок';

  
  int get rank => 0; 

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['user_id'] as String,
      username: json['username'] as String?,
      firstName: json['first_name'] as String?,
      score: json['score'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'username': username, 'first_name': firstName, 'score': score};
  }

  @override
  List<Object?> get props => [userId, username, firstName, score];
}
