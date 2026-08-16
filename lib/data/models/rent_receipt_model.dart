enum ReceiptPaymentStatus { paid, pending, failed }

class RentReceiptModel {
  final String invoiceId;
  final String monthYear;
  final String pgName;
  final double amount;
  final double electricityCharges;
  final double maintenanceCharges;
  final String transactionReference;
  final DateTime paidDate;
  final ReceiptPaymentStatus status;

  const RentReceiptModel({
    required this.invoiceId,
    required this.monthYear,
    required this.pgName,
    required this.amount,
    this.electricityCharges = 650,
    this.maintenanceCharges = 350,
    required this.transactionReference,
    required this.paidDate,
    required this.status,
  });

  double get totalPaid => amount + electricityCharges + maintenanceCharges;
}
