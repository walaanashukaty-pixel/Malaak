class JourneyProgress {
  JourneyProgress({required this.domainId,this.status='مراقبة',this.completedPractices=0,this.updatedAt});
  final String domainId; final String status; final int completedPractices; final DateTime? updatedAt;
  JourneyProgress copyWith({String? status,int? completedPractices,DateTime? updatedAt})=>JourneyProgress(domainId:domainId,status:status??this.status,completedPractices:completedPractices??this.completedPractices,updatedAt:updatedAt??this.updatedAt);
  Map<String,dynamic> toJson()=>{'domainId':domainId,'status':status,'completedPractices':completedPractices,'updatedAt':updatedAt?.toIso8601String()};
  factory JourneyProgress.fromJson(Map<String,dynamic> j)=>JourneyProgress(domainId:j['domainId'] as String,status:j['status'] as String? ?? 'مراقبة',completedPractices:j['completedPractices'] as int? ?? 0,updatedAt:j['updatedAt']==null?null:DateTime.parse(j['updatedAt'] as String));
}
