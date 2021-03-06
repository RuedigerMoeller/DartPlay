import 'dart:html';
import 'package:polymer/polymer.dart';
import 'reallive-table.dart';
import 'reallive-text.dart';
import 'reallive-login.dart';
import 'dson/dson.dart';
import 'protocol/RealLive.dart';
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'reallive-util.dart';

void main() {
  
  initPolymer();
  // init communication
  DSON.classFactory = new RealLiveFactory();  
  DsonWebSocket socket = new DsonWebSocket("ws://localhost:8089/"); 

  RLTable rltable = querySelector("#apptable").xtag;
  rltable.spaneHeight = (window.innerHeight-100).toString()+"px";

  // server induced messages
  socket.onMessage = (msg) {
    //print( "message" + msg.toString() );
  };
  socket.onLogin = () {
        
//    """
//      Query: 'sys.User' having: 
//        field: 'uid' equals: 'a';
//        subscribe
//      ;
//    """;
    rltable.queryText.value =
      "Query: 'sys.User' subscribe;"
    ;

  };
     
  
  
//  List<RLTable> tables = [rltable]; 
//  
//  TableElement table = rltable.table; // just for sample data
//  List user = ["Reudi", "Emil", "Felix", "Anita", "Ex*"];
//
//  for ( var i = 0; i < 100; i++ ) {
//    Map mp = { 
//               "id":i, "text":"Dies ist ein text $i", "Qty":i*10, "Price":(i/.34), "User":user[i%5],
//               "NotSoShort":".","Langtext":"blubb blubb blubb blubb blubb blubb blubb blubb", 
//               };
//    if ( i == 1 ) {
//      tables.forEach((T) => T.setHeaderFromList(mp.keys.toList(growable: false)));
//    }
//    tables.forEach((T) => T.addRowAsMap(mp) );
//  }
//  var rnd = new Random();
//  new Timer.periodic(new Duration(milliseconds: 50), (t) { 
//      tables.forEach((T) => T.updateRow("${rnd.nextInt(100)}", { "Qty":rnd.nextInt(100) }));
//    } 
//  );
    
}