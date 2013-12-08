import 'dart:html';
import 'reallive/RLTable.dart';


void main() {

  RLTable rltable = new RLTable("#table_id");
  
  TableElement table = rltable.table; // just for sample data
//  for ( var i = 0; i < 500; i++ ) {
//    var row = table.addRow();
//    row.attributes['t_id'] = '$i';
//
//    var cell = row.addCell();
//    cell.attributes['t_id'] = '$i';
//
//    String test = '$i';
//    cell.setInnerHtml( test );
//    
//    cell = row.addCell(); 
//    cell.attributes['t_id'] = '$i';
//    cell.setInnerHtml("Hallo " );
//
//    cell = row.addCell();
//    cell.attributes['t_id'] = '$i';
//    cell.setInnerHtml("longer pokiger text, oid asodi aosid hadsj qwjeq as " );
//
//    cell = row.addCell();
//    cell.attributes['t_id'] = '$i';
//    cell.setInnerHtml("<font color=red>99.34</font>" );
//
//    cell = row.addCell();
//    cell.attributes['t_id'] = '$i';
//    cell.setInnerHtml("<font color=green>99.34</font>" );
//  }
  
  List user = ["Reudi", "Emil", "Felix", "Anita", "Ex*"];

  for ( var i = 0; i < 100; i++ ) {
    Map mp = { 
               "id":i, "text":"Dies ist ein text $i", "Qty":i*10, "Price":(i/.34), "User":user[i%5],
               "NotSoShort":".","Langtext":"blubb blubb blubb blubb blubb blubb blubb blubb", 
               };
    if ( i == 1 ) {
      rltable.setHeaderFromList(mp.keys.toList(growable: false));
    }
    rltable.addRowAsMap(mp);
  }

}
