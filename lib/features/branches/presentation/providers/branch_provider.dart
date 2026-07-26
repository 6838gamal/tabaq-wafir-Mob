import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/branch_model.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';

/// All branches available to the current user.
final userBranchesProvider = Provider<List<BranchModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  // Owner sees all; others see only their assigned branches.
  final allBranches = BranchModel.demoData;
  if (user.branchIds.isEmpty) return allBranches;
  return allBranches
      .where((b) => user.branchIds.contains(b.id))
      .toList();
});

/// The currently selected branch (null = All Branches).
class SelectedBranchNotifier extends StateNotifier<BranchModel?> {
  SelectedBranchNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(AppConstants.selectedBranchKey);
    if (id == null) return;
    final branch = BranchModel.demoData.where((b) => b.id == id).firstOrNull;
    if (branch != null) state = branch;
  }

  Future<void> select(BranchModel? branch) async {
    state = branch;
    final prefs = await SharedPreferences.getInstance();
    if (branch == null) {
      await prefs.remove(AppConstants.selectedBranchKey);
    } else {
      await prefs.setString(AppConstants.selectedBranchKey, branch.id);
    }
  }
}

final selectedBranchProvider =
    StateNotifierProvider<SelectedBranchNotifier, BranchModel?>((ref) {
  return SelectedBranchNotifier();
});
