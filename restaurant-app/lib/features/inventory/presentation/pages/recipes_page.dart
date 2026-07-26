import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../providers/inventory_provider.dart';
import '../../data/models/inventory_models.dart';

class RecipesPage extends ConsumerWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final recipes = ref.watch(recipesProvider);

    final totalCost = recipes.fold(0.0, (s, r) => s + r.totalCost);
    final avgCost = recipes.isEmpty ? 0.0 : totalCost / recipes.length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Recipes & Cost'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => _showForm(context, ref))],
      ),
      body: Column(children: [
        // Summary
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(child: _SummaryBox('${recipes.length}', 'Recipes', AppColors.kpiBlue, isDark)),
            const SizedBox(width: 10),
            Expanded(child: _SummaryBox('SAR ${avgCost.toStringAsFixed(2)}', 'Avg Cost/Recipe', AppColors.kpiGreen, isDark)),
            const SizedBox(width: 10),
            Expanded(child: _SummaryBox('${recipes.expand((r) => r.ingredients).length}', 'Ingredients Used', AppColors.kpiPurple, isDark)),
          ]),
        ),
        Expanded(
          child: recipes.isEmpty
              ? const Center(child: Text('No recipes yet.\nCreate a recipe to track dish costs.',
                  textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondaryLight)))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: recipes.length,
                  itemBuilder: (ctx, i) => _RecipeCard(
                    recipe: recipes[i], isDark: isDark,
                    onTap: () => _showDetail(context, ref, recipes[i]),
                  ),
                ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.menu_book_outlined, color: Colors.white),
        label: const Text('Add Recipe', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showDetail(BuildContext context, WidgetRef ref, Recipe recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _RecipeDetailSheet(recipe: recipe, ref: ref),
    );
  }

  void _showForm(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _RecipeFormSheet(ref: ref),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String value, label;
  final Color color;
  final bool isDark;
  const _SummaryBox(this.value, this.label, this.color, this.isDark);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
    ),
    child: Column(children: [
      Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 13), textAlign: TextAlign.center),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight), textAlign: TextAlign.center),
    ]),
  );
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isDark;
  final VoidCallback onTap;
  const _RecipeCard({required this.recipe, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.kpiOrange.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.menu_book_outlined, color: AppColors.kpiOrange, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(recipe.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              if (recipe.nameAr != null)
                Text(recipe.nameAr!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
              if (recipe.category != null)
                StatusBadge(label: recipe.category!, color: AppColors.kpiBlue),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('SAR ${recipe.costPerServing.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.kpiGreen, fontSize: 15)),
              const Text('per serving', style: TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
            ]),
          ]),
          const SizedBox(height: 10),
          Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
          const SizedBox(height: 10),
          Row(children: [
            _InfoItem(Icons.people_outlined, '${recipe.servingSize} serving${recipe.servingSize > 1 ? 's' : ''}'),
            const SizedBox(width: 16),
            _InfoItem(Icons.inventory_2_outlined, '${recipe.ingredients.length} ingredients'),
            if (recipe.preparationTime != null) ...[
              const SizedBox(width: 16),
              _InfoItem(Icons.timer_outlined, '${recipe.preparationTime}min'),
            ],
            const Spacer(),
            Text('Total: SAR ${recipe.totalCost.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.kpiBlue)),
          ]),
          // Cost bar
          const SizedBox(height: 10),
          Row(children: [
            const Text('Ingredients cost breakdown', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
          ]),
          const SizedBox(height: 6),
          if (recipe.ingredients.isNotEmpty) ...[
            SizedBox(
              height: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Row(
                  children: recipe.ingredients.asMap().entries.map((e) {
                    final pct = recipe.totalCost > 0 ? e.value.cost / recipe.totalCost : 0.0;
                    return Expanded(
                      flex: (pct * 100).round().clamp(1, 100),
                      child: Container(color: AppColors.chartColors[e.key % AppColors.chartColors.length]),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ]),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoItem(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 13, color: AppColors.textSecondaryLight),
    const SizedBox(width: 4),
    Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
  ]);
}

class _RecipeDetailSheet extends StatelessWidget {
  final Recipe recipe;
  final WidgetRef ref;
  const _RecipeDetailSheet({required this.recipe, required this.ref});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DraggableScrollableSheet(
      initialChildSize: 0.85, maxChildSize: 0.95, minChildSize: 0.5,
      expand: false,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(controller: ctrl, padding: const EdgeInsets.all(24), children: [
          Center(child: Container(width: 40, height: 4,
            decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(recipe.name, style: Theme.of(context).textTheme.titleLarge),
              if (recipe.nameAr != null) Text(recipe.nameAr!, style: const TextStyle(color: AppColors.textSecondaryLight)),
              if (recipe.category != null) ...[const SizedBox(height: 6), StatusBadge(label: recipe.category!, color: AppColors.kpiBlue)],
            ])),
          ]),
          const SizedBox(height: 16),
          // Cost summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.kpiGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.kpiGreen.withOpacity(0.3)),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _CostItem('SAR ${recipe.totalCost.toStringAsFixed(2)}', 'Total Cost', AppColors.kpiGreen),
              Container(height: 40, width: 1, color: AppColors.borderLight),
              _CostItem('${recipe.servingSize}', 'Servings', AppColors.kpiBlue),
              Container(height: 40, width: 1, color: AppColors.borderLight),
              _CostItem('SAR ${recipe.costPerServing.toStringAsFixed(2)}', 'Cost/Serving', AppColors.kpiOrange),
            ]),
          ),
          const SizedBox(height: 20),
          Text('Ingredients (${recipe.ingredients.length})', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...recipe.ingredients.asMap().entries.map((e) {
            final ing = e.value;
            final pct = recipe.totalCost > 0 ? (ing.cost / recipe.totalCost * 100).toStringAsFixed(1) : '0';
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Row(children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.chartColors[e.key % AppColors.chartColors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(ing.itemName ?? ing.itemId, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                  Text('${ing.quantity} ${ing.unit}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('SAR ${ing.cost.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.kpiGreen)),
                  Text('$pct%', style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                ]),
              ]),
            );
          }),
          const SizedBox(height: 20),
          if (recipe.notes != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(recipe.notes!, style: const TextStyle(fontSize: 13)),
            ),
            const SizedBox(height: 20),
          ],
          Row(children: [
            Expanded(child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Recipe'),
            )),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.calculate_outlined),
              label: const Text('Calc Cost'),
            )),
          ]),
        ]),
      ),
    );
  }
}

