import '../../domain/repositories/invoices_repository.dart';
import '../data_sources/invoices_remote_data_source.dart';
import '../models/invoice.dart';

class InvoicesRepositoryImpl implements InvoicesRepository {
  final InvoicesRemoteDataSource _remoteDataSource;

  InvoicesRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<PatientInvoice>> getInvoices() async {
    final response = await _remoteDataSource.getInvoices();
    return response.invoices;
  }

  @override
  Future<String?> generateInvoicePdf(int id) {
    return _remoteDataSource.generateInvoicePdf(id);
  }
}
