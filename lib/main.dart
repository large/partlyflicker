import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

//Create chartwidget
Widget createChart(BuildContext context) {
  /////
  // Textstyles
  TextStyle? horizontalSideTitle = Theme.of(context)
      .textTheme
      .bodyMedium
      ?.copyWith(fontSize: 12, color: Colors.red);
  TextStyle? verticalSideTitle = Theme.of(context)
      .textTheme
      .bodyMedium
      ?.copyWith(fontSize: 12, color: Colors.yellow);
  TextStyle? averagePriceTitle = Theme.of(context)
      .textTheme
      .bodySmall
      ?.copyWith(color: Theme.of(context).colorScheme.primary, fontSize: 14);

  var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

  //Return the actual card
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    color: Theme.of(context).bottomAppBarTheme.color,
    child: Padding(
      padding: const EdgeInsets.only(top: 100),
      child: BarChart(
        BarChartData(
          rangeAnnotations: RangeAnnotations(),
          alignment: BarChartAlignment.center,
          titlesData: FlTitlesData(
            show: true,
          ),
          gridData: FlGridData(
            show: true,
          ),
          borderData: FlBorderData(
            show: true,
          ),
          groupsSpace: 1,
          barGroups: chartSpotprices(),
          minY: -20,
          maxY: 20,
        ),
        swapAnimationDuration: const Duration(milliseconds: 1110),
        //swapAnimationCurve: Curves.easeInOutCubicEmphasized,
        swapAnimationCurve: Curves.ease,
      ),
    ),
  );
}

List<BarChartGroupData>? chartSpotprices() {
  //Create empty list
  List<BarChartGroupData> charts =
      List<BarChartGroupData>.empty(growable: true);

  List<int> spot = [-3, 1, 7, 3, -10, -1, -5, -10, 10, 20];
  var rng = Random();

  int counter = 0;
  for (int i in spot) {
    //Add item to the list
    var item = BarChartGroupData(x: charts.length, barsSpace: 0, barRods: [
      BarChartRodData(
        //toY: (maxPrice + maxVAT) * cM() + cM()/100,
        fromY: 0,
        toY: i.toDouble(),
        //spot[rng.nextInt(spot.length)].toDouble(),
        width: 20,
        color: Colors.brown,
        rodStackItems: [
          BarChartRodStackItem(0, 0, Colors.green),
        ],
        borderRadius: BorderRadius.circular(4),
      ),
    ]);

    //Loop through all costs
    for (int stack = 0; stack < 4; stack++) {
      double startPoint = item.barRods.last.rodStackItems.last.toY;
      double add = i / 3;
      item.barRods.last.rodStackItems.add(BarChartRodStackItem(startPoint,
          startPoint + add, stack.isEven ? Colors.cyan : Colors.red));
    }

    charts.add(item);
  }

  return charts;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Future<bool> doNothing() async {
    debugPrint("Did nothing...");
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
            future: doNothing(),
            builder: (context, snap) {
              debugPrint("snap state ${snap.connectionState}");
              return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: createChart(context));
              });
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
