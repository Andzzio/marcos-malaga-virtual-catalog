import os

targets = [
    '/domain/entities/product_entity.dart',
    '/domain/entities/product_design_entity.dart',
    '/domain/entities/product_size_entity.dart',
    '/domain/entities/stock_availability.dart',
    '/domain/repositories/products_repository.dart',
    '/domain/usecases/get_products_usecase.dart',
    '/domain/usecases/get_product_by_id_usecase.dart',
    '/data/datasources/local_products_datasource.dart',
    '/data/repositories/local_products_repository_impl.dart',
    '/presentation/providers/products_provider.dart',
    '/presentation/providers/single_product_provider.dart'
]

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            new_content = content
            for t in targets:
                old = 'features/catalog' + t
                new = 'app/shared' + t
                new_content = new_content.replace(old, new)
                
            if new_content != content:
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                print('Updated:', path)
