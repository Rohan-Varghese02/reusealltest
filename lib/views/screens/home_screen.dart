import 'package:flutter/material.dart';
import 'package:pickup_app/data/dummydata.dart';
import 'package:pickup_app/views/screens/map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Dummydata data = Dummydata();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        centerTitle: true,
        leading: SizedBox(),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          final pickup = data.pickups[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                  pickup["id"].toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text("Time Slot: ${pickup["time_slot"]}"),
              subtitle: Text(
                "Lat: ${pickup["lat"]}, Lon: ${pickup["lon"]}\nInventory: ${pickup["inventory"]}",
              ),
              trailing: Icon(Icons.location_on, color: Colors.redAccent),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: data.pickups.length,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Start Job'),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => MapScreen()));
        },
      ),
    );
  }
}
