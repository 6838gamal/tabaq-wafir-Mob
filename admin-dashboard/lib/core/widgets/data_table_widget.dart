// lib/core/widgets/data_table_widget.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DataTableColumn<T> {
  final String label;
  final Widget Function(T row) cellBuilder;
  final double? width;
  final bool sortable;

  const DataTableColumn({
    required this.label,
    required this.cellBuilder,
    this.width,
    this.sortable = false,
  });
}

class DataTableWidget<T> extends StatelessWidget {
  final List<DataTableColumn<T>> columns;
  final List<T> rows;
  final bool isLoading;
  final String? emptyMessage;
  final void Function(T row)? onRowTap;
  final int? currentPage;
  final int? totalPages;
  final VoidCallback? onNextPage;
  final VoidCallback? onPreviousPage;

  const DataTableWidget({
    super.key,
    required this.columns,
    required this.rows,
    this.isLoading = false,
    this.emptyMessage,
    this.onRowTap,
    this.currentPage,
    this.totalPages,
    this.onNextPage,
    this.onPreviousPage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLoading)
                const LinearProgressIndicator(
                  minHeight: 2,
                  color: AppColors.primary,
                  backgroundColor: AppColors.border,
                ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: columns
                      .map(
                        (col) => DataColumn(
                          label: Text(col.label),
                        ),
                      )
                      .toList(),
                  rows: rows.isEmpty
                      ? []
                      : rows.map((row) {
                          return DataRow(
                            onSelectChanged: onRowTap != null
                                ? (_) => onRowTap!(row)
                                : null,
                            cells: columns
                                .map((col) => DataCell(col.cellBuilder(row)))
                                .toList(),
                          );
                        }).toList(),
                ),
              ),
              if (rows.isEmpty && !isLoading)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.inbox_outlined,
                          size: 48,
                          color: AppColors.textDisabled,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          emptyMessage ?? 'No data available',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (currentPage != null && totalPages != null && totalPages! > 1) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed:
                    currentPage! > 1 ? onPreviousPage : null,
                icon: const Icon(Icons.chevron_left),
              ),
              const SizedBox(width: 8),
              Text(
                'Page $currentPage of $totalPages',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed:
                    currentPage! < totalPages! ? onNextPage : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  factory StatusBadge.fromStatus(String status) {
    Color bg;
    Color text;
    switch (status.toLowerCase()) {
      case 'active':
      case 'approved':
      case 'online':
      case 'resolved':
      case 'closed':
        bg = AppColors.successLight;
        text = AppColors.success;
        break;
      case 'pending':
      case 'trial':
        bg = AppColors.warningLight;
        text = AppColors.warning;
        break;
      case 'suspended':
      case 'banned':
      case 'cancelled':
      case 'rejected':
        bg = AppColors.errorLight;
        text = AppColors.error;
        break;
      default:
        bg = AppColors.surfaceVariant;
        text = AppColors.textSecondary;
    }
    return StatusBadge(
        label: status.toUpperCase(), backgroundColor: bg, textColor: text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
