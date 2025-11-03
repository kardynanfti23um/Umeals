import 'package:flutter/material.dart';
import '../models/food_models.dart';

class QueueManager extends ChangeNotifier {
  static final QueueManager _instance = QueueManager._internal();
  factory QueueManager() => _instance;
  QueueManager._internal();

  // Map untuk menyimpan antrian setiap vendor
  final Map<String, List<QueueItem>> _vendorQueues = {
    'Bu Linda': [
      QueueItem(
        customerName: 'Halim Laper',
        orderId: 'HL001',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        status: QueueStatus.preparing,
      ),
      QueueItem(
        customerName: 'Lea Rorr',
        orderId: 'LR002',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        status: QueueStatus.preparing,
      ),
      QueueItem(
        customerName: 'Hakim Kece',
        orderId: 'HK003',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        status: QueueStatus.preparing,
      ),
      QueueItem(
        customerName: 'Bagas',
        orderId: 'BG004',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        status: QueueStatus.preparing,
      ),
      QueueItem(
        customerName: 'Haqiqi Pretu',
        orderId: 'HP005',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        status: QueueStatus.preparing,
      ),
      QueueItem(
        customerName: 'Dyah Cantik',
        orderId: 'DC006',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        status: QueueStatus.preparing,
      ),
    ],
    'Pak Bambang': [
      QueueItem(
        customerName: 'Hakim Slebewww',
        orderId: 'HS001',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        status: QueueStatus.preparing,
      ),
      QueueItem(
        customerName: 'Hakim Bahill',
        orderId: 'DB002',
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
        status: QueueStatus.preparing,
      ),
    ],
    'Bu Yayuk': [
      QueueItem(
        customerName: 'Anya Ngenes',
        orderId: 'AN001',
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
        status: QueueStatus.preparing,
      ),
      QueueItem(
        customerName: 'Moana',
        orderId: 'MN002',
        timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
        status: QueueStatus.preparing,
      ),
    ],
  };

  // Getter untuk mengakses antrian vendor
  List<QueueItem> getVendorQueue(String vendorName) {
    return _vendorQueues[vendorName] ?? [];
  }

  // Menambahkan pesanan baru ke antrian vendor
  void addToQueue(Order order) {
    // Tentukan vendor utama dari pesanan (vendor dengan item terbanyak)
    Map<String, int> vendorItemCount = {};
    for (var cartItem in order.items) {
      String vendor = cartItem.menuItem.vendor;
      vendorItemCount[vendor] = (vendorItemCount[vendor] ?? 0) + cartItem.quantity;
    }
    
    // Ambil vendor dengan item terbanyak
    String primaryVendor = vendorItemCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // Check if customer already has an order in queue to prevent duplicates
    List<QueueItem> currentQueue = _vendorQueues[primaryVendor] ?? [];
    bool customerAlreadyInQueue = currentQueue.any((item) => 
        item.customerName.toLowerCase() == order.customerName.toLowerCase());
    
    if (customerAlreadyInQueue) {
      print('Customer ${order.customerName} already has an order in queue for $primaryVendor');
      return;
    }

    // Generate order ID unik
    String orderId = _generateOrderId(primaryVendor);

    // Buat queue item baru
    QueueItem newQueueItem = QueueItem(
      customerName: order.customerName,
      orderId: orderId,
      timestamp: DateTime.now(),
      status: QueueStatus.preparing,
      order: order,
    );

    // Tambahkan ke antrian vendor
    if (_vendorQueues[primaryVendor] == null) {
      _vendorQueues[primaryVendor] = [];
    }
    _vendorQueues[primaryVendor]!.add(newQueueItem);

    print('Added order $orderId for ${order.customerName} to $primaryVendor queue. Position: ${_vendorQueues[primaryVendor]!.length}');

    // Notify listeners untuk update UI
    notifyListeners();
  }

  // Generate order ID unik
  String _generateOrderId(String vendorName) {
    String prefix = vendorName.substring(0, 2).toUpperCase();
    int orderNumber = (_vendorQueues[vendorName]?.length ?? 0) + 1;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    return '$prefix$orderNumber$timestamp';
  }

  // Update status pesanan
  void updateOrderStatus(String vendorName, String orderId, QueueStatus newStatus) {
    List<QueueItem> queue = _vendorQueues[vendorName] ?? [];
    int index = queue.indexWhere((item) => item.orderId == orderId);
    
    if (index != -1) {
      queue[index] = queue[index].copyWith(status: newStatus);
      
      // Jika status selesai, hapus dari antrian setelah delay
      if (newStatus == QueueStatus.completed) {
        Future.delayed(const Duration(seconds: 3), () {
          queue.removeAt(index);
          notifyListeners();
        });
      }
      
      notifyListeners();
    }
  }

  // Hapus pesanan dari antrian
  void removeFromQueue(String vendorName, String orderId) {
    List<QueueItem> queue = _vendorQueues[vendorName] ?? [];
    queue.removeWhere((item) => item.orderId == orderId);
    notifyListeners();
  }

  // Mendapatkan posisi antrian untuk customer tertentu
  int getQueuePosition(String vendorName, String customerName) {
    List<QueueItem> queue = _vendorQueues[vendorName] ?? [];
    int index = queue.indexWhere((item) => item.customerName == customerName);
    return index == -1 ? -1 : index + 1;
  }

  // Mendapatkan estimasi waktu tunggu (dalam menit)
  int getEstimatedWaitTime(String vendorName, String customerName) {
    int position = getQueuePosition(vendorName, customerName);
    if (position == -1) return 0;
    
    // Estimasi 5 menit per pesanan
    return position * 5;
  }
}

// Model untuk item antrian
class QueueItem {
  final String customerName;
  final String orderId;
  final DateTime timestamp;
  final QueueStatus status;
  final Order? order;

  QueueItem({
    required this.customerName,
    required this.orderId,
    required this.timestamp,
    required this.status,
    this.order,
  });

  QueueItem copyWith({
    String? customerName,
    String? orderId,
    DateTime? timestamp,
    QueueStatus? status,
    Order? order,
  }) {
    return QueueItem(
      customerName: customerName ?? this.customerName,
      orderId: orderId ?? this.orderId,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      order: order ?? this.order,
    );
  }

  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

// Enum untuk status antrian
enum QueueStatus {
  preparing,
  ready,
  completed,
  cancelled,
}

extension QueueStatusExtension on QueueStatus {
  String get displayName {
    switch (this) {
      case QueueStatus.preparing:
        return 'Sedang Diproses';
      case QueueStatus.ready:
        return 'Siap Diambil';
      case QueueStatus.completed:
        return 'Selesai';
      case QueueStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  Color get color {
    switch (this) {
      case QueueStatus.preparing:
        return Colors.orange;
      case QueueStatus.ready:
        return Colors.green;
      case QueueStatus.completed:
        return Colors.blue;
      case QueueStatus.cancelled:
        return Colors.red;
    }
  }
}