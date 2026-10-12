class AutoCompleteSearchModel{

 String? description;
 String ?placeId;
 AutoCompleteSearchModel({this.description,this.placeId});
 AutoCompleteSearchModel.fromJson(Map<String,dynamic> json){
   this.description = json['description'];
   this.placeId = json['place_id'];
 }
}