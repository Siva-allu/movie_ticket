import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final IP = '192.168.0.19:3000';
var currentUserContact;
var currentUserName;
var curentUserEmail;

class Utilities {



  loginUser(contact, password) async {
//print("coming to login");
    final credentials = {'contact': contact, 'password': password};

    final url = Uri.http(IP, '/loginUser', credentials);
    http.Response response = await http.get(url);
    var responseData = jsonDecode(response.body);
    if(responseData['message']=="success"){
      curentUserEmail=responseData["email"];
      currentUserContact=responseData["contact"];
      currentUserName=responseData["name"];
    }
    print("test ${responseData["contact"]}");
    print(currentUserContact);
    return responseData['message'];

  }

  loginAdmin(contact, password) async {
//print("coming to login");
    final credentials = {'contact': contact, 'password': password};

    final url = Uri.http(IP, '/loginAdmin', credentials);
    http.Response response = await http.get(url);
    var responseData = jsonDecode(response.body);
    //print(responseData);
    return responseData['message'];
  }

  bookTickets(movieId,contact,numberOfTickets) async {

    final sendData={
      "movie_id": movieId,
      "contact":contact,
      "number_of_tickets":numberOfTickets,
    };
    print(sendData);
    final url = Uri.http(IP, '/bookTickets', sendData);
    http.Response response = await http.get(url);
    var responseData = jsonDecode(response.body);
    print(responseData);
    return responseData['message'];

  }


  registerUser(name,password,email,contact) async {
    final userData = {
      'name':name,
      'password':password,
      'email':email,
      'contact':contact
    };
    final url = Uri.http(IP, '/signUp', userData);
    http.Response response = await http.get(url);
    var responseData = jsonDecode(response.body);
    return responseData['message'];
  }

  addTheatre(theatreName,theatreLocation) async {
    final sendData = {
      'theatre_name':theatreName,
      'theatre_location':theatreLocation
    };
    final url = Uri.http(IP, '/addTheatre', sendData);
    http.Response response = await http.get(url);
    var responseData = jsonDecode(response.body);
    return responseData["message"];
  }
  getMovies() async{
    final url = Uri.http(IP, '/getMovies');
    http.Response response = await http.get(url);
    var responseData = jsonDecode(response.body);
    return responseData;
  }

  getTheatreNames() async{
    final url = Uri.http(IP, '/getTheatre');
    http.Response response = await http.get(url);
    var responseData = jsonDecode(response.body);
    var responseDataList = [];
    for (var data in responseData) {
      responseDataList.add("${data['theatre_name']},${data['theatre_location']}");
    }
    return List<String>.from(responseDataList);
  }
  getTheatres() async{
    final url = Uri.http(IP, '/getTheatre');
    http.Response response = await http.get(url);
    var responseData = jsonDecode(response.body);
    return responseData;
  }

  getTheatreDetails(theatreId,theatreData){
    for(var i=0;i<theatreData.length;i++){
      if(theatreData[i]["theatre_id"]==theatreId){
        return theatreData[i]["theatre_name"]+","+theatreData[i]["theatre_location"];
      }
    }
  }

  getDate(date){
    return DateFormat('MMMM d, y','en_US').parse(date);

  }

  addMovie(movieName,movieTime,theatreName,theatreLocation) async{
    final sendData = {
      'movie_name':movieName,
      'movie_time':movieTime,
      'theatre_name':theatreName,
      'theatre_location':theatreLocation
    };
    final url = Uri.http(IP, '/addMovie', sendData);
    http.Response response = await http.get(url);
    var responseData = jsonDecode(response.body);
    return responseData["message"];

  }
  getPastBookings(contact) async{
    final sendData={
      'contact':contact,
    };
    final url = Uri.http(IP, '/getPastBookings',sendData);
    http.Response response = await http.get(url);
    var responseData = jsonDecode(response.body);
    return responseData;
  }

  getBookings() async{
    final url = Uri.http(IP, '/getBookings');
    http.Response response = await http.get(url);
    var responseData = jsonDecode(response.body);
    return responseData;
  }
  getMovieName(movieId,moviesData){
    for(var i=0;i<moviesData.length;i++){
      if(moviesData[i]["movie_id"]==movieId){
        return moviesData[i]["movie_name"];
      }
    }
  }
  getMovieDate(movieId,moviesData){
    for(var i=0;i<moviesData.length;i++){
      if(moviesData[i]["movie_id"]==movieId){
        return moviesData[i]["movie_time"].substring(0,10);
      }
    }
  }
  getMovieTime(movieId,moviesData){
    for(var i=0;i<moviesData.length;i++){
      if(moviesData[i]["movie_id"]==movieId){
        return moviesData[i]["movie_time"].substring(11,16);
      }
    }
  }
  getTheatreId(movieId,moviesData){
    for(var i=0;i<moviesData.length;i++){
      if(moviesData[i]["movie_id"]==movieId){
        return moviesData[i]["theatre_id"];
      }
    }
  }

}
