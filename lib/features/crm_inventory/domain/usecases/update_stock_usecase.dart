import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';

class UpdateStockUsecase {
  final ProductsRepository repo;
  const UpdateStockUsecase({required this.repo});

  Future<void> call({
    required String productId,
    required String designId,
    required String sizeName,
    required int newStock,
  }) async {
    await repo.updateStock(
      productId: productId,
      designId: designId,
      sizeName: sizeName,
      newStock: newStock,
    );
  }
}
