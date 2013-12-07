import 'dart:html';

class RLTable {

  static var caretStyle = "border-left-width:2.5em; border-left-style:solid; border-color:red;";
  static var defaultStyle = "";
  
  var selectedRowId='-1';
  TableElement table;
  num rowIdCnt = 1;

  RLTable(String id) {
    table = querySelector(id);
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
          num index = findIndex(selectedRowId);
          if ( index > 0 ) {
            TableRowElement curr = changeSelection(findRowId(index-1));
            if ( curr != null ) {
              scrollVisible(curr);
            }
          }
          event.preventDefault();
          event.stopImmediatePropagation();
        } else if ( event.keyCode == 40 ) { // down
          num index = findIndex(selectedRowId);
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
    TableRowElement current = findRow(selectedRowId );
    if ( current != null ) {
      current.attributes['style'] = defaultStyle;
    }
    if ( newSel == selectedRowId ) {
      selectedRowId = '-1';
      return null;
    }
    selectedRowId = newSel;
    current = findRow(newSel);
    if ( current != null ) {
      current.attributes['style'] = caretStyle;
    }
    return current;
  }
  
}