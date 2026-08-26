import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';

class GetProductDesignByIdUseCase {
  final ProductsRepository repo;

  GetProductDesignByIdUseCase({required this.repo});

  Future<ProductDesignEntity?> call(String productId, String designId) {
    return repo.getDesignById(productId, designId);
  }
}
