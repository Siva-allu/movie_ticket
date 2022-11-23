import 'package:flutter/material.dart';
import 'package:movie_ticket/loginuser.dart';
import 'package:movie_ticket/utilities.dart';
import 'dart:async';

class TicketBooking extends StatefulWidget {
  const TicketBooking({Key? key}) : super(key: key);

  @override
  State<TicketBooking> createState() => _TicketBookingState();
}

class _TicketBookingState extends State<TicketBooking> {
  var moviesData = [];
  var theatreData=[];

 final ticketController=TextEditingController();
  getMovies() async {
    moviesData = await Utilities().getMovies();
    theatreData=await Utilities().getTheatres();

    return true;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: getMovies(),
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
          title: Text("Book Tickets"),
          backgroundColor: Colors.red[900],
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginUser()));
                },
                child: Icon(Icons.logout),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child:  OrientationBuilder(
              builder: (context,orientation){
                return GridView.builder(
                  itemCount: moviesData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                      (orientation == Orientation.portrait ? 1 : 3),
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
                                  child: Text("${moviesData[index]["movie_name"]}"),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                 Text(Utilities().getTheatreDetails(moviesData[index]["theatre_id"], theatreData)),

                                    Text("Seats Available: ${60 - moviesData[index]["tickets_sold"]}"),

                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.01,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Date: ${moviesData[index]["movie_time"].substring(0,10)}"),
                                    Text("Time: ${moviesData[index]["movie_time"].substring(11,16)}")
                                  ],
                                )

                              ],
                            ),

                          ),
                        ),


                      ),
                      onTap: (){
                        showDialog(context: context,
                            builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("Book Tickets"),
                            content: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                      child: Text("Movie: ${moviesData[index]["movie_name"]}")),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width * 0.02,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                      child: Text("Venue: ${Utilities().getTheatreDetails(moviesData[index]["theatre_id"], theatreData)}")),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width * 0.02,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                      child: Text("Seats Available: ${60 - moviesData[index]["tickets_sold"]}")),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width * 0.02,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Date: ${moviesData[index]["movie_time"].substring(0,10)}")),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width * 0.02,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                      child: Text("Time: ${moviesData[index]["movie_time"].substring(11,16)}")),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width * 0.02,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Number of Tickets",
                                      border: OutlineInputBorder()
                                    ),
                                    controller: ticketController,
                                  )
                                ],
                              ),
                            ),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 100.0),
                                child: Center(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red[900],
                                      ),
                                      child: Text(
                                        "Book Tickets",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: () async {
                                        if(int.parse(ticketController.text) > (60-moviesData[index]["tickets_sold"])){
                                          Navigator.of(context, rootNavigator: true).pop();
                                          showDialog(context: context, builder: (BuildContext context){
                                            return AlertDialog(
                                              content: Text("only ${60-moviesData[index]["tickets_sold"]} tickets Available"),
                                            );
                                          });
                                        }else{
                                          var response=await Utilities().bookTickets((moviesData[index]["movie_id"]).toString(),currentUserContact,ticketController.text);
                                          Navigator.of(context, rootNavigator: true).pop();
                                          showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                content: Text("${response}"),
                                              ));
                                          ticketController.clear();
                                          setState(() {});


                                        }
                                      }
                                  ),
                                ),
                              )
                            ],
                          );
                            }
                        );
                      },
                    );
                    }
                );}


        ))
    );
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
