import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
import 'package:slice_master_pro/data/repositories/pizzas.dart';

import '../../../data/model/invoice.dart';
import '../../../utils/helpers/shared_pref.dart';

part 'archive_state.dart';

class ArchiveCubit extends Cubit<ArchiveState> {
  ArchiveCubit() : super(ArchiveInitial());

  Future<void> fetchInvoices() async {
    try {
      emit(ArchiveLoading());
      final List<InvoiceModel>? invoices = await PizzasRepository.instance
          .getInvoices(CacheData.getData(key: 'currentUser'));
      emit(ArchiveLoaded(list: invoices ?? []));
    } catch (e) {
      emit(ArchiveError(message: e.toString()));
    }
  }
}
