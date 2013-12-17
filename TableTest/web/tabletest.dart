import 'dart:html';
import 'package:polymer/polymer.dart';
import 'reallive-table.dart';
import 'reallive-text.dart';
import 'dart:async';
import 'dart:math';

void main() {
  
  initPolymer();
  
  WebSocket ws = new WebSocket("ws://localhost:8089/"); 
  
  ws.onOpen.listen((T) {
    print(T);
    new Timer.periodic(new Duration(milliseconds: 2000), (t) { 
        ws.sendString("Hello from dart");
      } 
    );
  });
  
  ws.onMessage.listen((MessageEvent e) { 
    print("received:${e.data}"); } 
  );
  ws.onError.listen((e) { 
    print("error:$e"); } 
  );
  
  RLTable rltable = querySelector("#apptable").xtag;
  RLTable rltable1 = querySelector("#apptable1").xtag;
  RLTable rltable2 = querySelector("#apptable2").xtag;
  
  List<RLTable> tables = [rltable,rltable1,rltable2]; 
  
  TableElement table = rltable.table; // just for sample data
  TableElement table1 = rltable1.table; // just for sample data
  List user = ["Reudi", "Emil", "Felix", "Anita", "Ex*"];

  for ( var i = 0; i < 100; i++ ) {
    Map mp = { 
               "id":i, "text":"Dies ist ein text $i", "Qty":i*10, "Price":(i/.34), "User":user[i%5],
               "NotSoShort":".","Langtext":"blubb blubb blubb blubb blubb blubb blubb blubb", 
               };
    if ( i == 1 ) {
      tables.forEach((T) => T.setHeaderFromList(mp.keys.toList(growable: false)));
    }
    tables.forEach((T) => T.addRowAsMap(mp) );
  }
  var rnd = new Random();
  new Timer.periodic(new Duration(milliseconds: 50), (t) { 
      tables.forEach((T) => T.updateRow("${rnd.nextInt(100)}", { "Qty":rnd.nextInt(100) }));
    } 
  );
    
}