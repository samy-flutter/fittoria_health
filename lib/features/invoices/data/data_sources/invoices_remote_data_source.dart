import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/invoice.dart';

abstract class InvoicesRemoteDataSource {
  Future<InvoicesResponse> getInvoices();
  Future<String?> generateInvoicePdf(int id);
}

class InvoicesRemoteDataSourceImpl implements InvoicesRemoteDataSource {
  final DioClient _dioClient;

  InvoicesRemoteDataSourceImpl(this._dioClient);

  @override
  Future<InvoicesResponse> getInvoices() async {
    final response = await _dioClient.get(ApiEndpoints.invoices);
    return InvoicesResponse.fromJson(response.data);
  }

  @override
  Future<String?> generateInvoicePdf(int id) async {
    final response = await _dioClient.post(ApiEndpoints.generateInvoicePdf(id));
    final data = response.data?['data'] ?? response.data;
    if (data != null && data is Map) {
      return data['url'] as String?;
    }
    return null;
  }
}
