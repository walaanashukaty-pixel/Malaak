class JournalEntry {
  JournalEntry({required this.id, required this.body, required this.createdAt, this.title='موقف جديد', this.tag='تسجيل شخصي', this.includeInReports=true});
  final String id; final String body; final DateTime createdAt; final String title; final String tag; final bool includeInReports;
  Map<String,dynamic> toJson()=>{'id':id,'body':body,'createdAt':createdAt.toIso8601String(),'title':title,'tag':tag,'includeInReports':includeInReports};
  factory JournalEntry.fromJson(Map<String,dynamic> j)=>JournalEntry(id:j['id'] as String,body:j['body'] as String,createdAt:DateTime.parse(j['createdAt'] as String),title:j['title'] as String? ?? 'موقف جديد',tag:j['tag'] as String? ?? 'تسجيل شخصي',includeInReports:j['includeInReports'] as bool? ?? true);
}
