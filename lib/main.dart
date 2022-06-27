import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'constants.dart' as cols;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(
          title:
              'Choropleth Map of estimated South African emissions by ABSA-backed companies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ABSA-backed emissions'),
        ),
        body: _ChoroplethMap()
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class _ChoroplethMap extends StatefulWidget {
  @override
  __ChoroplethMapState createState() => __ChoroplethMapState();
}

class __ChoroplethMapState extends State<_ChoroplethMap> {
  late List<_ProvinceEmissionsModel> _emissionsDetails;
  late MapShapeSource _mapShapeSource;
  @override
  void initState() {
    super.initState();

    _emissionsDetails = <_ProvinceEmissionsModel>[
      _ProvinceEmissionsModel('Gauteng', 900),
      _ProvinceEmissionsModel('Limpopo', 300),
      _ProvinceEmissionsModel('Mpumalanga', 2300),
      _ProvinceEmissionsModel('Western Cape', 1203),
      _ProvinceEmissionsModel('Northern Cape', 4820),
      _ProvinceEmissionsModel('Eastern Cape', 3482),
      _ProvinceEmissionsModel('Kwa-Zulu Natal', 940),
      _ProvinceEmissionsModel('Free State', 3011),
      _ProvinceEmissionsModel('North-West', 3823),
    ];

    _mapShapeSource = MapShapeSource.asset(
      'za-provinces.topojson',
      shapeDataField: 'PROVINCES',
      dataCount: _emissionsDetails.length,
      primaryValueMapper: (int index) => _emissionsDetails[index].provinceName,
      shapeColorValueMapper: (int index) => _emissionsDetails[index].emissions,
      shapeColorMappers: [
        MapColorMapper(
            from: 0, to: 1000, color: cols.maps[0], text: '{0},{1000}'),
        MapColorMapper(
            from: 1000, to: 2000, color: cols.maps[1], text: '{1000},{2000}'),
        MapColorMapper(
            from: 2000, to: 3000, color: cols.maps[2], text: '{2000},{3000}'),
        MapColorMapper(
            from: 3000, to: 4000, color: cols.maps[3], text: '{3000},{4000}')
      ],
    );
  }

  @override
  void dispose() {
    _emissionsDetails.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Carbon Dioxide Emissions (metric tons)'),
        ),
        SfMaps(
          layers: [
            MapShapeLayer(
                source: _mapShapeSource,
                strokeColor: cols.oranges[1],
                legend: const MapLegend.bar(MapElement.shape,
                    position: MapLegendPosition.bottom,
                    segmentSize: Size(55.0, 9.0))),
          ],
        ),
      ],
    );
  }
}

class _ProvinceEmissionsModel {
  _ProvinceEmissionsModel(this.provinceName, this.emissions);
  final String provinceName;
  final double emissions;
}
