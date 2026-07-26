from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime, date


# ─── Inventory Item ──────────────────────────────────────────────────────────

class InventoryItemCreate(BaseModel):
    name: str
    name_ar: Optional[str] = None
    sku: Optional[str] = None
    category: Optional[str] = None
    unit: str
    current_stock: float = 0
    min_stock: float = 0
    max_stock: Optional[float] = None
    reorder_point: float = 0
    cost_per_unit: float = 0
    expiry_tracking: bool = False
    notes: Optional[str] = None
    branch_id: Optional[str] = None


class InventoryItemUpdate(BaseModel):
    name: Optional[str] = None
    name_ar: Optional[str] = None
    category: Optional[str] = None
    unit: Optional[str] = None
    min_stock: Optional[float] = None
    max_stock: Optional[float] = None
    reorder_point: Optional[float] = None
    cost_per_unit: Optional[float] = None
    expiry_tracking: Optional[bool] = None
    notes: Optional[str] = None
    is_active: Optional[bool] = None


class StockAdjustRequest(BaseModel):
    quantity: float  # positive = add, negative = remove
    movement_type: str = "adjustment"
    notes: Optional[str] = None
    batch_number: Optional[str] = None
    expiry_date: Optional[date] = None


class InventoryItemOut(BaseModel):
    id: str
    restaurant_id: str
    branch_id: Optional[str] = None
    name: str
    name_ar: Optional[str] = None
    sku: Optional[str] = None
    category: Optional[str] = None
    unit: str
    current_stock: float
    min_stock: float
    max_stock: Optional[float] = None
    reorder_point: float
    cost_per_unit: float
    stock_value: float = 0
    expiry_tracking: bool
    is_active: bool
    stock_status: str = "ok"  # ok, low, critical, out
    notes: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}

    @classmethod
    def from_db(cls, item):
        obj = cls.model_validate(item)
        obj.stock_value = round(float(item.current_stock) * float(item.cost_per_unit), 2)
        stock = float(item.current_stock)
        min_s = float(item.min_stock)
        if stock <= 0:
            obj.stock_status = "out"
        elif stock <= min_s * 0.5:
            obj.stock_status = "critical"
        elif stock <= min_s:
            obj.stock_status = "low"
        else:
            obj.stock_status = "ok"
        return obj


# ─── Stock Movement ───────────────────────────────────────────────────────────

class StockMovementOut(BaseModel):
    id: str
    item_id: str
    item_name: Optional[str] = None
    movement_type: str
    quantity: float
    unit_cost: float
    reference_id: Optional[str] = None
    notes: Optional[str] = None
    created_at: datetime

    model_config = {"from_attributes": True}


# ─── Inventory Batch (Expiry) ─────────────────────────────────────────────────

class BatchCreate(BaseModel):
    item_id: str
    quantity: float
    batch_number: Optional[str] = None
    expiry_date: Optional[date] = None
    cost_per_unit: float = 0
    notes: Optional[str] = None


class BatchOut(BaseModel):
    id: str
    item_id: str
    item_name: Optional[str] = None
    quantity: float
    batch_number: Optional[str] = None
    expiry_date: Optional[date] = None
    cost_per_unit: float
    days_until_expiry: Optional[int] = None
    expiry_status: str = "ok"  # ok, warning, urgent, expired
    created_at: datetime

    model_config = {"from_attributes": True}


# ─── Supplier ─────────────────────────────────────────────────────────────────

class SupplierCreate(BaseModel):
    name: str
    contact_name: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    category: Optional[str] = None
    payment_terms: Optional[str] = None
    notes: Optional[str] = None


class SupplierUpdate(BaseModel):
    name: Optional[str] = None
    contact_name: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    category: Optional[str] = None
    payment_terms: Optional[str] = None
    notes: Optional[str] = None
    is_active: Optional[bool] = None


class SupplierOut(BaseModel):
    id: str
    restaurant_id: str
    name: str
    contact_name: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    category: Optional[str] = None
    payment_terms: Optional[str] = None
    notes: Optional[str] = None
    is_active: bool
    total_purchases: float = 0
    last_purchase_date: Optional[date] = None
    created_at: datetime

    model_config = {"from_attributes": True}


# ─── Purchase ────────────────────────────────────────────────────────────────

