import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/feature/history/logic/cubit/history_cubit.dart';
import 'package:rankah/feature/history/logic/cubit/history_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedType = 'all';

  @override
  void initState() {
    super.initState();
    _fetchByType();
  }

  void _fetchByType() {
    final cubit = context.read<HistoryCubit>();
    if (selectedType == 'all') {
      cubit.fetchAllReservations();
    } else if (selectedType == 'canceled') {
      cubit.fetchCanceledReservations();
    } else if (selectedType == 'completed') {
      cubit.fetchCompletedReservations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔽 Dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: 'Filter by status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'canceled', child: Text('Canceled')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedType = value);
                  _fetchByType();
                }
              },
            ),
          ),

        
          Expanded(
            child: BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HistoryLoaded) {
                  final data = state.reservations;

                  if (data.isEmpty) {
                    return const Center(child: Text("No reservations found."));
                  }

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      final status = item['status']?.toString().toLowerCase() ?? '';
                      final isCanceled = status == 'canceled';
                      final isCompleted = status == 'completed';

                      final cardColor = isCanceled
                          ? Colors.red.shade100
                          : isCompleted
                              ? Colors.green.shade100
                              : Colors.grey.shade200;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Card(
                          color: cardColor,
                          margin: const EdgeInsets.all(8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                _buildInfo("Car Number", item['carNumber']),
                                const SizedBox(width: 16),
                                _buildInfo("Status", item['status']),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () => _showDetailsDialog(item),
                                  child: const Text("Details"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      data.removeAt(index);
                                    });
                                  },
                                  child: const Text("Delete"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is HistoryError) {
                  return Center(child: Text("Error: ${state.message}"));
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value?.toString() ?? 'N/A'),
      ],
    );
  }

  void _showDetailsDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Reservation Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: item.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text("${entry.key}: ${entry.value}"),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
