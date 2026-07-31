import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/theme/app_theme.dart';
import '../../models/transit_models.dart';
import '../../services/places_autocomplete_service.dart';
import '../../services/transit_repository.dart';
import '../widgets/dev_jump_menu.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/pill_back_button.dart';
import '../widgets/slide_route.dart';
import 'live_tracking_screen.dart';

class SearchRouteScreen extends StatefulWidget {
  const SearchRouteScreen({super.key});

  @override
  State<SearchRouteScreen> createState() => _SearchRouteScreenState();
}

class _SearchRouteScreenState extends State<SearchRouteScreen> {
  static const _destinations = <String>[
    'Kigali City Centre',
    'Kigali International Airport',
    'Kimironko Market',
    'Nyabugogo Bus Park',
    'Kacyiru',
    'Remera',
    'Kicukiro Centre',
    'Nyamirambo',
    'University of Rwanda – Huye Campus',
  ];

  final _placesService = PlacesAutocompleteService();

  bool _searched = false;
  bool _gettingCurrentLocation = false;
  String? _destination;
  String _origin = 'Current Location';

  Future<void> _useCurrentLocation() async {
    setState(() => _gettingCurrentLocation = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _showLocationMessage(
            'Turn on location services to use your current location.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        _showLocationMessage('Location permission was not granted.');
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        _showLocationMessage(
            'Location permission is permanently denied. Enable it in Settings.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      if (!mounted) return;
      setState(() {
        _origin =
            'Current location (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})';
        _searched = false;
      });
    } catch (_) {
      _showLocationMessage(
          'We could not get your location. Try again or check your device settings.');
    } finally {
      if (mounted) setState(() => _gettingCurrentLocation = false);
    }
  }

  void _showLocationMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _pickDestination() async {
    final searchController = TextEditingController();
    String query = '';
    List<PlaceSuggestion> liveSuggestions = [];
    bool isSearching = false;
    bool sheetClosed = false;
    Timer? debounce;

    final destination = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setModalState) {
          final localMatches = _destinations
              .where((destination) =>
                  destination.toLowerCase().contains(query.toLowerCase()))
              .toList();

          void onQueryChanged(String value) {
            query = value.trim();
            debounce?.cancel();
            if (query.isEmpty) {
              setModalState(() {
                liveSuggestions = [];
                isSearching = false;
              });
              return;
            }
            setModalState(() => isSearching = true);
            debounce = Timer(const Duration(milliseconds: 400), () async {
              final results = await _placesService.search(query);
              if (sheetClosed) return;
              setModalState(() {
                liveSuggestions = results;
                isSearching = false;
              });
            });
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select your destination',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  const Text('Search for a stop, neighbourhood, or landmark.',
                      style: TextStyle(color: AppColors.textBody)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: searchController,
                    autofocus: true,
                    onChanged: onQueryChanged,
                    decoration: InputDecoration(
                      hintText: 'Search destinations',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: isSearching
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        if (query.isEmpty)
                          for (final destination in localMatches)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.location_on_outlined,
                                  color: AppColors.primary),
                              title: Text(destination),
                              onTap: () =>
                                  Navigator.of(sheetContext).pop(destination),
                            )
                        else ...[
                          for (final suggestion in liveSuggestions)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.location_on_outlined,
                                  color: AppColors.primary),
                              title: Text(suggestion.text),
                              onTap: () => Navigator.of(sheetContext)
                                  .pop(suggestion.text),
                            ),
                          if (!liveSuggestions.any((s) =>
                              s.text.toLowerCase() == query.toLowerCase()))
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.add_location_alt_outlined,
                                  color: AppColors.primary),
                              title: Text('Use "$query"'),
                              onTap: () =>
                                  Navigator.of(sheetContext).pop(query),
                            ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    sheetClosed = true;
    debounce?.cancel();
    searchController.dispose();

    if (destination != null && mounted) {
      setState(() {
        _destination = destination;
        _searched = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PillBackButton(onTap: () => Navigator.of(context).pop()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FadeInUp(
                          child: Text(
                            'Find your Route',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FadeInUp(
                          delay: const Duration(milliseconds: 60),
                          child: Material(
                            color: AppColors.cardGrey,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              key: const Key('current-location-picker'),
                              borderRadius: BorderRadius.circular(12),
                              onTap: _gettingCurrentLocation
                                  ? null
                                  : _useCurrentLocation,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.my_location,
                                        color: AppColors.primary),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'From: $_origin',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textDark,
                                            fontSize: 14),
                                      ),
                                    ),
                                    if (_gettingCurrentLocation)
                                      const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    else
                                      const Icon(Icons.refresh,
                                          color: AppColors.textGrey),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        FadeInUp(
                          delay: const Duration(milliseconds: 110),
                          child: Semantics(
                            button: true,
                            label: 'Select destination',
                            child: Material(
                              color: AppColors.cardGrey,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                key: const Key('destination-picker'),
                                borderRadius: BorderRadius.circular(12),
                                onTap: _pickDestination,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined,
                                          color: AppColors.primary),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _destination == null
                                              ? 'To: Select destination'
                                              : 'To: $_destination',
                                          style: TextStyle(
                                            color: _destination == null
                                                ? AppColors.textGrey
                                                : AppColors.textDark,
                                            fontSize: 14,
                                            fontWeight: _destination == null
                                                ? FontWeight.normal
                                                : FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right,
                                          color: AppColors.textGrey),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        FadeInUp(
                          delay: const Duration(milliseconds: 160),
                          child: ElevatedButton(
                            onPressed: _destination == null
                                ? null
                                : () async {
                                    try {
                                      await TransitRepository()
                                          .createTripRequest(
                                        origin: _origin,
                                        destination: _destination!,
                                        routeId: kDemoBusId,
                                      );
                                    } catch (_) {
                                      // Route discovery remains available if optional
                                      // cloud trip-request sync is unavailable.
                                    }
                                    if (mounted)
                                      setState(() => _searched = true);
                                  },
                            child: const Text('Find Route'),
                          ),
                        ),
                        const SizedBox(height: 22),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 380),
                          transitionBuilder: (child, anim) => FadeTransition(
                            opacity: anim,
                            child: ScaleTransition(
                              scale: Tween(begin: 0.96, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: anim, curve: Curves.easeOutCubic),
                              ),
                              child: child,
                            ),
                          ),
                          child: _searched
                              ? GestureDetector(
                                  key: const ValueKey('result'),
                                  onTap: () => Navigator.of(context).push(
                                      slideRoute(const LiveTrackingScreen())),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      border:
                                          Border.all(color: AppColors.divider),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 14,
                                            offset: const Offset(0, 6)),
                                      ],
                                    ),
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Route 45',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16,
                                                color: AppColors.textDark)),
                                        SizedBox(height: 6),
                                        Text('25 minutes',
                                            style: TextStyle(
                                                color: AppColors.textGrey,
                                                fontSize: 13)),
                                        Text('12.5 KM',
                                            style: TextStyle(
                                                color: AppColors.textGrey,
                                                fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(key: ValueKey('empty')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const DevJumpMenuButton(current: 'Search Route'),
          ],
        ),
      ),
    );
  }
}
