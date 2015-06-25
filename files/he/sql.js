var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database('sqlpro33.db');
 
db.serialize(function() {
  
  
  var stmt = db.prepare("INSERT INTO Chats VALUES (?,?,?)");
  db.run("CREATE TABLE if not exists Chats (name INTEGER, status INTEGER, online INTEGER)");
  db.run(stmt, [1,2,3]);
  
  
  
  
  
  /*db.run("CREATE TABLE if not exists Chats (name TEXT, status TEXT, online INTEGER)");
  db.run("CREATE TABLE if not exists Kids (name TEXT)");

  var stmt = db.prepare("INSERT INTO Chats VALUES (?,?,?)");
  runMany(stmt, ["hello","kids",12]);
  stmt.finalize();
  
  
  var stmt2 = db.prepare("INSERT INTO Chats VALUES (?,?,?)");
  runMany(stmt2, ["1","2",3]);
  stmt2.finalize();
  
  
  var stmt3 = db.prepare("INSERT INTO Kids VALUES (?, ?, ?)");
  stmt3.run("Hello");
  stmt3.run("sir");
  stmt3.run("3");
 
  stmt3.finalize();

  /*sqlite3.Database.Statement.prototype.runMany = function() {
 		
 		for(var i = 0; i < arguments.length; i++) {
  			this.run(arguments[i]);
		}
	 
	 
	};*/
	
	function runMany(stmt, vals){
	
		for (var i = 0;i < vals.length;i++){
			stmt.run(vals[i]);
		}

	
	}
    


  
});
 
db.close();