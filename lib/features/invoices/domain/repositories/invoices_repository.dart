import '../../data/models/invoice.dart';

abstract class InvoicesRepository {
  Future<List<PatientInvoice>> getInvoices();
  Future<String?> generateInvoicePdf(int id);
}
