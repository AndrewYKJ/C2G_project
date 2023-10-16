class SubmitReportArg {
  String? catCode;
  String? catDescEn;
  String? catDescBm;
  String? subCatCode;
  String? subCatDescEn;
  String? subCatDescBm;
  String? from;

  SubmitReportArg(
      {this.catCode,
      this.subCatCode,
      this.catDescBm,
      this.catDescEn,
      this.subCatDescBm,
      this.subCatDescEn,
      this.from});
}
