class MenuItem {
  final String name;
  final double price;
  final String image;
  final String vendor;

  MenuItem({
    required this.name,
    required this.price,
    required this.image,
    required this.vendor,
  });
}

class Vendor {
  final String name;
  final String image;
  final List<MenuItem> menuItems;
  final List<String> queueList;

  Vendor({
    required this.name,
    required this.image,
    required this.menuItems,
    required this.queueList,
  });
}

class CartItem {
  final MenuItem menuItem;
  int quantity;

  CartItem({
    required this.menuItem,
    this.quantity = 1,
  });
}

class Order {
  final List<CartItem> items;
  final String customerName;
  final String request;
  final double total;

  Order({
    required this.items,
    required this.customerName,
    required this.request,
    required this.total,
  });
}