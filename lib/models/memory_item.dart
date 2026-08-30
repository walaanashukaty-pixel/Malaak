enum MemoryType { fact, goal, preference, pattern, hypothesis }
class MemoryItem {
  MemoryItem({required this.id,required this.type,required this.value,required this.createdAt,this.confidence='medium'});
  final String id; final MemoryType type; final String value; final DateTime createdAt; final String confidence;
  Map<String,dynamic> toJson()=>{'id':id,'type':type.name,'value':value,'createdAt':createdAt.toIso8601String(),'confidence':confidence};
  factory MemoryItem.fromJson(Map<String,dynamic> j)=>MemoryItem(id:j['id'] as String,type:MemoryType.values.firstWhere((e)=>e.name==j['type'],orElse:()=>MemoryType.fact),value:j['value'] as String,createdAt:DateTime.parse(j['createdAt'] as String),confidence:j['confidence'] as String? ?? 'medium');
}
