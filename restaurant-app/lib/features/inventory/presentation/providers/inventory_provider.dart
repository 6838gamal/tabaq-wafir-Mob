import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/inventory_models.dart';

// ─── Mock Data for Demo ───────────────────────────────────────────────────────

final mockInventoryItems = [
  InventoryItem(
    id: '1', restaurantId: 'r1', name: 'Beef Tenderloin', nameAr: 'لحم بقري',
    category: 'Meat', unit: 'kg', currentStock: 12.5, minStock: 5.0,
    reorderPoint: 8.0, costPerUnit: 85.0, stockValue: 1062.5,
    expiryTracking: true, isActive: true, stockStatus: StockStatus.ok,
    createdAt: DateTime.now(), updatedAt: DateTime.now(),
  ),
  InventoryItem(
    id: '2', restaurantId: 'r1', name: 'Fresh Cream', nameAr: 'كريمة طازجة',
    category: 'Dairy', unit: 'L', currentStock: 2.0, minStock: 5.0,
    reorderPoint: 4.0, costPerUnit: 22.0, stockValue: 44.0,
    expiryTracking: true, isActive: true, stockStatus: StockStatus.critical,
    createdAt: DateTime.now(), updatedAt: DateTime.now(),
  ),
  InventoryItem(
    id: '3', restaurantId: 'r1', name: 'Saffron', nameAr: 'زعفران',
    category: 'Spices', unit: 'g', currentStock: 80.0, minStock: 50.0,
    reorderPoint: 70.0, costPerUnit: 4.5, stockValue: 360.0,
    expiryTracking: false, isActive: true, stockStatus: StockStatus.ok,
    createdAt: DateTime.now(), updatedAt: DateTime.now(),
  ),
  InventoryItem(
    id: '4', restaurantId: 'r1', name: 'Roma Tomatoes', nameAr: 'طماطم رومانية',
    category: 'Vegetables', unit: 'kg', currentStock: 0.0, minStock: 10.0,
    reorderPoint: 8.0, costPerUnit: 6.0, stockValue: 0,
    expiryTracking: true, isActive: true, stockStatus: StockStatus.out,
    createdAt: DateTime.now(), updatedAt: DateTime.now(),
  ),
  InventoryItem(
    id: '5', restaurantId: 'r1', name: 'Basmati Rice', nameAr: 'أرز بسمتي',
    category: 'Dry Goods', unit: 'kg', currentStock: 45.0, minStock: 20.0,
    reorderPoint: 25.0, costPerUnit: 8.5, stockValue: 382.5,
    expiryTracking: false, isActive: true, stockStatus: StockStatus.ok,
    createdAt: DateTime.now(), updatedAt: DateTime.now(),
  ),
  InventoryItem(
    id: '6', restaurantId: 'r1', name: 'Olive Oil', nameAr: 'زيت زيتون',
    category: 'Oils', unit: 'L', currentStock: 3.5, minStock: 8.0,
    reorderPoint: 6.0, costPerUnit: 35.0, stockValue: 122.5,
    expiryTracking: false, isActive: true, stockStatus: StockStatus.low,
    createdAt: DateTime.now(), updatedAt: DateTime.now(),
  ),
  InventoryItem(
    id: '7', restaurantId: 'r1', name: 'Chicken Breast', nameAr: 'صدر دجاج',
    category: 'Meat', unit: 'kg', currentStock: 18.0, minStock: 10.0,
    reorderPoint: 12.0, costPerUnit: 32.0, stockValue: 576.0,
    expiryTracking: true, isActive: true, stockStatus: StockStatus.ok,
    createdAt: DateTime.now(), updatedAt: DateTime.now(),
  ),
  InventoryItem(
    id: '8', restaurantId: 'r1', name: 'Butter', nameAr: 'زبدة',
    category: 'Dairy', unit: 'kg', currentStock: 4.2, minStock: 5.0,
    reorderPoint: 4.0, costPerUnit: 28.0, stockValue: 117.6,
    expiryTracking: true, isActive: true, stockStatus: StockStatus.low,
    createdAt: DateTime.now(), updatedAt: DateTime.now(),
  ),
];

