var express = require('express');
var router = express.Router();
const { Client } = require('pg')
const cors = require("cors");
router.use(cors());

var conString = "pg://heoyctilsmujgc:42fdc36a146ffe7214512a7836029e04658b5172a81a906814f1833d3847d59b@ec2-3-219-135-162.compute-1.amazonaws.com:5432/dbnikrk54l0k73?sslmode=true"
const client = new Client({
  user: 'heoyctilsmujgc',
  host: 'ec2-3-219-135-162.compute-1.amazonaws.com',
  database: 'dbnikrk54l0k73',
  password: '42fdc36a146ffe7214512a7836029e04658b5172a81a906814f1833d3847d59b',
  port: 5432,
  ssl: {
    rejectUnauthorized: false,
  },
})
client.connect(function (err) {
  if (err) throw err;
  console.log("Database Connected!");
});

router.get('/loginUser', async function (req, res) {
  const { contact, password } = req.query;
  try {
    const data = await client.query(`SELECT * FROM users WHERE contact= $1;`, [contact])
    const user = data.rows;
    //console.log(user);
    if (user.length == 0) {
      res.status(400).json({
        message: "User is not registered, Sign Up first",
      });
    }
    else {
      if (password == user[0].password) {
        user[0].message ='success';
        //console.log(user);
        res.header('Cache-Control', 'no-cache, private, no-store, must-revalidate, max-stale=0, post-check=0, pre-check=0');
        res.status(200).json(user[0]);
      }
      else {
        res.status(400).json({
          message: "Enter Correct Password"
        });
      }
    }
  } catch (err) {
    console.log(err);
    res.status(500).json({
      message: "Database error occurred while signing in!", //Database connection error
    });
  };
});

router.get('/loginAdmin', async function (req, res) {
  const { contact, password } = req.query;
  try {
    const data = await client.query(`SELECT * FROM employees WHERE contact= $1;`, [contact])
    const user = data.rows;
    if (user.length == 0) {
      res.status(400).json({
        message: "Admin is not registered",
      });
    }
    else {
      if (password == user[0].password) {
        user[0].message ='success';
        res.header('Cache-Control', 'no-cache, private, no-store, must-revalidate, max-stale=0, post-check=0, pre-check=0');
        res.status(200).json(user[0]);
      }
      else {
        res.status(400).json({
          message: "Enter Correct Password"
        });
      }
    }
  } catch (err) {
    console.log(err);
    res.status(500).json({
      message: "Database error occurred while signing in!", //Database connection error
    });
  };
});

router.get('/addTheatre', async function (req, res) {
  var { theatre_name,theatre_location } = req.query;
  theatre_location=theatre_location.toLowerCase();
  theatre_name=theatre_name.toLowerCase();
  //console.log(username);
  try {
    const check = await client.query(`select * from theatres where theatre_name=$1 and theatre_location=$2;`,[theatre_name,theatre_location]);
    const flag = check.rows;
    if(flag.length !=0){
      res.status(200).send({
        message:"Theatre Already Exists"
      })
    }
    else{
    const result = await client.query(`insert into theatres(theatre_name,theatre_location) values($1,$2);`, [theatre_name,theatre_location]);
    res.status(200).send({
      message:"Theatre Sucessfully Added"
    })}
  } catch (err) {
    //console.log(err);
    res.status(500).json({
      message: "Database error ", //Database connection error
    });
  };
});

router.get('/addMovie', async function (req, res) {
  var { movie_name,movie_time,theatre_name,theatre_location } = req.query;
  theatre_location=theatre_location.toLowerCase();
  theatre_name=theatre_name.toLowerCase();
  try {
   
    const theatre_id_data = await client.query(`select theatre_id from theatres where theatre_name=$1 and theatre_location=$2;`,[theatre_name,theatre_location]);
    const theatre_id=theatre_id_data.rows[0]["theatre_id"];
   //console.log(theatre_id);
    const result = await client.query(`insert into movies(movie_name,movie_time,tickets_sold,theatre_id) values($1,$2,0,$3);`, [movie_name,movie_time,theatre_id]);
    res.status(200).send({
      message:"Show Successfully Added"
    })
  } catch (err) {
    console.log(err);
    res.status(500).json({
      message: "Database error ", //Database connection error
    });
  };
});

