class UserPreferences {
  const UserPreferences({this.allowPatterns=true,this.allowJournalAnalysis=false,this.includeInReports=true,this.displayName=''});
  final bool allowPatterns,allowJournalAnalysis,includeInReports; final String displayName;
  UserPreferences copyWith({bool? allowPatterns,bool? allowJournalAnalysis,bool? includeInReports,String? displayName})=>UserPreferences(allowPatterns:allowPatterns??this.allowPatterns,allowJournalAnalysis:allowJournalAnalysis??this.allowJournalAnalysis,includeInReports:includeInReports??this.includeInReports,displayName:displayName??this.displayName);
  Map<String,dynamic> toJson()=>{'allowPatterns':allowPatterns,'allowJournalAnalysis':allowJournalAnalysis,'includeInReports':includeInReports,'displayName':displayName};
  factory UserPreferences.fromJson(Map<String,dynamic> j)=>UserPreferences(allowPatterns:j['allowPatterns'] as bool? ?? true,allowJournalAnalysis:j['allowJournalAnalysis'] as bool? ?? false,includeInReports:j['includeInReports'] as bool? ?? true,displayName:j['displayName'] as String? ?? '');
}