class _CostItem extends StatelessWidget {
  final String value, label;
  final Color color;
  const _CostItem(this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 14)),
    const SizedBox(height: 2),
    Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
  ]);
}

class _RecipeFormSheet extends StatefulWidget {
  final WidgetRef ref;
  const _RecipeFormSheet({required this.ref});
  @override
  State<_RecipeFormSheet> createState() => _RecipeFormSheetState();
}

class _RecipeFormSheetState extends State<_RecipeFormSheet> {
  final _nameCtrl = TextEditingController();
  final _nameArCtrl = TextEditingController();
  final _servingCtrl = TextEditingController(text: '1');
  final _prepCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String? _category;
  final List<Map<String, dynamic>> _ingredients = [];
  final _categories = ['Main Course', 'Appetizer', 'Dessert', 'Soup', 'Salad', 'Beverage', 'Sides'];

  @override
  Widget build(BuildContext context) {
    final invItems = widget.ref.watch(inventoryItemsProvider);
    final totalCost = _ingredients.fold(0.0, (s, i) => s + ((i['qty'] as double) * (i['cost'] as double)));

    return DraggableScrollableSheet(
      initialChildSize: 0.92, maxChildSize: 0.95, minChildSize: 0.5,
      expand: false,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(controller: ctrl, padding: const EdgeInsets.all(24), children: [
          Text('Add Recipe', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Recipe Name *')),
          const SizedBox(height: 12),
          TextField(controller: _nameArCtrl, textDirection: TextDirection.rtl, decoration: const InputDecoration(labelText: 'الاسم بالعربي')),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v),
            )),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _servingCtrl, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Servings'))),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _prepCtrl, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Prep Time (min)'))),
          ]),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Ingredients', style: Theme.of(context).textTheme.titleMedium),
              if (_ingredients.isNotEmpty)
                Text('Total Cost: SAR ${totalCost.toStringAsFixed(2)}',
                  style: const TextStyle(color: AppColors.kpiGreen, fontWeight: FontWeight.w600)),
            ]),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add'),
              onPressed: () => _addIngredient(invItems),
            ),
          ]),
          ..._ingredients.asMap().entries.map((e) {
            final ing = e.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(color: AppColors.borderLight), borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(ing['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
                  Text('${ing['qty']} ${ing['unit']} — SAR ${((ing['qty'] as double) * (ing['cost'] as double)).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                ])),
                IconButton(icon: const Icon(Icons.close, size: 16, color: AppColors.error),
                  onPressed: () => setState(() => _ingredients.removeAt(e.key))),
              ]),
            );
          }),
          const SizedBox(height: 16),
          TextField(controller: _notesCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Notes')),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _nameCtrl.text.isEmpty ? null : () {
              final servings = int.tryParse(_servingCtrl.text) ?? 1;
              final totalC = _ingredients.fold(0.0, (s, i) => s + ((i['qty'] as double) * (i['cost'] as double)));
              final recipe = Recipe(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                restaurantId: 'r1', name: _nameCtrl.text,
                nameAr: _nameArCtrl.text.isNotEmpty ? _nameArCtrl.text : null,
                category: _category, servingSize: servings,
                preparationTime: int.tryParse(_prepCtrl.text),
                totalCost: totalC, costPerServing: totalC / servings,
                notes: _notesCtrl.text.isNotEmpty ? _notesCtrl.text : null,
                isActive: true,
                ingredients: _ingredients.map((i) => RecipeIngredient(
                  id: DateTime.now().millisecondsSinceEpoch.toString() + i['itemId'],
                  itemId: i['itemId'], itemName: i['name'], itemUnit: i['unit'],
                  quantity: i['qty'], unit: i['unit'], cost: (i['qty'] as double) * (i['cost'] as double),
                )).toList(),
                createdAt: DateTime.now(),
              );
              widget.ref.read(recipesProvider.notifier).state = [...widget.ref.read(recipesProvider), recipe];
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Recipe created'), backgroundColor: AppColors.success));
            },
            child: const Text('Save Recipe'),
          ),
        ]),
      ),
    );
  }

  void _addIngredient(List<InventoryItem> items) {
    InventoryItem? sel;
    final qtyCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, ss) => AlertDialog(
          title: const Text('Add Ingredient'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<InventoryItem>(
              value: sel,
              decoration: const InputDecoration(labelText: 'Ingredient'),
              items: items.map((i) => DropdownMenuItem(value: i, child: Text(i.name))).toList(),
              onChanged: (v) => ss(() => sel = v),
            ),
            const SizedBox(height: 12),
            TextField(controller: qtyCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Quantity (${sel?.unit ?? ''})')),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(onPressed: () {
              if (sel == null) return;
              final qty = double.tryParse(qtyCtrl.text) ?? 0;
              if (qty <= 0) return;
              setState(() => _ingredients.add({
                'itemId': sel!.id, 'name': sel!.name,
                'qty': qty, 'unit': sel!.unit, 'cost': sel!.costPerUnit,
              }));
              Navigator.pop(ctx);
            }, child: const Text('Add')),
          ],
        ),
      ),
    );
  }
}
