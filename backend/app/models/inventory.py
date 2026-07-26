import uuid
from datetime import datetime, timezone, date
from sqlalchemy import String, Boolean, DateTime, Text, Numeric, ForeignKey, Integer, Date, SmallInteger
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID, JSONB
from app.core.database import Base


class InventoryItem(Base):
    """Raw materials / ingredients."""
    __tablename__ = "inventory_items"

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid.uuid4()))
    restaurant_id: Mapped[str] = mapped_column(String(36), index=True, nullable=False)
    branch_id: Mapped[str | None] = mapped_column(String(36), index=True)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    name_ar: Mapped[str | None] = mapped_column(String(255))
    sku: Mapped[str | None] = mapped_column(String(100), index=True)
    category: Mapped[str | None] = mapped_column(String(100), index=True)
    unit: Mapped[str] = mapped_column(String(30), nullable=False)  # kg, g, L, pcs, etc.
    current_stock: Mapped[float] = mapped_column(Numeric(12, 3), default=0)
    min_stock: Mapped[float] = mapped_column(Numeric(12, 3), default=0)
    max_stock: Mapped[float | None] = mapped_column(Numeric(12, 3))
    reorder_point: Mapped[float] = mapped_column(Numeric(12, 3), default=0)
    cost_per_unit: Mapped[float] = mapped_column(Numeric(10, 4), default=0)
    expiry_tracking: Mapped[bool] = mapped_column(Boolean, default=False)
    image_url: Mapped[str | None] = mapped_column(Text)
    notes: Mapped[str | None] = mapped_column(Text)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

    batches: Mapped[list["InventoryBatch"]] = relationship("InventoryBatch", back_populates="item", lazy="select")
    movements: Mapped[list["StockMovement"]] = relationship("StockMovement", back_populates="item", lazy="select")


class InventoryBatch(Base):
    """Track expiry batches per item."""
    __tablename__ = "inventory_batches"

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid.uuid4()))
    item_id: Mapped[str] = mapped_column(String(36), ForeignKey("inventory_items.id"), nullable=False, index=True)
    branch_id: Mapped[str | None] = mapped_column(String(36))
    quantity: Mapped[float] = mapped_column(Numeric(12, 3), nullable=False)
    batch_number: Mapped[str | None] = mapped_column(String(100))
    expiry_date: Mapped[date | None] = mapped_column(Date)
    cost_per_unit: Mapped[float] = mapped_column(Numeric(10, 4), default=0)
    supplier_id: Mapped[str | None] = mapped_column(String(36))
    notes: Mapped[str | None] = mapped_column(Text)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

    item: Mapped["InventoryItem"] = relationship("InventoryItem", back_populates="batches")


class StockMovement(Base):
    """Every stock in/out is recorded here."""
    __tablename__ = "stock_movements"

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid.uuid4()))
    item_id: Mapped[str] = mapped_column(String(36), ForeignKey("inventory_items.id"), nullable=False, index=True)
    restaurant_id: Mapped[str] = mapped_column(String(36), index=True, nullable=False)
    branch_id: Mapped[str | None] = mapped_column(String(36))
    movement_type: Mapped[str] = mapped_column(String(30), nullable=False)
    # Types: purchase, sale, waste, transfer_out, transfer_in, adjustment, count, expiry_write_off
    quantity: Mapped[float] = mapped_column(Numeric(12, 3), nullable=False)
    unit_cost: Mapped[float] = mapped_column(Numeric(10, 4), default=0)
    reference_id: Mapped[str | None] = mapped_column(String(36))  # order_id / purchase_id / transfer_id
    reference_type: Mapped[str | None] = mapped_column(String(30))
    notes: Mapped[str | None] = mapped_column(Text)
    performed_by: Mapped[str | None] = mapped_column(String(36))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

    item: Mapped["InventoryItem"] = relationship("InventoryItem", back_populates="movements")


class Supplier(Base):
    __tablename__ = "suppliers"

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid.uuid4()))
    restaurant_id: Mapped[str] = mapped_column(String(36), index=True, nullable=False)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    contact_name: Mapped[str | None] = mapped_column(String(255))
    phone: Mapped[str | None] = mapped_column(String(30))
    email: Mapped[str | None] = mapped_column(String(255))
    address: Mapped[str | None] = mapped_column(Text)
    city: Mapped[str | None] = mapped_column(String(100))
    category: Mapped[str | None] = mapped_column(String(100))
    payment_terms: Mapped[str | None] = mapped_column(String(100))
    notes: Mapped[str | None] = mapped_column(Text)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

    purchases: Mapped[list["Purchase"]] = relationship("Purchase", back_populates="supplier", lazy="select")


