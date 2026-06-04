import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/repositories/invoices_repository.dart';
import 'invoices_state.dart';

class InvoicesCubit extends Cubit<InvoicesState> {
  final InvoicesRepository _repository;

  InvoicesCubit(this._repository) : super(const InvoicesInitial());

  Future<void> loadInvoices() async {
    emit(const InvoicesLoading());
    try {
      final invoices = await _repository.getInvoices();
      emit(InvoicesLoaded(invoices: invoices));
    } catch (e) {
      emit(InvoicesError(e.toString()));
    }
  }

  Future<void> downloadPdf(int id) async {
    final currentState = state;
    if (currentState is! InvoicesLoaded) return;

    emit(currentState.copyWith(
      pdfLoadingId: id,
      clearSuccessMessage: true,
      clearErrorMessage: true,
    ));

    try {
      final url = await _repository.generateInvoicePdf(id);
      if (url != null && url.isNotEmpty) {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          emit((state as InvoicesLoaded).copyWith(
            clearPdfLoading: true,
            successMessage: 'PDF opened successfully',
          ));
        } else {
          emit((state as InvoicesLoaded).copyWith(
            clearPdfLoading: true,
            errorMessage: 'Could not open PDF URL: $url',
          ));
        }
      } else {
        emit((state as InvoicesLoaded).copyWith(
          clearPdfLoading: true,
          errorMessage: 'PDF generated but no download link was returned.',
        ));
      }
    } catch (e) {
      emit((state as InvoicesLoaded).copyWith(
        clearPdfLoading: true,
        errorMessage: e.toString(),
      ));
    }
  }

  void clearMessages() {
    final currentState = state;
    if (currentState is InvoicesLoaded) {
      emit(currentState.copyWith(
        clearSuccessMessage: true,
        clearErrorMessage: true,
      ));
    }
  }
}
