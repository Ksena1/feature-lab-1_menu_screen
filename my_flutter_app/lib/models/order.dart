class OrderRequest {
  final Map<String, int> positions;
  final String token;

  OrderRequest({
    required this.positions,
    this.token = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'positions': positions,
      'token': token,
    };
  }
}

class OrderResponse {
  final int orderId;
  final String status;

  OrderResponse({
    required this.orderId,
    required this.status,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orderId: json['order_id'],
      status: json['status'],
    );
  }
}