router.get('/signUp', async function (req, res) {
  var { name,email,password,contact } = req.query;
  name=name.toLowerCase();
  email=email.toLowerCase();
  try {
    const check = await client.query(`select * from users where contact = $1;`,[contact]);
    const flag = check.rows;
    if(flag.length!=0){
      res.status(200).send({
        message:"User Already Exists."
      })
    }
else
{
    const result = await client.query(`insert into users(name,password,email,contact) values($1,$2,$3,$4);`, [name,password,email,contact]);
    res.status(200).send({
      message:"User Successfully Created."
    })}
  } catch (err) {
    //console.log(err);
    res.status(500).json({
      message: "Database error ", //Database connection error
    });
  };
});

router.get('/getMovies', async function (req, res) {
  try {
    const result = await client.query(`select * from movies;`);
    res.header('Cache-Control', 'no-cache, private, no-store, must-revalidate, max-stale=0, post-check=0, pre-check=0');
    res.status(200).send(result.rows)
  } catch (err) {
    
    res.status(500).json({
      message: "Database error ", //Database connection error
    });
  };
});

router.get('/getTheatre', async function (req, res) {
  try {
    const result = await client.query(`select * from theatres;`);
    res.header('Cache-Control', 'no-cache, private, no-store, must-revalidate, max-stale=0, post-check=0, pre-check=0');
    res.status(200).send(result.rows)
  } catch (err) {
    //console.log(err);
    res.status(500).json({
      message: "Database error ", //Database connection error
    });
  };
});

router.get('/bookTickets', async function (req, res) {
  var {movie_id,contact,number_of_tickets}=req.query
 
  try {
    const current_tickets_query = await client.query(`select tickets_sold from movies where movie_id=$1;`,[movie_id]);
    var current_tickets_data = current_tickets_query.rows
    var current_tickets = Number(current_tickets_data[0]["tickets_sold"])+Number(number_of_tickets);
    const result = await client.query(`insert into booking(movie_id,contact,number_of_tickets) values($1,$2,$3);`,[movie_id,contact,number_of_tickets]);
    const updateTickets = await client.query('update movies set tickets_sold=$1 where movie_id=$2;',[current_tickets,movie_id]);
    res.header('Cache-Control', 'no-cache, private, no-store, must-revalidate, max-stale=0, post-check=0, pre-check=0');
    res.status(200).send({
    message:"Successfully Booked Tickets"
    })
  } catch (err) {
    console.log(err);
    res.status(500).json({
      message: "Database error ", //Database connection error
    });
  };
});

router.get('/getBookings', async function (req, res) {
  try {
    const result = await client.query(`select * from booking;`);
    res.header('Cache-Control', 'no-cache, private, no-store, must-revalidate, max-stale=0, post-check=0, pre-check=0');
    res.status(200).send(result.rows)
  } catch (err) {
    //console.log(err);
    res.status(500).json({
      message: "Database error ", //Database connection error
    });
  };
});

router.get('/getPastBookings', async function (req, res) {
  var {contact}=req.query;
  //console.log(contact);
  try {
    const result = await client.query(`select * from booking where contact=$1`,[contact]);
    //console.log(result);
    res.header('Cache-Control', 'no-cache, private, no-store, must-revalidate, max-stale=0, post-check=0, pre-check=0');
    res.status(200).send(result.rows)
  } catch (err) {
    //console.log(err);
    res.status(500).json({
      message: "Database error ", //Database connection error
    });
  };
});


module.exports = router;
