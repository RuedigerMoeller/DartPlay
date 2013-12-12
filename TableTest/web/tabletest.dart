import 'dart:html';
import 'package:polymer/polymer.dart';
import 'reallive-table.dart';
import 'reallive-text.dart';
import 'dart:async';
import 'dart:math';

void main() {
  initPolymer();
  
  RLTable rltable = querySelector("#apptable").xtag;
  RLTable rltable1 = querySelector("#apptable1").xtag;
  
  TableElement table = rltable.table; // just for sample data
  TableElement table1 = rltable1.table; // just for sample data
  List user = ["Reudi", "Emil", "Felix", "Anita", "Ex*"];

  for ( var i = 0; i < 100; i++ ) {
    Map mp = { 
               "id":i, "text":"Dies ist ein text $i", "Qty":i*10, "Price":(i/.34), "User":user[i%5],
               "NotSoShort":".","Langtext":"blubb blubb blubb blubb blubb blubb blubb blubb", 
               };
    if ( i == 1 ) {
      rltable.setHeaderFromList(mp.keys.toList(growable: false));
      rltable1.setHeaderFromList(mp.keys.toList(growable: false));
    }
    rltable.addRowAsMap(mp);
    rltable1.addRowAsMap(mp);
  }
  var rnd = new Random();
  new Timer.periodic(new Duration(milliseconds: 50), (t) { 
    rltable.updateRow("${rnd.nextInt(100)}", { "Qty":rnd.nextInt(100) }); 
    rltable1.updateRow("${rnd.nextInt(100)}", { "Qty":rnd.nextInt(100) }); 
    } 
  );
  
  new Timer.periodic(new Duration(milliseconds: 50), (t) { 
    rltable.updateRow("${rnd.nextInt(100)}", { "Price":rnd.nextInt(10000)/100 }); 
    rltable1.updateRow("${rnd.nextInt(100)}", { "Price":rnd.nextInt(10000)/100 }); 
    } 
  );
  
}