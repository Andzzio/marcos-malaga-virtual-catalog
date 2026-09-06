import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';

class GetProductSizeByNameUseCase {
  final ProductsRepository repo;

  GetProductSizeByNameUseCase({required this.repo});

  Future<ProductSizeEntity?> call(
    String productId,
    String designId,
    String sizeName,
  ) {
    return repo.getSizeByName(productId, designId, sizeName);
  }
}
