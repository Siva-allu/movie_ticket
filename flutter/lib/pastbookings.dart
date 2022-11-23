import 'package:flutter/material.dart';
import 'package:movie_ticket/utilities.dart';

import 'loginuser.dart';

class PastBookings extends StatefulWidget {
  const PastBookings({Key? key}) : super(key: key);

  @override
  State<PastBookings> createState() => _PastBookingsState();
}

class _PastBookingsState extends State<PastBookings> {
  var pastBookingsData=[];
  var moviesData=[];
  var theatreData=[];
  getPastBookings() async {
    pastBookingsData=await Utilities().getPastBookings(currentUserContact);
    moviesData=await Utilities().getMovies();

    theatreData=await Utilities().getTheatres();
    print(pastBookingsData);
    return true;

  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: getPastBookings(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return _mainWidget();
      } else {
        return _loading();
      }
    },
  );


  @override
  Widget _mainWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Past Bookings"),
        centerTitle: true,
        backgroundColor: Colors.red[900],
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginUser()));
              },
              child: Icon(
                  Icons.logout
              ),
            ),
          )
        ],
      ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: OrientationBuilder(
            builder: (context, orientation) {
              return GridView.builder(
                itemCount: pastBookingsData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                  orientation == Orientation.portrait ? 1 : 3,
                  childAspectRatio: 4/1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    child: Card(
                      elevation: 2.0,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${Utilities().getMovieName(pastBookingsData[index]["movie_id"], moviesData)}"),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(Utilities().getTheatreDetails(Utilities().getTheatreId(pastBookingsData[index]["movie_id"], moviesData), theatreData)),

                                  Text("No of Tickets: ${pastBookingsData[index]["number_of_tickets"]}"),

                                ],
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.01,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Date: ${Utilities().getMovieDate(pastBookingsData[index]["movie_id"], moviesData)}"),
                                  Text("Time: ${Utilities().getMovieTime(pastBookingsData[index]["movie_id"], moviesData)}")
                                ],
                              )

                            ],
                          ),

                        ),
                      ),


                    ),
                  );
                },
              );
            },
          ),
        ));

  }

  @override
  Widget _loading() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )),
    );
  }
}
