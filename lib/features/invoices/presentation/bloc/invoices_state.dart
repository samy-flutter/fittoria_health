import '../../data/models/invoice.dart';

abstract class InvoicesState {
  const InvoicesState();
}

class InvoicesInitial extends InvoicesState {
  const InvoicesInitial();
}

class InvoicesLoading extends InvoicesState {
  const InvoicesLoading();
}

class InvoicesLoaded extends InvoicesState {
  final List<PatientInvoice> invoices;
  final int? pdfLoadingId;
  final String? successMessage;
  final String? errorMessage;

  const InvoicesLoaded({
    required this.invoices,
    this.pdfLoadingId,
    this.successMessage,
    this.errorMessage,
  });

  InvoicesLoaded copyWith({
    List<PatientInvoice>? invoices,
    int? pdfLoadingId,
    bool clearPdfLoading = false,
    String? successMessage,
    bool clearSuccessMessage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return InvoicesLoaded(
      invoices: invoices ?? this.invoices,
      pdfLoadingId: clearPdfLoading ? null : (pdfLoadingId ?? this.pdfLoadingId),
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class InvoicesError extends InvoicesState {
  final String message;
  const InvoicesError(this.message);
}
