import 'package:flutter/material.dart';
import 'package:movie_ticket/pastbookings.dart';
import 'package:movie_ticket/ticketbooking.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);
  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {



    int index=0;
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: IndexedStack(
          index: index,
          children: [
            TicketBooking(),
            PastBookings(),
          ],
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
              icon: Icon(Icons.movie_creation),
              label: "Book Tickets",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "Past Bookings",
            ),
          ],
        ),
      );
    }
  }