class PurchaseItemCreate(BaseModel):
    item_id: str
    ordered_qty: float
    unit_cost: float
    expiry_date: Optional[date] = None
    batch_number: Optional[str] = None
    notes: Optional[str] = None


class PurchaseCreate(BaseModel):
    supplier_id: Optional[str] = None
    branch_id: Optional[str] = None
    expected_at: Optional[date] = None
    notes: Optional[str] = None
    items: List[PurchaseItemCreate]


class PurchaseReceiveItem(BaseModel):
    purchase_item_id: str
    received_qty: float
    expiry_date: Optional[date] = None
    batch_number: Optional[str] = None


class PurchaseReceiveRequest(BaseModel):
    items: List[PurchaseReceiveItem]
    notes: Optional[str] = None


class PurchaseItemOut(BaseModel):
    id: str
    item_id: str
    item_name: Optional[str] = None
    item_unit: Optional[str] = None
    ordered_qty: float
    received_qty: float
    unit_cost: float
    total_cost: float = 0
    expiry_date: Optional[date] = None
    batch_number: Optional[str] = None

    model_config = {"from_attributes": True}


class PurchaseOut(BaseModel):
    id: str
    restaurant_id: str
    branch_id: Optional[str] = None
    supplier_id: Optional[str] = None
    supplier_name: Optional[str] = None
    po_number: Optional[str] = None
    status: str
    total_amount: float
    paid_amount: float
    payment_status: str
    invoice_number: Optional[str] = None
    expected_at: Optional[date] = None
    received_at: Optional[datetime] = None
    notes: Optional[str] = None
    items: List[PurchaseItemOut] = []
    created_at: datetime

    model_config = {"from_attributes": True}


# ─── Recipe ──────────────────────────────────────────────────────────────────

class RecipeIngredientCreate(BaseModel):
    item_id: str
    quantity: float
    unit: str
    notes: Optional[str] = None


class RecipeCreate(BaseModel):
    name: str
    name_ar: Optional[str] = None
    product_id: Optional[str] = None
    category: Optional[str] = None
    serving_size: int = 1
    preparation_time: Optional[int] = None
    notes: Optional[str] = None
    ingredients: List[RecipeIngredientCreate]


class RecipeIngredientOut(BaseModel):
    id: str
    item_id: str
    item_name: Optional[str] = None
    item_unit: Optional[str] = None
    quantity: float
    unit: str
    cost: float = 0

    model_config = {"from_attributes": True}


class RecipeOut(BaseModel):
    id: str
    restaurant_id: str
    name: str
    name_ar: Optional[str] = None
    product_id: Optional[str] = None
    category: Optional[str] = None
    serving_size: int
    preparation_time: Optional[int] = None
    total_cost: float = 0
    cost_per_serving: float = 0
    notes: Optional[str] = None
    is_active: bool
    ingredients: List[RecipeIngredientOut] = []
    created_at: datetime

    model_config = {"from_attributes": True}


# ─── Stock Count ──────────────────────────────────────────────────────────────

class StockCountItem(BaseModel):
    item_id: str
    actual_qty: float
    notes: Optional[str] = None


class StockCountRequest(BaseModel):
    branch_id: Optional[str] = None
    items: List[StockCountItem]
    notes: Optional[str] = None


class StockCountResult(BaseModel):
    item_id: str
    item_name: str
    unit: str
    expected_qty: float
    actual_qty: float
    difference: float
    cost_impact: float


# ─── Transfer ────────────────────────────────────────────────────────────────

class TransferItemCreate(BaseModel):
    item_id: str
    quantity: float
    notes: Optional[str] = None


class TransferCreate(BaseModel):
    from_branch_id: str
    to_branch_id: str
    items: List[TransferItemCreate]
    notes: Optional[str] = None


class TransferOut(BaseModel):
    id: str
    from_branch_id: str
    to_branch_id: str
    status: str
    items: List[dict]
    notes: Optional[str] = None
    created_at: datetime

    model_config = {"from_attributes": True}


# ─── Dashboard ───────────────────────────────────────────────────────────────

class InventoryDashboard(BaseModel):
    total_items: int
    total_categories: int
    low_stock_count: int
    out_of_stock_count: int
    expiring_soon_count: int
    total_stock_value: float
    low_stock_items: List[InventoryItemOut]
    expiring_soon: List[BatchOut]
    recent_movements: List[StockMovementOut]
