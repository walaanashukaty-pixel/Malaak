class MalaakMessage {
  MalaakMessage({required this.id,required this.text,required this.isUser,required this.createdAt});
  final String id,text; final bool isUser; final DateTime createdAt;
  Map<String,dynamic> toJson()=>{'id':id,'text':text,'isUser':isUser,'createdAt':createdAt.toIso8601String()};
  factory MalaakMessage.fromJson(Map<String,dynamic> j)=>MalaakMessage(id:j['id'] as String,text:j['text'] as String,isUser:j['isUser'] as bool,createdAt:DateTime.parse(j['createdAt'] as String));
}
