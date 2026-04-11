import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(24.7136, 46.6753),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(24.7136, 46.6753),
                    width: 50,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.recycling, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            top: 10,
            left: 10,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              mini: true,
              onPressed: () {},
              child: Icon(Icons.tune),
            ),
          ),
          Positioned(
            top: 15,
            left: 140,
            child: Text(
              "خريطه المراكز",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          Positioned(
            top: 10,
            left: 350,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              mini: true,
              onPressed: () {},
              child: Icon(Icons.search),
            ),
          ),
          Positioned(
            left: 15,
            top: 250,
            child: Column(
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.white,

                  mini: true,
                  onPressed: () {},
                  child: Icon(Icons.add),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  mini: true,
                  onPressed: () {},
                  child: Icon(Icons.remove),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  mini: true,
                  onPressed: () {},
                  child: Icon(Icons.location_on),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Row(
                children: [
                  // صورة
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                  ),
                  Spacer(),

                  // النصوص
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "إيكوهوب داون تاون",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("بلاستيك، ورق، معدن"),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  " المسافه",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("1.2 كم"),
                              ],
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: [
                                Text(
                                  "ساعات العمل",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("08:00 ص"),
                                Text("09:00 م"),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "الحصول علي الاتجاهات",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.navigation_outlined),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
