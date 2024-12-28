import 'package:coffee_app/components/button/icon_button_action.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class ItemDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> filteredData;
  final Function(int) onEditItem;
  final Function(int) onDeleteItem;
  final int sortColumnIndex;
  final bool isAscending;
  final Function(int, bool) sortData;

  const ItemDataTable({
    Key? key,
    required this.filteredData,
    required this.onEditItem,
    required this.onDeleteItem,
    required this.sortColumnIndex,
    required this.isAscending,
    required this.sortData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Allow horizontal scrolling
      child: DataTable(
        columnSpacing: 12,
        horizontalMargin: 12,
        sortColumnIndex: sortColumnIndex,
        sortAscending: isAscending,
        dataRowMinHeight: 48,
        dataRowMaxHeight: double.infinity,
        columns: [
          DataColumn2(
            label: const Text('Title'),
  fixedWidth: 200,
            onSort: (columnIndex, ascending) {
              sortData(columnIndex, ascending);
            },
          ),
          DataColumn2(
            label: const Text('Photo'),
            size: ColumnSize.L,
            onSort: (columnIndex, ascending) {
              sortData(columnIndex, ascending);
            },
          ),
          DataColumn(
            label: const Text('Price'),
            onSort: (columnIndex, ascending) {
              sortData(columnIndex, ascending);
            },
          ),
          DataColumn(
            label: const Text('Discount'),
            onSort: (columnIndex, ascending) {
              sortData(columnIndex, ascending);
            },
          ),
          const DataColumn(
            label: Text('Actions'),
          ),
        ],
        rows: List<DataRow>.generate(
          filteredData.length,
          (index) => DataRow(
            cells: [
              DataCell(Text(filteredData[index]['title'])),
              DataCell(
                Image.asset(
                  "assets/images/coffee.jpg",
                  width: 50,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              DataCell(Text(filteredData[index]['price'])),
              DataCell(Text(filteredData[index]['discount'])),
              DataCell(
                Row(
                  children: [
                    IconButtonAction(
                      color: const Color(0xFF0D6EFD),
                      icon: Icons.edit,
                      text: "Edit",
                      onTap: () {
                        onEditItem(index);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButtonAction(
                      color: const Color(0xFFF45A58),
                      icon: Icons.delete_outline,
                      text: "Delete",
                      onTap: () {
                        onDeleteItem(index);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
