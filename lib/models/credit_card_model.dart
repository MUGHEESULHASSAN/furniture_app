class CreditCardModel {
  String cardNumber;
  String cardHolderName;
  String cvv;
  String validFrom; // MM/YY format
  String validTill; // MM/YY format

  CreditCardModel({
    required this.cardNumber,
    required this.cardHolderName,
    required this.cvv,
    required this.validFrom,
    required this.validTill,
  });

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'cvv': cvv,
      'validFrom': validFrom,
      'validTill': validTill,
    };
  }

  factory CreditCardModel.fromJson(Map<String, dynamic> json) {
    return CreditCardModel(
      cardNumber: json['cardNumber'],
      cardHolderName: json['cardHolderName'],
      cvv: json['cvv'],
      validFrom: json['validFrom'],
      validTill: json['validTill'],
    );
  }
}
