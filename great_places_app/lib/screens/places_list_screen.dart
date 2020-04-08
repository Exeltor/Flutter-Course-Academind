import 'package:flutter/material.dart';
import 'package:great_places_app/screens/place_detail_screen.dart';
import '../providers/great_places.dart';
import 'package:provider/provider.dart';
import '../screens/add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<GreatPlaces>(
                child: Center(
                  child: const Text(
                    'Got no places yet, start adding some!',
                  ),
                ),
                builder: (context, places, child) => places.items.length <= 0
                    ? child
                    : ListView.builder(
                        itemCount: places.items.length,
                        itemBuilder: (context, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: FileImage(places.items[i].image),
                          ),
                          title: Text(places.items[i].title),
                          subtitle: Text(places.items[i].location.address),
                          onTap: () {
                            Navigator.of(context).pushNamed(PlaceDetailScreen.routeName, arguments: places.items[i].id);
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}
