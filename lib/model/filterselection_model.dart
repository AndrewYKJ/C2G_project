class FilterType {
  String? displayName;
  bool? isSelected;
  String? key;
  List<SubCategory>? subCat;
  FilterType({this.key, this.displayName, this.isSelected, this.subCat});
}

class SubCategory {
  String? displayName;
  bool? isSelected;
  String? key;
  SubCategory({
    this.key,
    this.displayName,
    this.isSelected,
  });
}
