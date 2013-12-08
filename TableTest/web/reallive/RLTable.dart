import 'dart:html';

class RLTable {

  static var selectedStyle = "border:2px solid black; background-color:#00c0Ff;";
  static var caretStyleNoBG = "outline: 1px dashed black;";
  static var caretStyle = "outline: 1px dashed black; background-color:rgba(100%,100%,100%,0.7);";
  static var selectedCaretStyle = selectedStyle+" "+caretStyleNoBG;
  static var defaultStyle = "";
  
  var selectedRowId='-1';
  TableElement table;
  num rowIdCnt = 1;
  RLTableRowRenderer rowRenderer = new RLTableRowRenderer();
  RLValueRenderer cellRenderer = new RLValueRenderer();
  RLTableRenderSpec renderStyle = new DefaultRenderSpec();
  HtmlElement pane;
  Map selectedRows = new Map();

  bool singleSel = true;
  
  RLTable(String id) {
    table = querySelector(id);
    pane = querySelector(id+"-pane");
    table.onClick.listen( (event) {
        var clickedElement = event.target.attributes['t_id'];
        changeCaret(clickedElement);
        changeSelection(clickedElement, ! isSelected(clickedElement) );
      } 
    );
    document.onKeyDown.listen( (event) {     
      switch( event.keyCode ) {
        case 13: 
        case 32: 
        {
          changeSelection(selectedRowId, ! isSelected(selectedRowId) );
          event.preventDefault();
          event.stopImmediatePropagation();
        }
        break;
        case 38: 
        {
          // up
          num index = findIndex(selectedRowId);
          if ( index > 0 ) {
            TableRowElement curr = changeCaret(findRowId(index-1));
            if ( curr != null ) {
              scrollVisible(curr);
            }
          }
          event.preventDefault();
          event.stopImmediatePropagation();
        }
        break;
        case 40:  
        { // down
          num index = findIndex(selectedRowId);
          TableRowElement curr = changeCaret(findRowId(index+1));
          if ( curr != null ) {
            scrollVisible(curr);
          }
          event.preventDefault();
          event.stopImmediatePropagation();
        } 
      }
    });
  }
  
  scrollVisible(TableRowElement cur) {
    var x = cur.borderEdge;
    var paneRect = pane.borderEdge;
    var st = pane.scrollTop;
    if ( x.top < paneRect.top )
      pane.scrollTop = (pane.scrollTop - (paneRect.top-x.top)-4).toInt();
    else if ( x.top+x.height > paneRect.top+paneRect.height-16 )
      pane.scrollTop = (4+pane.scrollTop - ((paneRect.top+paneRect.height-16)-(x.top+x.height))).toInt();
    bool visible = x.top > paneRect.top && x.top+x.height < paneRect.top+paneRect.height;
    print("${x.top} ${paneRect.top} $visible $st");
//    cur.scrollIntoView(ScrollAlignment.CENTER);
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

  bool isSelected(String rowId) => selectedRows[rowId] != null;
  
  clearSelection() {
    selectedRows.keys.forEach((r) => changeSelection(r, false) );
  }
  
  TableRowElement changeSelection( String rowId, bool sel ) {
    if ( sel )
      clearSelection();
    TableRowElement current;
    if ( selectedRows[rowId] == null && sel) {
      // select
      selectedRows[rowId] = true;
      current = findRow(rowId );
      if ( current != null ) {
        current.attributes['style'] = rowId == selectedRowId ? selectedCaretStyle : selectedStyle;
      }
    }
    if ( selectedRows[rowId] != null && !sel) {
      selectedRows[rowId] = null;
      // deselect
      current = findRow(rowId );
      if ( current != null ) {
        current.attributes['style'] = rowId == selectedRowId ? caretStyle : defaultStyle;
      }
    }
    return current;
  }
  
  
  TableRowElement changeCaret( String newSel ) {
    TableRowElement current = findRow(selectedRowId );
    if ( current != null ) {
      current.attributes['style'] = isSelected(selectedRowId) ? selectedStyle : defaultStyle;
    }
    if ( newSel == selectedRowId ) {
      selectedRowId = '-1';
      return null;
    }
    selectedRowId = newSel;
    current = findRow(newSel);
    if ( current != null ) {
      var sel = isSelected(newSel);
      current.attributes['style'] = sel ? selectedCaretStyle : caretStyle;
    }
    return current;
  }
  
  String createRowId() {
    rowIdCnt++;
    return '$rowIdCnt';
  }
  
  addRow(RLTableRowData data) {
    TableRowElement newRow = table.addRow();
    var id = createRowId(); newRow.attributes['t_id'] = id;
    rowRenderer.renderRow(id, newRow, data, renderStyle);
  }
  
  addRowAsMap(Map data) {
    TableRowElement newRow = table.addRow();
    var id = createRowId(); newRow.attributes['t_id'] = id;
    rowRenderer.renderRow(id, newRow, new RowMapAdapter(data, -1), renderStyle);
  }

}

abstract class RLTableRenderSpec {
  List<String> getFieldNames(RLTableRowData row);
  RLValueRenderer getRendererFor(String field, RLTableRowData row);
  
  String getHeaderVale(String f) {
    return f;
  }
}

class DefaultRenderSpec extends RLTableRenderSpec {
  RLValueRenderer defValRend = new RLValueRenderer();
  
  List<String> getFieldNames(RLTableRowData row) {
    return row.getFieldNames();
  }
  
  RLValueRenderer getRendererFor(String field, RLTableRowData row) {
    return defValRend;  
  }
  
}

abstract class RLTableRowData {
  List<String> getFieldNames();
  dynamic getValue( String fieldName );
  num getId();  
}

class RowMapAdapter extends RLTableRowData {
  Map data;
  num rowId;
  
  RowMapAdapter(this.data,this.rowId);
  
  List<String> getFieldNames() => new List.from(data.keys);
  dynamic getValue( String fieldName ) => data[fieldName];
  num getId() => rowId;  
  
}

class RLValueRenderer {
  String renderValue( var value ) {
    return '$value';
  }
}


class RLTableRowRenderer {
  
  renderHeader( String rowId, TableRowElement target, RLTableRowData row, RLTableRenderSpec style ) {
    style.getFieldNames(row).forEach( 
        (f) {
          var value = row.getValue(f);
          String val = style.getHeaderVale(f);
          TableCellElement cell = target.addCell();
          cell.attributes['t_id'] = rowId;
          cell.setInnerHtml(val);
        } 
    );
  }

  renderRow( String rowId, TableRowElement target, RLTableRowData row, RLTableRenderSpec style ) {    
    style.getFieldNames(row).forEach( 
        (f) {
          var value = row.getValue(f);
          String val = style.getRendererFor(f,row).renderValue(value);
          TableCellElement cell = target.addCell();
          cell.attributes['t_id'] = rowId;
          cell.setInnerHtml(val);
        } 
    );
  }
  
}