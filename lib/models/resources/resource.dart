class Resource {
  final String date;
  final String symbol;
  final double open;
  final double close;
  const Resource({
    required this.date,
    required this.symbol,
    required this.close,
    required this.open,
  });

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
        date: json['date'],
        symbol: json['symbol'],
        close: json['rates']['close'],
        open: json['rates']['open'],
      );
}
