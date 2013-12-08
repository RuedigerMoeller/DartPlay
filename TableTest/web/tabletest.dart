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

  for ( var i = 0; i < 500; i++ ) {
    rltable.addRowAsMap({ "id":"$i", "text":"Dies ist ein text $i", "qty":"43.$i", "prc":"$i.$i"  });
  }

}
