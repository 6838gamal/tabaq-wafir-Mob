class BranchModel {
  final String id;
  final String name;
  final String? address;
  final bool isActive;

  const BranchModel({
    required this.id,
    required this.name,
    this.address,
    this.isActive = true,
  });

  static const List<BranchModel> demoData = [
    BranchModel(id: 'branch_1', name: 'Main Branch', address: 'Riyadh — Al Olaya'),
    BranchModel(id: 'branch_2', name: 'North Branch', address: 'Riyadh — Al Nakheel'),
    BranchModel(id: 'branch_3', name: 'South Branch', address: 'Jeddah — Al Hamra'),
  ];
}