final mockSuppliers = [
  Supplier(
    id: 's1', restaurantId: 'r1', name: 'Al-Nakheel Foods', contactName: 'Ahmed Al-Rashid',
    phone: '+966 50 123 4567', email: 'ahmed@alnakheel.com',
    city: 'Riyadh', category: 'Meat & Poultry', paymentTerms: 'Net 30',
    isActive: true, totalPurchases: 45600.0, lastPurchaseDate: DateTime.now().subtract(const Duration(days: 3)),
    createdAt: DateTime.now().subtract(const Duration(days: 180)),
  ),
  Supplier(
    id: 's2', restaurantId: 'r1', name: 'Fresh Valley Farms', contactName: 'Sara Al-Otaibi',
    phone: '+966 55 987 6543', email: 'sara@freshvalley.sa',
    city: 'Jeddah', category: 'Vegetables & Fruits', paymentTerms: 'Net 15',
    isActive: true, totalPurchases: 23400.0, lastPurchaseDate: DateTime.now().subtract(const Duration(days: 1)),
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
  ),
  Supplier(
    id: 's3', restaurantId: 'r1', name: 'Gulf Dairy Co.', contactName: 'Mohammed Al-Ghamdi',
    phone: '+966 54 456 7890', email: 'info@gulfdairy.com',
    city: 'Dammam', category: 'Dairy & Eggs', paymentTerms: 'Net 7',
    isActive: true, totalPurchases: 18750.0, lastPurchaseDate: DateTime.now().subtract(const Duration(days: 5)),
    createdAt: DateTime.now().subtract(const Duration(days: 120)),
  ),
];

