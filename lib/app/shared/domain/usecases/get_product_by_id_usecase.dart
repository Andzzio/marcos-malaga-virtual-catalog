import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';

class GetProductByIdUsecase {
  final ProductsRepository repo;
  GetProductByIdUsecase({required this.repo});
  Future<ProductEntity?> call(String id) async {
    return await repo.getProductById(id);
  }
}
