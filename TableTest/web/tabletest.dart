import 'dart:html';

var selectedIndex='-1';
TableElement table;

void main() {
  
  table = querySelector("#table_id");
  for ( var i = 0; i < 500; i++ ) {
    var row = table.addRow();
    row.attributes['t_id'] = '$i';

    var cell = row.addCell();
    cell.attributes['t_id'] = '$i';

    String test = '$i';
    cell.setInnerHtml( test );
    
    cell = row.addCell(); 
    cell.attributes['t_id'] = '$i';
    cell.setInnerHtml("Hallo " );

    cell = row.addCell();
    cell.attributes['t_id'] = '$i';
    cell.setInnerHtml("longer pokiger text, oid asodi aosid hadsj qwjeq as " );

    cell = row.addCell();
    cell.attributes['t_id'] = '$i';
    cell.setInnerHtml("<font color=red>99.34</font>" );

    cell = row.addCell();
    cell.attributes['t_id'] = '$i';
    cell.setInnerHtml("<font color=green>99.34</font>" );
  }
  
  table.onClick.listen( (event) {
      var clickedElement = event.target.attributes['t_id'];
      print( 'Clicked $clickedElement');
      changeSelection(clickedElement);
    } 
  );
  document.onKeyDown.listen( (event) 
    {
      if ( event.keyCode == 38 ) {
        // up
        num index = findIndex(selectedIndex);
        if ( index > 0 ) {
          TableRowElement curr = changeSelection(findRowId(index-1));
          if ( curr != null ) {
            scrollVisible(curr);
          }
        }
        event.preventDefault();
        event.stopImmediatePropagation();
      } else if ( event.keyCode == 40 ) {
        num index = findIndex(selectedIndex);
        TableRowElement curr = changeSelection(findRowId(index+1));
        if ( curr != null ) {
          scrollVisible(curr);
        }
        event.preventDefault();
        event.stopImmediatePropagation();
      } 
    }
  );
  
}

scrollVisible(TableRowElement cur) {
  cur.scrollIntoView(ScrollAlignment.CENTER);
}

String findRowId(int index) {
  var count = 0;
  for ( TableRowElement row in table.rows ) {
    if ( count == index )
      return row.attributes['t_id'];
    count++;
  }
  return '-1';
}

num findIndex(String id) {
  var count = 0;
  for ( TableRowElement row in table.rows ) {
    if ( row.attributes['t_id'] == id )
      return count;
    count++;
  }
  return -1;
}

TableRowElement findRow(String id) {
  for ( TableRowElement row in table.rows ) {
    if ( row.attributes['t_id'] == id ) {
      return row;
    }
  }
}

TableRowElement changeSelection( var newSel ) {
  TableRowElement current = findRow(selectedIndex );
  if ( current != null ) {
    current.attributes['BGCOLOR'] = "#ffffff";
  }
  if ( newSel == selectedIndex ) {
    selectedIndex = '-1';
    return null;
  }
  selectedIndex = newSel;
  current = findRow(newSel);
  if ( current != null ) {
    current.attributes['BGCOLOR'] = "#cfcfff";
  }
  return current;
}


