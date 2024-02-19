import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Position? position;
  final Set<Marker> _markers = {};

  final locations = {
    "Centro Espírita Caridade e Resignação":
        const LatLng(-3.1144771156097053, -60.02997203868414),
    "Lar da Criança do GACC-Grupo Apoio Criança com Câncer":
        const LatLng(-3.094155770027813, -60.04020649456324),
    "Casa Vhida - Associação de Apoio à Criança com HIV":
        const LatLng(-3.087556421284115, -60.04046398662465),
    "Abrigo Moacyr Alves": const LatLng(-3.075268238692668, -60.036378122133236)
  };

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissons are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition();

    if (mounted) {
      setState(() {});
    }

    return position!;
  }

  @override
  void initState() {
    _determinePosition();
    locations.forEach((key, value) {
      _markers
          .add(Marker(markerId: MarkerId(key), position: value, onTap: () {}));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        markers: _markers,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
            target: LatLng(
                position?.latitude ?? -3.0858, position?.longitude ?? -60.0219),
            zoom: 14.0));
  }
}
