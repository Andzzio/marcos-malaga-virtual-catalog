import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marcos_malaga_app/app/core/presentation/providers/store_map_ui_provider.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/title_section.dart';
import 'package:shimmer/shimmer.dart';

class MapView extends ConsumerStatefulWidget {
  final TitleSection? titleSection;
  const MapView({super.key, this.titleSection});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  final _mapController = MapController();
  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storeMapUiModelAsync = ref.watch(storeMapUiProvider);

    return storeMapUiModelAsync.when(
      data: (storeMapUiModel) => SliverToBoxAdapter(
        child: Column(
          children: [
            if (widget.titleSection != null)
              SizedBox(child: widget.titleSection),
            Stack(
              children: [
                SizedBox(
                  height: 400,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: storeMapUiModel.coordinates,
                      initialZoom: 18,
                      interactionOptions: InteractionOptions(
                        flags:
                            InteractiveFlag.all &
                            ~InteractiveFlag.scrollWheelZoom,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.andzzio.marcosmalaga',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 40,
                            height: 40,
                            point: storeMapUiModel.coordinates,
                            alignment: Alignment.topCenter,
                            child: FaIcon(
                              FontAwesomeIcons.locationDot,
                              color: Colors.redAccent,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Column(
                    spacing: 10,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom + 0.25,
                          );
                          setState(() {});
                        },
                        child: FaIcon(FontAwesomeIcons.plus),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom - 0.25,
                          );
                          setState(() {});
                        },
                        child: FaIcon(FontAwesomeIcons.minus),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      error: (error, stackTrace) => SliverToBoxAdapter(
        child: Container(
          height: 400,
          decoration: BoxDecoration(color: Colors.grey),
          child: Center(child: FaIcon(FontAwesomeIcons.circleXmark)),
        ),
      ),
      loading: () => SliverToBoxAdapter(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 400,
            decoration: BoxDecoration(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
