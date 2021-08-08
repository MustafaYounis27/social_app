class DataFromApi {
  int id;
  String fieldNameAr;
  String fieldNameEn;

  DataFromApi(Map<String, dynamic> json)
  {
    this.id = json['Id'];
    this.fieldNameAr = json['FildNameAr'];
    this.fieldNameEn = json['FildNameEn'];
  }
}
