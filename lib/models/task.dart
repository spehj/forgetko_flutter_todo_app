
// Task object with 3 fields
class Task {
  final int? id;
  final String title;
  final String? description;
  Task({required this.id, required this.title, required this.description});

  // Method to convert object to map
  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'title' : title,
      'description' : description,
    };
  }
}