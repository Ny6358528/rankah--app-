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
                                ElevatedButton.icon(
                                  onPressed: () => _showDetailsDialog(item),
                                  icon: const Icon(Icons.info_outline),
                                  label: const Text("Details"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      data.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.delete_outline),
                                  label: const Text("Delete"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade600,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
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
                  final isNotFound = state.message.contains('404');
                  return Center(
                    child: Text(
                      isNotFound
                          ? "No completed reservations found."
                          : "An error occurred. Please try again.",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
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
    final rawDateTime = item['startTimeOfReservation'];
    DateTime? parsedDateTime;

    if (rawDateTime != null) {
      try {
        parsedDateTime = DateTime.parse(rawDateTime);
      } catch (e) {}
    }

    String formattedDate = parsedDateTime != null
        ? "${parsedDateTime.year}-${_twoDigits(parsedDateTime.month)}-${_twoDigits(parsedDateTime.day)}"
        : "N/A";

    String formattedTime = parsedDateTime != null
        ? "${_twoDigits(parsedDateTime.hour)}:${_twoDigits(parsedDateTime.minute)}"
        : "N/A";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.directions_car, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              "Reservation Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Car Number", item['carNumber']),
            const Divider(),
            _buildDetailRow("Date", formattedDate),
            const Divider(),
            _buildDetailRow("Time", formattedTime),
            const Divider(),
            _buildDetailRow("Parking Spot", item['parkingSpotId']),
          ],
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.close),
            label: const Text("Close"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  Widget _buildDetailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'N/A',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
