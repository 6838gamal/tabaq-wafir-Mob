// ─── Inventory Item ───────────────────────────────────────────────────────────

enum StockStatus { ok, low, critical, out }

class InventoryItem {
  final String id;
  final String restaurantId;
  final String? branchId;
  final String name;
  final String? nameAr;
  final String? sku;
  final String? category;
  final String unit;
  final double currentStock;
  final double minStock;
  final double? maxStock;
  final double reorderPoint;
  final double costPerUnit;
  final double stockValue;
  final bool expiryTracking;
  final bool isActive;
  final StockStatus stockStatus;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InventoryItem({
    required this.id,
    required this.restaurantId,
    this.branchId,
    required this.name,
    this.nameAr,
    this.sku,
    this.category,
    required this.unit,
    required this.currentStock,
    required this.minStock,
    this.maxStock,
    required this.reorderPoint,
    required this.costPerUnit,
    required this.stockValue,
    required this.expiryTracking,
    required this.isActive,
    required this.stockStatus,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
        id: json['id'],
        restaurantId: json['restaurant_id'],
        branchId: json['branch_id'],
        name: json['name'],
        nameAr: json['name_ar'],
        sku: json['sku'],
        category: json['category'],
        unit: json['unit'],
        currentStock: (json['current_stock'] as num).toDouble(),
        minStock: (json['min_stock'] as num).toDouble(),
        maxStock: (json['max_stock'] as num?)?.toDouble(),
        reorderPoint: (json['reorder_point'] as num).toDouble(),
        costPerUnit: (json['cost_per_unit'] as num).toDouble(),
        stockValue: (json['stock_value'] as num).toDouble(),
        expiryTracking: json['expiry_tracking'] ?? false,
        isActive: json['is_active'] ?? true,
        stockStatus: _parseStatus(json['stock_status']),
        notes: json['notes'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  static StockStatus _parseStatus(String? s) {
    switch (s) {
      case 'out': return StockStatus.out;
      case 'critical': return StockStatus.critical;
      case 'low': return StockStatus.low;
      default: return StockStatus.ok;
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'name_ar': nameAr,
        'sku': sku,
        'category': category,
        'unit': unit,
        'current_stock': currentStock,
        'min_stock': minStock,
        'max_stock': maxStock,
        'reorder_point': reorderPoint,
        'cost_per_unit': costPerUnit,
        'expiry_tracking': expiryTracking,
        'notes': notes,
        'branch_id': branchId,
      };
}

// ─── Stock Movement ──────────────────────────────────────────────────────────

class StockMovement {
  final String id;
  final String itemId;
  final String? itemName;
  final String movementType;
  final double quantity;
  final double unitCost;
  final String? referenceId;
  final String? notes;
  final DateTime createdAt;

  const StockMovement({
    required this.id,
    required this.itemId,
    this.itemName,
    required this.movementType,
    required this.quantity,
    required this.unitCost,
    this.referenceId,
    this.notes,
    required this.createdAt,
  });

  factory StockMovement.fromJson(Map<String, dynamic> json) => StockMovement(
        id: json['id'],
        itemId: json['item_id'],
        itemName: json['item_name'],
        movementType: json['movement_type'],
        quantity: (json['quantity'] as num).toDouble(),
        unitCost: (json['unit_cost'] as num).toDouble(),
        referenceId: json['reference_id'],
        notes: json['notes'],
        createdAt: DateTime.parse(json['created_at']),
      );
}

// ─── Inventory Batch (Expiry) ────────────────────────────────────────────────

enum ExpiryStatus { ok, warning, urgent, expired }

class InventoryBatch {
  final String id;
  final String itemId;
  final String? itemName;
  final double quantity;
  final String? batchNumber;
  final DateTime? expiryDate;
  final double costPerUnit;
  final int? daysUntilExpiry;
  final ExpiryStatus expiryStatus;
  final DateTime createdAt;

  const InventoryBatch({
    required this.id,
    required this.itemId,
    this.itemName,
    required this.quantity,
    this.batchNumber,
    this.expiryDate,
    required this.costPerUnit,
    this.daysUntilExpiry,
    required this.expiryStatus,
    required this.createdAt,
  });

  factory InventoryBatch.fromJson(Map<String, dynamic> json) => InventoryBatch(
        id: json['id'],
        itemId: json['item_id'],
        itemName: json['item_name'],
        quantity: (json['quantity'] as num).toDouble(),
        batchNumber: json['batch_number'],
        expiryDate: json['expiry_date'] != null ? DateTime.parse(json['expiry_date']) : null,
        costPerUnit: (json['cost_per_unit'] as num).toDouble(),
        daysUntilExpiry: json['days_until_expiry'],
        expiryStatus: _parseExpiry(json['expiry_status']),
        createdAt: DateTime.parse(json['created_at']),
      );

  static ExpiryStatus _parseExpiry(String? s) {
    switch (s) {
      case 'expired': return ExpiryStatus.expired;
      case 'urgent': return ExpiryStatus.urgent;
      case 'warning': return ExpiryStatus.warning;
      default: return ExpiryStatus.ok;
    }
  }
}

// ─── Supplier ────────────────────────────────────────────────────────────────

class Supplier {
  final String id;
  final String restaurantId;
  final String name;
  final String? contactName;
  final String? phone;
  final String? email;
  final String? address;
  final String? city;
  final String? category;
  final String? paymentTerms;
  final String? notes;
  final bool isActive;
  final double totalPurchases;
  final DateTime? lastPurchaseDate;
  final DateTime createdAt;

  const Supplier({
    required this.id,
    required this.restaurantId,
    required this.name,
    this.contactName,
    this.phone,
    this.email,
    this.address,
    this.city,
    this.category,
    this.paymentTerms,
    this.notes,
    required this.isActive,
    required this.totalPurchases,
    this.lastPurchaseDate,
    required this.createdAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        id: json['id'],
        restaurantId: json['restaurant_id'],
        name: json['name'],
        contactName: json['contact_name'],
        phone: json['phone'],
        email: json['email'],
        address: json['address'],
        city: json['city'],
        category: json['category'],
        paymentTerms: json['payment_terms'],
        notes: json['notes'],
        isActive: json['is_active'] ?? true,
        totalPurchases: (json['total_purchases'] as num?)?.toDouble() ?? 0,
        lastPurchaseDate: json['last_purchase_date'] != null
            ? DateTime.parse(json['last_purchase_date'])
            : null,
        createdAt: DateTime.parse(json['created_at']),
      );
}

// ─── Purchase ────────────────────────────────────────────────────────────────

class PurchaseItem {
  final String id;
  final String itemId;
  final String? itemName;
  final String? itemUnit;
  final double orderedQty;
  final double receivedQty;
  final double unitCost;
  final double totalCost;
  final DateTime? expiryDate;
  final String? batchNumber;

  const PurchaseItem({
    required this.id,
    required this.itemId,
    this.itemName,
    this.itemUnit,
    required this.orderedQty,
    required this.receivedQty,
    required this.unitCost,
    required this.totalCost,
    this.expiryDate,
    this.batchNumber,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) => PurchaseItem(
        id: json['id'],
        itemId: json['item_id'],
        itemName: json['item_name'],
        itemUnit: json['item_unit'],
        orderedQty: (json['ordered_qty'] as num).toDouble(),
        receivedQty: (json['received_qty'] as num).toDouble(),
        unitCost: (json['unit_cost'] as num).toDouble(),
        totalCost: (json['total_cost'] as num).toDouble(),
        expiryDate: json['expiry_date'] != null ? DateTime.parse(json['expiry_date']) : null,
        batchNumber: json['batch_number'],
      );
}

class Purchase {
  final String id;
  final String restaurantId;
  final String? branchId;
  final String? supplierId;
  final String? supplierName;
  final String? poNumber;
  final String status;
  final double totalAmount;
  final double paidAmount;
  final String paymentStatus;
  final String? invoiceNumber;
  final DateTime? expectedAt;
  final DateTime? receivedAt;
  final String? notes;
  final List<PurchaseItem> items;
  final DateTime createdAt;

  const Purchase({
    required this.id,
    required this.restaurantId,
    this.branchId,
    this.supplierId,
    this.supplierName,
    this.poNumber,
    required this.status,
    required this.totalAmount,
    required this.paidAmount,
    required this.paymentStatus,
    this.invoiceNumber,
    this.expectedAt,
    this.receivedAt,
    this.notes,
    required this.items,
    required this.createdAt,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
        id: json['id'],
        restaurantId: json['restaurant_id'],
        branchId: json['branch_id'],
        supplierId: json['supplier_id'],
        supplierName: json['supplier_name'],
        poNumber: json['po_number'],
        status: json['status'],
        totalAmount: (json['total_amount'] as num).toDouble(),
        paidAmount: (json['paid_amount'] as num).toDouble(),
        paymentStatus: json['payment_status'],
        invoiceNumber: json['invoice_number'],
        expectedAt: json['expected_at'] != null ? DateTime.parse(json['expected_at']) : null,
        receivedAt: json['received_at'] != null ? DateTime.parse(json['received_at']) : null,
        notes: json['notes'],
        items: (json['items'] as List?)?.map((e) => PurchaseItem.fromJson(e)).toList() ?? [],
        createdAt: DateTime.parse(json['created_at']),
      );
}

// ─── Recipe ──────────────────────────────────────────────────────────────────

class RecipeIngredient {
  final String id;
  final String itemId;
  final String? itemName;
  final String? itemUnit;
  final double quantity;
  final String unit;
  final double cost;

  const RecipeIngredient({
    required this.id,
    required this.itemId,
    this.itemName,
    this.itemUnit,
    required this.quantity,
    required this.unit,
    required this.cost,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) => RecipeIngredient(
        id: json['id'],
        itemId: json['item_id'],
        itemName: json['item_name'],
        itemUnit: json['item_unit'],
        quantity: (json['quantity'] as num).toDouble(),
        unit: json['unit'],
        cost: (json['cost'] as num).toDouble(),
      );
}

class Recipe {
  final String id;
  final String restaurantId;
  final String name;
  final String? nameAr;
  final String? productId;
  final String? category;
  final int servingSize;
  final int? preparationTime;
  final double totalCost;
  final double costPerServing;
  final String? notes;
  final bool isActive;
  final List<RecipeIngredient> ingredients;
  final DateTime createdAt;

  const Recipe({
    required this.id,
    required this.restaurantId,
    required this.name,
    this.nameAr,
    this.productId,
    this.category,
    required this.servingSize,
    this.preparationTime,
    required this.totalCost,
    required this.costPerServing,
    this.notes,
    required this.isActive,
    required this.ingredients,
    required this.createdAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'],
        restaurantId: json['restaurant_id'],
        name: json['name'],
        nameAr: json['name_ar'],
        productId: json['product_id'],
        category: json['category'],
        servingSize: json['serving_size'] ?? 1,
        preparationTime: json['preparation_time'],
        totalCost: (json['total_cost'] as num).toDouble(),
        costPerServing: (json['cost_per_serving'] as num).toDouble(),
        notes: json['notes'],
        isActive: json['is_active'] ?? true,
        ingredients: (json['ingredients'] as List?)
                ?.map((e) => RecipeIngredient.fromJson(e))
                .toList() ??
            [],
        createdAt: DateTime.parse(json['created_at']),
      );
}
