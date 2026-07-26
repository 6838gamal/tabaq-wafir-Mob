from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from typing import List, Optional
from datetime import datetime, timezone

from app.core.database import get_db
from app.core.deps import get_current_restaurant_user
from app.models.user import User
from app.models.inventory import Recipe, RecipeIngredient, InventoryItem
from app.schemas.inventory import RecipeCreate, RecipeOut, RecipeIngredientOut

router = APIRouter()


async def _build_recipe_out(recipe: Recipe, db: AsyncSession) -> RecipeOut:
    out = RecipeOut.model_validate(recipe)
    total_cost = 0.0
    ingredient_outs = []

    for ing in recipe.ingredients:
        ir = await db.execute(select(InventoryItem).where(InventoryItem.id == ing.item_id))
        inv = ir.scalar_one_or_none()
        ing_out = RecipeIngredientOut.model_validate(ing)
        if inv:
            ing_out.item_name = inv.name
            ing_out.item_unit = inv.unit
            cost = float(ing.quantity) * float(inv.cost_per_unit)
            ing_out.cost = round(cost, 4)
            total_cost += cost
        ingredient_outs.append(ing_out)

    out.ingredients = ingredient_outs
    out.total_cost = round(total_cost, 4)
    out.cost_per_serving = round(total_cost / max(recipe.serving_size, 1), 4)
    return out


@router.get("", response_model=List[RecipeOut])
async def list_recipes(
    category: Optional[str] = None,
    search: Optional[str] = None,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    q = select(Recipe).where(Recipe.restaurant_id == user.restaurant_id, Recipe.is_active == True)
    if category:
        q = q.where(Recipe.category == category)
    if search:
        q = q.where(Recipe.name.ilike(f"%{search}%"))
    q = q.order_by(Recipe.name)

    result = await db.execute(q)
    recipes = result.scalars().all()
    return [await _build_recipe_out(r, db) for r in recipes]


@router.post("", response_model=RecipeOut, status_code=201)
async def create_recipe(
    body: RecipeCreate,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    recipe = Recipe(
        restaurant_id=user.restaurant_id,
        name=body.name, name_ar=body.name_ar,
        product_id=body.product_id, category=body.category,
        serving_size=body.serving_size,
        preparation_time=body.preparation_time,
        notes=body.notes,
    )
    db.add(recipe)
    await db.flush()

    for ing in body.ingredients:
        db.add(RecipeIngredient(
            recipe_id=recipe.id,
            item_id=ing.item_id,
            quantity=ing.quantity,
            unit=ing.unit,
            notes=ing.notes,
        ))

    await db.flush()
    await db.refresh(recipe)
    return await _build_recipe_out(recipe, db)


@router.get("/{recipe_id}", response_model=RecipeOut)
async def get_recipe(
    recipe_id: str,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Recipe).where(Recipe.id == recipe_id, Recipe.restaurant_id == user.restaurant_id)
    )
    recipe = result.scalar_one_or_none()
    if not recipe:
        raise HTTPException(404, "Recipe not found")
    return await _build_recipe_out(recipe, db)


@router.put("/{recipe_id}", response_model=RecipeOut)
async def update_recipe(
    recipe_id: str,
    body: RecipeCreate,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Recipe).where(Recipe.id == recipe_id, Recipe.restaurant_id == user.restaurant_id)
    )
    recipe = result.scalar_one_or_none()
    if not recipe:
        raise HTTPException(404, "Recipe not found")

    recipe.name = body.name
    recipe.name_ar = body.name_ar
    recipe.product_id = body.product_id
    recipe.category = body.category
    recipe.serving_size = body.serving_size
    recipe.preparation_time = body.preparation_time
    recipe.notes = body.notes
    recipe.updated_at = datetime.now(timezone.utc)

    # Replace ingredients
    for ing in recipe.ingredients:
        await db.delete(ing)
    await db.flush()

    for ing in body.ingredients:
        db.add(RecipeIngredient(
            recipe_id=recipe.id, item_id=ing.item_id,
            quantity=ing.quantity, unit=ing.unit, notes=ing.notes,
        ))

    db.add(recipe)
    await db.flush()
    await db.refresh(recipe)
    return await _build_recipe_out(recipe, db)


@router.delete("/{recipe_id}", status_code=204)
async def delete_recipe(
    recipe_id: str,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Recipe).where(Recipe.id == recipe_id, Recipe.restaurant_id == user.restaurant_id)
    )
    recipe = result.scalar_one_or_none()
    if not recipe:
        raise HTTPException(404, "Recipe not found")
    recipe.is_active = False
    db.add(recipe)
