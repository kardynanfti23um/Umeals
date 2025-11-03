import 'package:flutter/material.dart';
import '../models/food_models.dart';
import 'vendor_screen.dart';
import 'cart_screen.dart';
import 'all_menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CartItem> cartItems = [];
  List<Vendor> filteredVendors = [];

  // Sample data based on the images
  final List<Vendor> vendors = [
    Vendor(
      name: 'Bu Linda',
      image: 'assets/images/vendors/bu_linda.jpg',
      menuItems: [
        MenuItem(name: 'Mie Ayam Special', price: 12000, image: 'assets/images/food/mie_ayam.jpg', vendor: 'Bu Linda'),
        MenuItem(name: 'Soto Ayam Berkuah', price: 12000, image: 'assets/images/food/soto_ayam.jpg', vendor: 'Bu Linda'),
        MenuItem(name: 'Rawon Ayam Kampung', price: 13000, image: 'assets/images/food/rawon_ayam.jpg', vendor: 'Bu Linda'),
      ],
      queueList: [], // Will be populated from QueueManager
    ),
    Vendor(
      name: 'Pak Bambang',
      image: 'assets/images/vendors/pak_bambang.jpg',
      menuItems: [
        MenuItem(name: 'Dimsum', price: 15000, image: 'assets/images/food/dimsum.jpg', vendor: 'Pak Bambang'),
        MenuItem(name: 'Bubur Ayam', price: 10000, image: 'assets/images/food/bubur_ayam.jpg', vendor: 'Pak Bambang'),
        MenuItem(name: 'Chicken Katsu', price: 20000, image: 'assets/images/food/chicken_katsu.jpg', vendor: 'Pak Bambang'),
      ],
      queueList: [], // Will be populated from QueueManager
    ),
    Vendor(
      name: 'Bu Yayuk',
      image: 'assets/images/vendors/bu_yayuk.jpg',
      menuItems: [
        MenuItem(name: 'Ayam Geprek', price: 15000, image: 'assets/images/food/ayam_geprek.jpg', vendor: 'Bu Yayuk'),
        MenuItem(name: 'Nasi Goreng', price: 12000, image: 'assets/images/food/nasi_goreng.jpg', vendor: 'Bu Yayuk'),
        MenuItem(name: 'Sate Ayam', price: 18000, image: 'assets/images/food/sate_ayam.jpg', vendor: 'Bu Yayuk'),
      ],
      queueList: [], // Will be populated from QueueManager
    ),
  ];

  @override
  void initState() {
    super.initState();
    filteredVendors = vendors;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchController.text.isEmpty) {
        filteredVendors = vendors;
      } else {
        filteredVendors = vendors.where((vendor) {
          // Search by vendor name
          bool vendorMatch = vendor.name.toLowerCase().contains(_searchController.text.toLowerCase());
          
          // Search by menu items
          bool menuMatch = vendor.menuItems.any((item) =>
              item.name.toLowerCase().contains(_searchController.text.toLowerCase()));
          
          return vendorMatch || menuMatch;
        }).toList();
      }
    });
  }

  List<MenuItem> get allMenuItems {
    List<MenuItem> allItems = [];
    for (var vendor in vendors) {
      allItems.addAll(vendor.menuItems);
    }
    return allItems;
  }

  List<MenuItem> get recommendedMenuItems {
    return allMenuItems.take(2).toList(); // Show first 2 as recommended
  }

  void addToCart(MenuItem item) {
    setState(() {
      final existingIndex = cartItems.indexWhere((cartItem) => cartItem.menuItem.name == item.name);
      if (existingIndex >= 0) {
        cartItems[existingIndex].quantity++;
      } else {
        cartItems.add(CartItem(menuItem: item));
      }
    });
  }

  void _navigateToAllMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllMenuScreen(
          allMenuItems: allMenuItems,
          onAddToCart: addToCart,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.teal.shade700,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'U',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade700,
                          ),
                        ),
                        Text(
                          'Meal',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade600,
                          ),
                        ),
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(left: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade400,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (cartItems.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartScreen(cartItems: cartItems),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            Icon(Icons.shopping_cart, color: Colors.teal.shade700),
                            if (cartItems.isNotEmpty)
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${cartItems.fold(0, (sum, item) => sum + item.quantity)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade300,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Mau makan dimana? Cari vendor atau menu...',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onSubmitted: (value) {
                          // Optional: You can add additional search functionality here
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Show search results or normal content
                    if (_searchController.text.isNotEmpty) ...[
                      // Search Results
                      Text(
                        'Hasil Pencarian (${filteredVendors.length} vendor)',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      if (filteredVendors.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Vendor atau menu tidak ditemukan',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Coba kata kunci lain',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...filteredVendors.map((vendor) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: AssetImage(vendor.image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            vendor.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            '${vendor.menuItems.length} menu tersedia',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => VendorScreen(
                                              vendor: vendor,
                                              onAddToCart: addToCart,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal.shade600,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      child: const Text(
                                        'Lihat',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Menu populer:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: vendor.menuItems.take(3).map((item) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${item.name} - Rp${item.price.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green.shade800,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                    ] else ...[
                      // Normal content when not searching
                    
                    // Kantin FMIPA section
                    const Text(
                      'Kantin FMIPA',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Kantin image
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/background/kantin_fmipa.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                        child: const Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Kantin umeals yang tersebar di beberapa fakultas',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Stand section
                    const Text(
                      'Stand',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Vendor chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: vendors.map((vendor) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VendorScreen(
                                      vendor: vendor,
                                      onAddToCart: addToCart,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  vendor.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Menu Rekomendasi section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Menu Rekomendasi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        TextButton(
                          onPressed: _navigateToAllMenu,
                          child: Text(
                            'See More',
                            style: TextStyle(
                              color: Colors.teal.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Recommended menu items
                    SizedBox(
                      height: 175, // Reduced height to prevent overflow
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recommendedMenuItems.length,
                        itemBuilder: (context, index) {
                          final item = recommendedMenuItems[index];
                          return Container(
                            width: 160, // Fixed width for each item
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(10), // Reduced padding
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: AssetImage(item.image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6), // Reduced spacing
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 1), // Reduced spacing
                                      Text(
                                        item.vendor,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Rp${item.price.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => addToCart(item),
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade400,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16), // Reduced bottom spacing
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}