import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yatra_app/app/themes/dashboard_theme.dart';
import 'package:yatra_app/feature/trips/presentation/view_model/trip_event.dart';
import 'package:yatra_app/feature/trips/presentation/view_model/trip_state.dart';
import 'package:yatra_app/feature/trips/presentation/view_model/trip_view_model.dart';
import 'package:yatra_app/app/service_locator/service_locator.dart';
import 'package:yatra_app/feature/trips/domain/entity/trips_entity.dart';

class TripsView extends StatefulWidget {
  const TripsView({super.key});

  @override
  State<TripsView> createState() => _TripsViewState();
}

class _TripsViewState extends State<TripsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final trimmed = value.trim();
    context.read<TripViewModel>().add(FetchTripsEvent(query: trimmed.isEmpty ? null : trimmed));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TripViewModel>(
      create: (_) =>
          serviceLocator<TripViewModel>()..add(FetchTripsEvent()), // initial load
      child: Scaffold(
        backgroundColor: DashboardTheme.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: DashboardTheme.defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Greeting
                Text('Hello, User', style: DashboardTheme.greetingStyle),
                const SizedBox(height: 8),
                Text('Where do you want to go today?', style: DashboardTheme.subGreetingStyle),
                const SizedBox(height: 20),

                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search trips...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 20),

                // Section title
                Text('Trips', style: DashboardTheme.sectionTitleStyle),
                const SizedBox(height: 10),

                // Trip list
                Expanded(
                  child: BlocBuilder<TripViewModel, TripState>(
                    builder: (context, state) {
                      if (state is TripLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is TripError) {
                        return Center(
                          child: Text(
                            'Error: ${state.message}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (state is TripLoaded) {
                        if (state.trips.isEmpty) {
                          return const Center(
                            child: Text(
                              'No trips found.',
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: state.trips.length,
                          itemBuilder: (context, index) {
                            final trip = state.trips[index];
                            return routeCardFromEntity(trip);
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget routeCardFromEntity(TripEntity trip) {
    final routeName = '${trip.route.source} → ${trip.route.destination}';
    final vehicleType = trip.vehicle.type;
    final departure = trip.departureTime;
    final arrival = trip.arrivalTime;
    final status = trip.status;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          Icons.directions_bus,
          color: DashboardTheme.primaryColor,
        ),
        title: Text(
          routeName,
          style: const TextStyle(color: Color(0xFF1A3C34), fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle: $vehicleType', style: const TextStyle(color: Color(0xFF1A3C34))),
            Text('Departs: $departure  •  Arrives: $arrival', style: const TextStyle(color: Color(0xFF1A3C34))),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              status.toUpperCase(),
              style: TextStyle(
                color: status == 'scheduled'
                    ? Colors.green
                    : status == 'completed'
                        ? Colors.blue
                        : Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: () {
          // Placeholder for detail navigation if needed
        },
      ),
    );
  }
}