final mockRecipes = [
  Recipe(
    id: 'rec1', restaurantId: 'r1', name: 'Beef Kabsa', nameAr: 'كبسة لحم',
    category: 'Main Course', servingSize: 4, preparationTime: 90,
    totalCost: 182.0, costPerServing: 45.5, isActive: true,
    ingredients: [
      RecipeIngredient(id: 'ri1', itemId: '1', itemName: 'Beef Tenderloin', itemUnit: 'kg', quantity: 1.5, unit: 'kg', cost: 127.5),
      RecipeIngredient(id: 'ri2', itemId: '5', itemName: 'Basmati Rice', itemUnit: 'kg', quantity: 2.0, unit: 'kg', cost: 17.0),
      RecipeIngredient(id: 'ri3', itemId: '3', itemName: 'Saffron', itemUnit: 'g', quantity: 2.0, unit: 'g', cost: 9.0),
      RecipeIngredient(id: 'ri4', itemId: '6', itemName: 'Olive Oil', itemUnit: 'L', quantity: 0.1, unit: 'L', cost: 3.5),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  ),
  Recipe(
    id: 'rec2', restaurantId: 'r1', name: 'Cream Chicken', nameAr: 'دجاج بالكريمة',
    category: 'Main Course', servingSize: 2, preparationTime: 35,
    totalCost: 88.0, costPerServing: 44.0, isActive: true,
    ingredients: [
      RecipeIngredient(id: 'ri5', itemId: '7', itemName: 'Chicken Breast', itemUnit: 'kg', quantity: 0.8, unit: 'kg', cost: 25.6),
      RecipeIngredient(id: 'ri6', itemId: '2', itemName: 'Fresh Cream', itemUnit: 'L', quantity: 0.3, unit: 'L', cost: 6.6),
      RecipeIngredient(id: 'ri7', itemId: '8', itemName: 'Butter', itemUnit: 'kg', quantity: 0.05, unit: 'kg', cost: 1.4),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
  ),
];

final mockPurchases = [
  Purchase(
    id: 'po1', restaurantId: 'r1', supplierId: 's1', supplierName: 'Al-Nakheel Foods',
    poNumber: 'PO-202406-0023', status: 'received', totalAmount: 4250.0,
    paidAmount: 4250.0, paymentStatus: 'paid',
    items: [
      PurchaseItem(id: 'pi1', itemId: '1', itemName: 'Beef Tenderloin', itemUnit: 'kg', orderedQty: 50.0, receivedQty: 50.0, unitCost: 85.0, totalCost: 4250.0),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Purchase(
    id: 'po2', restaurantId: 'r1', supplierId: 's2', supplierName: 'Fresh Valley Farms',
    poNumber: 'PO-202406-0024', status: 'ordered', totalAmount: 680.0,
    paidAmount: 0.0, paymentStatus: 'unpaid',
    items: [
      PurchaseItem(id: 'pi2', itemId: '4', itemName: 'Roma Tomatoes', itemUnit: 'kg', orderedQty: 30.0, receivedQty: 0.0, unitCost: 6.0, totalCost: 180.0),
      PurchaseItem(id: 'pi3', itemId: '6', itemName: 'Olive Oil', itemUnit: 'L', orderedQty: 10.0, receivedQty: 0.0, unitCost: 35.0, totalCost: 350.0),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
];

final mockBatches = [
  InventoryBatch(
    id: 'b1', itemId: '2', itemName: 'Fresh Cream',
    quantity: 5.0, batchNumber: 'BC-2024-001',
    expiryDate: DateTime.now().add(const Duration(days: 2)),
    costPerUnit: 22.0, daysUntilExpiry: 2, expiryStatus: ExpiryStatus.urgent,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  InventoryBatch(
    id: 'b2', itemId: '8', itemName: 'Butter',
    quantity: 4.2, batchNumber: 'BC-2024-002',
    expiryDate: DateTime.now().add(const Duration(days: 6)),
    costPerUnit: 28.0, daysUntilExpiry: 6, expiryStatus: ExpiryStatus.warning,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  InventoryBatch(
    id: 'b3', itemId: '1', itemName: 'Beef Tenderloin',
    quantity: 12.5, batchNumber: 'BC-2024-003',
    expiryDate: DateTime.now().add(const Duration(days: 15)),
    costPerUnit: 85.0, daysUntilExpiry: 15, expiryStatus: ExpiryStatus.ok,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  InventoryBatch(
    id: 'b4', itemId: '7', itemName: 'Chicken Breast',
    quantity: 0.0, batchNumber: 'BC-2024-000',
    expiryDate: DateTime.now().subtract(const Duration(days: 1)),
    costPerUnit: 32.0, daysUntilExpiry: -1, expiryStatus: ExpiryStatus.expired,
    createdAt: DateTime.now().subtract(const Duration(days: 8)),
  ),
];

// ─── Providers ────────────────────────────────────────────────────────────────

final inventoryItemsProvider = StateProvider<List<InventoryItem>>((ref) => mockInventoryItems);
final suppliersProvider = StateProvider<List<Supplier>>((ref) => mockSuppliers);
final purchasesProvider = StateProvider<List<Purchase>>((ref) => mockPurchases);
final recipesProvider = StateProvider<List<Recipe>>((ref) => mockRecipes);
final inventoryBatchesProvider = StateProvider<List<InventoryBatch>>((ref) => mockBatches);

final inventorySearchProvider = StateProvider<String>((ref) => '');
final inventoryCategoryFilterProvider = StateProvider<String?>((ref) => null);
final inventoryStatusFilterProvider = StateProvider<String?>((ref) => null);

final filteredInventoryProvider = Provider<List<InventoryItem>>((ref) {
  final items = ref.watch(inventoryItemsProvider);
  final search = ref.watch(inventorySearchProvider).toLowerCase();
  final category = ref.watch(inventoryCategoryFilterProvider);
  final status = ref.watch(inventoryStatusFilterProvider);

  return items.where((item) {
    if (search.isNotEmpty && !item.name.toLowerCase().contains(search)) return false;
    if (category != null && item.category != category) return false;
    if (status != null) {
      switch (status) {
        case 'low': return item.stockStatus == StockStatus.low || item.stockStatus == StockStatus.critical;
        case 'out': return item.stockStatus == StockStatus.out;
        case 'ok': return item.stockStatus == StockStatus.ok;
      }
    }
    return true;
  }).toList();
});

final inventoryDashboardProvider = Provider((ref) {
  final items = ref.watch(inventoryItemsProvider);
  final batches = ref.watch(inventoryBatchesProvider);

  final lowStock = items.where((i) => i.stockStatus == StockStatus.low || i.stockStatus == StockStatus.critical).toList();
  final outStock = items.where((i) => i.stockStatus == StockStatus.out).toList();
  final expiringBatches = batches.where((b) => b.expiryStatus != ExpiryStatus.ok).toList();
  final totalValue = items.fold(0.0, (sum, i) => sum + i.stockValue);
  final categories = items.map((i) => i.category).whereType<String>().toSet();

  return {
    'total_items': items.length,
    'total_categories': categories.length,
    'low_stock_count': lowStock.length,
    'out_of_stock_count': outStock.length,
    'expiring_soon_count': expiringBatches.length,
    'total_stock_value': totalValue,
    'low_stock_items': lowStock,
    'expiring_soon': expiringBatches,
  };
});
