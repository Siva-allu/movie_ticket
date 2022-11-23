import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_ticket/utilities.dart';

import 'loginadmin.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {


  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [AddTheatre(), AddMovie(), Bookings()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int newindex) {
          setState(() {
            index = newindex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.theaters),
            label: "Theatres",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: "Movies",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Bookings",
          ),
        ],
      ),
    );
  }
}

class Bookings extends StatefulWidget {
  const Bookings({Key? key}) : super(key: key);

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  var bookings=[];
  var moviesData=[];
  var theatreData=[];

  getBookings() async {
    bookings=await Utilities().getBookings();
    moviesData=await Utilities().getMovies();
    theatreData=await Utilities().getTheatres();
    return true;

  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: getBookings(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return _mainWidget();
      } else {
        return _loading();
      }
    },
  );

  @override
  Widget _mainWidget(){
    return Scaffold(
        appBar: AppBar(
          title: Text("Bookings"),
          centerTitle: true,
          backgroundColor: Colors.red[900],
          actions: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginAdmin()));
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
                itemCount: bookings.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                  orientation == Orientation.portrait ? 1 : 3,
                  childAspectRatio: 3/1,
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
                              Text("${Utilities().getMovieName(bookings[index]["movie_id"], moviesData)}"),
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.01,
                              ),
                              Text("Contact Info: ${bookings[index]["contact"]}"),
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.01,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(Utilities().getTheatreDetails(Utilities().getTheatreId(bookings[index]["movie_id"], moviesData), theatreData)),

                                  Text("No of Tickets: ${bookings[index]["number_of_tickets"]}"),

                                ],
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.01,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Date: ${Utilities().getMovieDate(bookings[index]["movie_id"], moviesData)}"),
                                  Text("Time: ${Utilities().getMovieTime(bookings[index]["movie_id"], moviesData)}")
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







class AddMovie extends StatefulWidget {
  const AddMovie({Key? key}) : super(key: key);

  @override
  State<AddMovie> createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  var _formKey = GlobalKey<FormState>();
  final movieNameController = TextEditingController();
  final dateController = TextEditingController();
  final timeController= TextEditingController();
  var theatreName;
  var theatreData = [];

  getTheatreData() async {
    theatreData = await Utilities().getTheatreNames();
    return true;
  }
  _onSubmit() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    var theatreDetails = theatreName.split(",");
    var time  = dateController.text+" "+timeController.text+":00";
    var response = await Utilities().addMovie(movieNameController.text,time,theatreDetails[0],theatreDetails[1]);
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text("${response}"),
        ));
   _formKey.currentState?.reset();
   movieNameController.clear();
   theatreName=null;
  }

  Widget _mainWidget() {

    return Scaffold(
        appBar: AppBar(
          title: Text("Manage Movies"),
          backgroundColor: Colors.red[900],
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginAdmin()));
                },
                child: Icon(
                    Icons.logout
                ),
              ),
            )
          ],
        ),
        body: Align(
          alignment: Alignment(0, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.02,
                    ),
                    TextFormField(
                      controller: movieNameController,
                      decoration: InputDecoration(
                        labelText: 'Movie Name',
                        border: OutlineInputBorder(),

                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field must not be empty!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Theatre",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: DropdownButton(
                            value: theatreName,
                            items: theatreData.map((deptName) {
                              return DropdownMenuItem(
                                  child: Text(deptName), value: deptName);
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                theatreName = value;
                              });
                            }),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                    TextFormField(
                      controller: dateController,
                      decoration: InputDecoration(
                        labelText: 'Enter Date',
                        border: OutlineInputBorder(),
                        hintText: 'YYYY-MM-DD'
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field must not be empty!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                    TextFormField(
                      controller: timeController,
                      decoration: InputDecoration(
                          labelText: 'Enter Time',
                          border: OutlineInputBorder(),
                          hintText: 'HH:MM-24hr format',

                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field must not be empty!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red[900],
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _onSubmit();
                      }
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: getTheatreData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _mainWidget();
        } else {
          return _loading();
        }
      });

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

class AddTheatre extends StatefulWidget {
  const AddTheatre({Key? key}) : super(key: key);

  @override
  State<AddTheatre> createState() => _AddTheatreState();
}

class _AddTheatreState extends State<AddTheatre> {
  var _formKey = GlobalKey<FormState>();

  final theatreNameController = TextEditingController();
  final theatreLocationController = TextEditingController();

  _submit() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    var response = await Utilities()
        .addTheatre(theatreNameController.text, theatreLocationController.text);

    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: Text("${response}"),
            ));
    theatreNameController.clear();
    theatreLocationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Manage Theatres")),
          backgroundColor: Colors.red[900],
          actions: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginAdmin()));
                },
                child: Icon(
                    Icons.logout
                ),
              ),
            )
          ],
        ),
        //body
        body: Align(
            alignment: Alignment(0, 0),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    //form
                    child: Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.05,
                          ),
                          TextFormField(
                            controller: theatreNameController,
                            decoration: InputDecoration(
                              labelText: 'Theatre Name',
                              border: OutlineInputBorder(),
                            ),
                            onFieldSubmitted: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field must not be empty!';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.05,
                          ),
                          TextFormField(
                            controller: theatreLocationController,
                            decoration: InputDecoration(
                              labelText: 'Theatre Location',
                              border: OutlineInputBorder(),
                            ),
                            onFieldSubmitted: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field must not be empty!';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.1,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red[900],
                            ),
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () => _submit(),
                          )
                        ]))))));
  }
}