class Purchase(Base):
    """Purchase orders from suppliers."""
    __tablename__ = "purchases"

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid.uuid4()))
    restaurant_id: Mapped[str] = mapped_column(String(36), index=True, nullable=False)
    branch_id: Mapped[str | None] = mapped_column(String(36))
    supplier_id: Mapped[str | None] = mapped_column(String(36), ForeignKey("suppliers.id"))
    po_number: Mapped[str | None] = mapped_column(String(50), unique=True)
    status: Mapped[str] = mapped_column(String(20), default="draft")
    # Statuses: draft, ordered, partial, received, cancelled
    total_amount: Mapped[float] = mapped_column(Numeric(12, 2), default=0)
    paid_amount: Mapped[float] = mapped_column(Numeric(12, 2), default=0)
    payment_status: Mapped[str] = mapped_column(String(20), default="unpaid")
    invoice_number: Mapped[str | None] = mapped_column(String(100))
    invoice_url: Mapped[str | None] = mapped_column(Text)
    expected_at: Mapped[date | None] = mapped_column(Date)
    received_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    notes: Mapped[str | None] = mapped_column(Text)
    created_by: Mapped[str | None] = mapped_column(String(36))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

    supplier: Mapped["Supplier | None"] = relationship("Supplier", back_populates="purchases")
    items: Mapped[list["PurchaseItem"]] = relationship("PurchaseItem", back_populates="purchase", cascade="all, delete-orphan")


class PurchaseItem(Base):
    __tablename__ = "purchase_items"

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid.uuid4()))
    purchase_id: Mapped[str] = mapped_column(String(36), ForeignKey("purchases.id"), nullable=False)
    item_id: Mapped[str] = mapped_column(String(36), ForeignKey("inventory_items.id"), nullable=False)
    ordered_qty: Mapped[float] = mapped_column(Numeric(12, 3), nullable=False)
    received_qty: Mapped[float] = mapped_column(Numeric(12, 3), default=0)
    unit_cost: Mapped[float] = mapped_column(Numeric(10, 4), nullable=False)
    expiry_date: Mapped[date | None] = mapped_column(Date)
    batch_number: Mapped[str | None] = mapped_column(String(100))
    notes: Mapped[str | None] = mapped_column(Text)

    purchase: Mapped["Purchase"] = relationship("Purchase", back_populates="items")
    inventory_item: Mapped["InventoryItem"] = relationship("InventoryItem")


class Recipe(Base):
    """Recipe for a menu product."""
    __tablename__ = "recipes"

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid.uuid4()))
    restaurant_id: Mapped[str] = mapped_column(String(36), index=True, nullable=False)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    name_ar: Mapped[str | None] = mapped_column(String(255))
    product_id: Mapped[str | None] = mapped_column(String(36), unique=True)  # linked menu product
    category: Mapped[str | None] = mapped_column(String(100))
    serving_size: Mapped[int] = mapped_column(Integer, default=1)
    preparation_time: Mapped[int | None] = mapped_column(SmallInteger)
    notes: Mapped[str | None] = mapped_column(Text)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

    ingredients: Mapped[list["RecipeIngredient"]] = relationship("RecipeIngredient", back_populates="recipe", cascade="all, delete-orphan")


class RecipeIngredient(Base):
    __tablename__ = "recipe_ingredients"

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid.uuid4()))
    recipe_id: Mapped[str] = mapped_column(String(36), ForeignKey("recipes.id"), nullable=False)
    item_id: Mapped[str] = mapped_column(String(36), ForeignKey("inventory_items.id"), nullable=False)
    quantity: Mapped[float] = mapped_column(Numeric(12, 4), nullable=False)
    unit: Mapped[str] = mapped_column(String(30), nullable=False)
    notes: Mapped[str | None] = mapped_column(Text)

    recipe: Mapped["Recipe"] = relationship("Recipe", back_populates="ingredients")
    inventory_item: Mapped["InventoryItem"] = relationship("InventoryItem")
