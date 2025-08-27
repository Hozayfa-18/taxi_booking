import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/global_bottom_navigation.dart';
import './widgets/date_section_header.dart';
import './widgets/empty_history_state.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/history_search_bar.dart';
import './widgets/ride_history_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isRefreshing = false;
  int _currentTabIndex = 1; // History tab is active
  Map<String, dynamic> _activeFilters = {
    'tripType': 'All',
    'status': 'All',
    'timeRange': 'All time',
  };

  // Mock ride history data
  final List<Map<String, dynamic>> _allRideHistory = [
    {
      'id': 1,
      'date': '18 Aug 2025',
      'time': '14:30',
      'pickup': 'Piccadilly Circus, London',
      'dropoff': 'Tower Bridge, London',
      'tripType': 'Comfort',
      'fare': '£18.50',
      'status': 'Completed',
      'mapThumbnail':
          'https://images.unsplash.com/photo-1524661135-423995f22d0b?fm=jpg&q=60&w=400&h=200&fit=crop',
    },
    {
      'id': 2,
      'date': '17 Aug 2025',
      'time': '09:15',
      'pickup': 'King\'s Cross Station, London',
      'dropoff': 'Heathrow Airport Terminal 2',
      'tripType': 'XL',
      'fare': '£45.20',
      'status': 'Completed',
      'mapThumbnail':
          'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?fm=jpg&q=60&w=400&h=200&fit=crop',
    },
    {
      'id': 3,
      'date': '16 Aug 2025',
      'time': '18:45',
      'pickup': 'Oxford Street, London',
      'dropoff': 'Camden Market, London',
      'tripType': 'Economy',
      'fare': '£12.30',
      'status': 'Completed',
      'mapThumbnail':
          'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?fm=jpg&q=60&w=400&h=200&fit=crop',
    },
    {
      'id': 4,
      'date': '15 Aug 2025',
      'time': '22:10',
      'pickup': 'Westminster Bridge, London',
      'dropoff': 'Shoreditch High Street',
      'tripType': 'Comfort',
      'fare': '£16.80',
      'status': 'Cancelled',
      'mapThumbnail':
          'https://images.unsplash.com/photo-1520637836862-4d197d17c90a?fm=jpg&q=60&w=400&h=200&fit=crop',
    },
    {
      'id': 5,
      'date': '14 Aug 2025',
      'time': '11:20',
      'pickup': 'London Bridge Station',
      'dropoff': 'Canary Wharf, London',
      'tripType': 'Economy',
      'fare': '£14.90',
      'status': 'Completed',
      'mapThumbnail':
          'https://images.unsplash.com/photo-1533929736458-ca588d08c8be?fm=jpg&q=60&w=400&h=200&fit=crop',
    },
    {
      'id': 6,
      'date': '13 Aug 2025',
      'time': '16:30',
      'pickup': 'Covent Garden, London',
      'dropoff': 'Greenwich Observatory',
      'tripType': 'Comfort',
      'fare': '£22.40',
      'status': 'Completed',
      'mapThumbnail':
          'https://images.unsplash.com/photo-1529655683826-aba9b3e77383?fm=jpg&q=60&w=400&h=200&fit=crop',
    },
  ];

  List<Map<String, dynamic>> _filteredRideHistory = [];

  @override
  void initState() {
    super.initState();
    _filteredRideHistory = List.from(_allRideHistory);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreRides();
    }
  }

  Future<void> _loadMoreRides() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    // Simulate loading more rides
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);
  }

  Future<void> _refreshRides() async {
    setState(() => _isRefreshing = true);

    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isRefreshing = false);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredRideHistory = _allRideHistory.where((ride) {
        // Search filter
        if (_searchQuery.isNotEmpty) {
          final searchLower = _searchQuery.toLowerCase();
          final pickup = (ride['pickup'] as String).toLowerCase();
          final dropoff = (ride['dropoff'] as String).toLowerCase();
          final date = (ride['date'] as String).toLowerCase();

          if (!pickup.contains(searchLower) &&
              !dropoff.contains(searchLower) &&
              !date.contains(searchLower)) {
            return false;
          }
        }

        // Trip type filter
        if (_activeFilters['tripType'] != 'All' &&
            ride['tripType'] != _activeFilters['tripType']) {
          return false;
        }

        // Status filter
        if (_activeFilters['status'] != 'All' &&
            ride['status'] != _activeFilters['status']) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: 70.h,
        child: FilterBottomSheet(
          currentFilters: _activeFilters,
          onFiltersApplied: (filters) {
            setState(() {
              _activeFilters = filters;
              _applyFilters();
            });
          },
        ),
      ),
    );
  }

  void _onRideCardTap(Map<String, dynamic> rideData) {
    Navigator.pushNamed(context, '/trip-summary-screen');
  }

  void _onRebook(Map<String, dynamic> rideData) {
    Navigator.pushNamed(context, '/home-screen');
  }

  void _onViewReceipt(Map<String, dynamic> rideData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Receipt for trip #${rideData['id']} downloaded'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _onBookFirstRide() {
    Navigator.pushNamed(context, '/home-screen');
  }

  Map<String, List<Map<String, dynamic>>> _groupRidesByDate() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final ride in _filteredRideHistory) {
      final date = ride['date'] as String;
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(ride);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedRides = _groupRidesByDate();
    final hasRides = _filteredRideHistory.isNotEmpty;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Trip History',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        actions: [
          if (hasRides)
            IconButton(
              onPressed: _showFilterSheet,
              icon: CustomIconWidget(
                iconName: 'tune',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          if (hasRides) ...[
            HistorySearchBar(
              onSearchChanged: _onSearchChanged,
              onFilterTap: _showFilterSheet,
            ),
            SizedBox(height: 1.h),
          ],
          Expanded(
            child: hasRides
                ? RefreshIndicator(
                    onRefresh: _refreshRides,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: _filteredRideHistory.isEmpty
                        ? _buildNoResultsState()
                        : ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: _calculateItemCount(groupedRides),
                            itemBuilder: (context, index) =>
                                _buildListItem(groupedRides, index),
                          ),
                  )
                : EmptyHistoryState(onBookFirstRide: _onBookFirstRide),
          ),
        ],
      ),
      bottomNavigationBar: GlobalBottomNavigation(
        currentIndex: _currentTabIndex,
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 60,
            ),
            SizedBox(height: 2.h),
            Text(
              'No trips found',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search or filters',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            TextButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _activeFilters = {
                    'tripType': 'All',
                    'status': 'All',
                    'timeRange': 'All time',
                  };
                  _applyFilters();
                });
              },
              child: Text('Clear filters'),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateItemCount(
      Map<String, List<Map<String, dynamic>>> groupedRides) {
    int count = 0;
    for (final entry in groupedRides.entries) {
      count += 1; // Date header
      count += entry.value.length; // Ride cards
    }
    if (_isLoading) count += 1; // Loading indicator
    return count;
  }

  Widget _buildListItem(
      Map<String, List<Map<String, dynamic>>> groupedRides, int index) {
    int currentIndex = 0;

    for (final entry in groupedRides.entries) {
      // Date header
      if (currentIndex == index) {
        return DateSectionHeader(
          dateText: entry.key,
          tripCount: entry.value.length,
        );
      }
      currentIndex++;

      // Ride cards
      for (int i = 0; i < entry.value.length; i++) {
        if (currentIndex == index) {
          return RideHistoryCard(
            rideData: entry.value[i],
            onTap: () => _onRideCardTap(entry.value[i]),
            onRebook: () => _onRebook(entry.value[i]),
            onReceipt: () => _onViewReceipt(entry.value[i]),
          );
        }
        currentIndex++;
      }
    }

    // Loading indicator
    if (_isLoading) {
      return Container(
        padding: EdgeInsets.all(4.w),
        child: Center(
          child: CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
