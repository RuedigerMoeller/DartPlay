import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'reallive-util.dart';

@CustomTag('reallive-table')
class RLTable extends PolymerElement {

  @published int spaneWidth = 400;
  @published int spaneHeight = 400;
  @published String overflowX = "scroll";
  
  static var selectedStyle = "background-color:#008DCC; color:#fff;";
  static var caretStyleNoBG = "outline: 1px dashed black;";
  static var caretStyle = "outline: 1px dashed black; background-color:rgba(100%,100%,100%,0.7);";
  static var selectedCaretStyle = selectedStyle+" "+caretStyleNoBG;
  static var defaultStyle = "";
  
  var selectedRowId='-1';
  TableElement table;
  TableElement tableHeader;
  num rowIdCnt = 1;
  RLTableRowRenderer headerRenderer = new RLTableHeaderRowRenderer(); // def
  RLTableRowRenderer rowRenderer = new RLTableRowRenderer(); // def
  RLValueRenderer defValRend = new RLValueRenderer();
  RLTableRenderSpec renderStyle;

  HtmlElement pane, headerPane;
  TextInputElement focusHidden;
  Map selectedRows = new Map();
  Map<String,RLDataRow> rows = new Map();

  bool singleSel = true;
  bool upDown = true;
  
  var onSelection;

  RLTable.created() : super.created() {
  }

  void enteredView() {
    init();
  }

  init() { 
    focusHidden = shadowRoot.querySelector("#keys");
    table = shadowRoot.querySelector("#table");
    pane = shadowRoot.querySelector("#pane");
    headerPane = shadowRoot.querySelector("#header-pane");
    tableHeader = shadowRoot.querySelector("#header");
    renderStyle = new DefaultRenderSpec(defValRend);
    if ( table == null )
      return;

    adjustTWidth();
    
    window.onResize.listen( (ev) { 
        adjustColWidthFromHeader(); 
      } 
    );
    
    pane.onScroll.listen((event) {
      headerPane.scrollLeft = pane.scrollLeft;
    } 
    );
    
    tableHeader.onClick.listen((E) {
      var clickedField = E.target.attributes['t_field'];
      sort(clickedField, upDown);
      upDown = ! upDown;
    });
    
    table.onClick.listen( (event) {
        focusHidden.focus();
        var clickedElement = event.target.attributes['t_id'];
        changeCaret(clickedElement);
        changeSelection(clickedElement, ! isSelected(clickedElement) );
      } 
    );
    
    table.onDoubleClick.listen( (event) {
        var row = event.target.attributes['t_id'];
        updateRow(row, { "Qty":"99", "Price":"2.01" } );
      } 
    );

    document.onKeyDown.listen( (event) {
      if ( 
           document.activeElement != focusHidden &&
           document.activeElement != this
          )
        return;
      switch( event.keyCode ) {
        case 13: 
//        case 32: 
        {
          selectKeyTriggered(event);
        }
        break;
        case 38: 
        {
          // up
          upKeyTriggered(event);
        }
        break;
        case 40:  
        { // down
          downKeyTriggered(event);
        } 
      }
    });
  }
  
  downKeyTriggered(KeyboardEvent event) {
    num index = findIndex(selectedRowId);
    TableRowElement curr = changeCaret(findRowId(index+1));
    if ( curr != null ) {
      scrollVisible(curr);
    }
    event.preventDefault();
    event.stopImmediatePropagation();    
  }
  
  upKeyTriggered(KeyboardEvent event) {
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

  selectKeyTriggered(KeyboardEvent event) {
    changeSelection(selectedRowId, ! isSelected(selectedRowId) );
    event.preventDefault();
    event.stopImmediatePropagation();    
  }
  
  scrollVisible(TableRowElement cur) {
    var x = cur.borderEdge;
    var paneRect = pane.borderEdge;
    var st = pane.scrollTop;
    if ( x.top < paneRect.top )
      pane.scrollTop = (pane.scrollTop - (paneRect.top-x.top)-4).toInt();
    else if ( x.top+x.height > paneRect.top+paneRect.height-16 )
      pane.scrollTop = (4+pane.scrollTop - ((paneRect.top+paneRect.height-16)-(x.top+x.height))).toInt();
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
  
  RLDataRow singleSelection() {
    if ( selectedRows.length == 0 )
      return null;
    return rows[selectedRows.keys.first];
  }
  
  setTableWidth( num x ) {
    headerPane.style.width = x.toString()+"px";
    pane.style.width = (x+16).toString()+"px";
  }
  
  focus() {
    focusHidden.focus();
  }
  
  clearSelection() {
    selectedRows.keys.forEach((r) => changeSelection(r, false) );
    if ( onSelection != null )
      onSelection();
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
    if ( onSelection != null )
      onSelection();
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
  
  setHeaderFromList(List values) {
    setHeader(new RLListRowData(values));
  }

  setHeader(RLDataRow header) {
    if ( tableHeader.rows.length == 0 ) {
      tableHeader.addRow();
    }
    TableRowElement newRow = tableHeader.rows[0];
    newRow.attributes['t_id'] = "header";
    headerRenderer.renderRow("header", newRow, header, renderStyle);
    adjustColWidthFromHeader();
  }
  
  adjustTWidth() {
    headerPane.contentEdge.width = pane.contentEdge.width - 16;
  }
  
  adjustColWidthFromHeader() {
    adjustTWidth();
    if ( tableHeader.rows.length < 1 || table.rows.length < 1 )
      return;
    List hd = tableHeader.rows[0].cells;
    List bd = table.rows[0].cells;
    if ( hd.length < 1 || bd.length < 1) 
      return;
    num index = 0;
    int off = 2;
    var prevBody; var prevHeader;
    hd.forEach((headCell) {
       var bodyCell = bd[index];
       var offR = bodyCell.offset;
       var offH = headCell.offset;
       if ( prevHeader != null ) {
         if ( offR.left < offH.left ) {
           prevBody.contentEdge.width += offH.left-offR.left;
         } else if ( offH.left < offR.left ) {
           prevHeader.contentEdge.width += offR.left-offH.left;
         }
       }
       prevHeader = headCell; prevBody = bodyCell;
       index++;
     }
    );
    if ( prevHeader != null ) {
      if ( prevHeader.marginEdge.width-off*2 < prevBody.marginEdge.width ) {
        prevHeader.contentEdge.width = prevBody.contentEdge.width+off*2; 
      }
    }
  }
  
  String upArrow = ' <span class="arrow-n"></span>';
  String doArrow = ' <span class="arrow-s"></span>';
  setHeaderSortArrow(String field, bool up) {
    TableRowElement header = tableHeader.rows[0];
    header.cells.forEach((cell) {
       if ( cell.innerHtml.endsWith(upArrow) )
         cell.innerHtml = cell.innerHtml.substring(0, cell.innerHtml.length-upArrow.length);
       if ( cell.innerHtml.endsWith(doArrow) )
         cell.innerHtml = cell.innerHtml.substring(0, cell.innerHtml.length-doArrow.length);
       if ( cell.attributes['t_field'] == field ) {
         cell.innerHtml = cell.innerHtml+(up?upArrow:doArrow);
       }
    });
  }

  var colResizeUnderway = 0;
  
  updateRow(String rowId, Map newValues) {
    RLDataRow data = rows[rowId];
    if ( data != null ) {
      newValues.forEach( (key,val) => data.setValue(key, val) );
      TableRowElement row = findRow(rowId);
      row.cells.forEach((cell) {
        String field = cell.attributes['t_field'];
        if (newValues[field] != null) {
          cell.innerHtml = defValRend.renderValue(cell, newValues[field]);
          cell.style.backgroundColor="#db0";
          new Timer(new Duration(milliseconds:1000), () { 
               cell.style.transition = "background-color 1s";
               cell.style.backgroundColor="";
               new Timer(new Duration(milliseconds:1050), () {cell.style.transition="";} );
            } 
          );
        }
      });
      colResizeUnderway++;
      new Timer(new Duration(milliseconds:500), () {
        if ( colResizeUnderway == 1  )
          adjustColWidthFromHeader();
        colResizeUnderway--;
      } 
      );
    }
  }
  
  int get rowCount => rows.length;
  
  addRow(RLDataRow data) {
    var id = createRowId();
    addRowWithId(id,data);
  }

  addRowWithId(var id, RLDataRow data) {
    id = id.toString();
    TableRowElement newRow = table.addRow();
    newRow.attributes['t_id'] = id;
    rows[id] = data;
    rowRenderer.renderRow(id, newRow, data, renderStyle);
    adjustColWidthFromHeader();
  }

  removeRow(String rowId) {
    findRow(rowId).remove();
    rows[rowId] = null;
    selectedRows[rowId] = null;
    if ( selectedRowId == rowId )
      selectedRowId = null;
    adjustColWidthFromHeader();
  }
  
  addRowAsMap(Map data) {
    TableRowElement newRow = table.addRow();
    var id = createRowId(); 
    newRow.attributes['t_id'] = id;
    rows[id] = new RLMapRowData(data, int.parse(id));
    rowRenderer.renderRow(id, newRow, rows[id], renderStyle);
    adjustColWidthFromHeader();
  }

  removeAllRows() {
    table.rows.toList(growable: false).forEach((row) { row.remove();} );
    rows.clear();
    selectedRows.clear();
  }
  
  var listSorter = (idA,idB, field, up) {
    var a = idA.getValue(field);
    var b = idB.getValue(field);
    if ( a == null ) {
      return b == null ? 0 : (up?-1:1); 
    }
    return a.compareTo(b) * (up?-1:1);
  };
  
  sort( String field, bool up ) {
    List list = table.rows.map((row) { return rows[row.attributes['t_id']]; } ).toList(growable: false);
    list.sort( (idA,idB) => listSorter(idA,idB,field,up) );

    removeAllRows();
    list.forEach((rowData) {
      addRowWithId("${rowData.getId()}",rowData);
    });
    setHeaderSortArrow(field, up);
  }
  
}

abstract class RLTableRenderSpec {
  List<String> getFieldNames(RLDataRow row);
  RLValueRenderer getRendererFor(String field, RLDataRow row);
  
  String getHeaderVale(String f) {
    return f;
  }
}

class DefaultRenderSpec extends RLTableRenderSpec {
  RLValueRenderer defValRend;
  
  DefaultRenderSpec(this.defValRend);

  List<String> getFieldNames(RLDataRow row) {
    return row.getFieldNames();
  }
  
  RLValueRenderer getRendererFor(String field, RLDataRow row) {
    return defValRend;  
  }
  
}

class RLListRowData extends RLDataRow {
  List data;
  
  RLListRowData(this.data);
  
  List<String> getFieldNames() => data;
  getValue( String fieldName ) => fieldName;
  setValue( String fieldName, value ) => null;
  num getId() => -1;  
  
}

class HeaderRowMapAdapter extends RLDataRow {
  Map data;
  
  HeaderRowMapAdapter(this.data);
  
  List<String> getFieldNames() => new List.from(data.keys);
  getValue( String fieldName ) => fieldName;
  setValue( String fieldName, value ) => null;
  num getId() => -1;  
  
}

class RLMapRowData extends RLDataRow {
  Map data;
  num rowId;
  
  RLMapRowData(this.data,this.rowId);
  
  List<String> getFieldNames() => new List.from(data.keys);
  getValue( String fieldName ) => data[fieldName];
  setValue( String fieldName, value ) => data[fieldName] = value;
  num getId() => rowId;  
  
}

class RLValueRenderer {
  
  RLValueRenderer();
  String renderValue(TableCellElement elem,  var value ) {
    if ( value is num ) {
      elem.attributes['style']="text-align:right;";
      if ( value is int ) {
        return value.toInt().toString();
      } else {
        return value.toStringAsFixed(2);
      }
    }
    return '$value';
  }
}

class RLTableHeaderRowRenderer extends RLTableRowRenderer {

  String headerBG = "#006A99";
  String headerBGHover = "#008DCC";
  
  renderRow( String rowId, TableRowElement target, RLDataRow row, RLTableRenderSpec style ) {    
    style.getFieldNames(row).forEach( 
        (f) {
          var value = row.getValue(f);
          TableCellElement cell = target.addCell();
          String val = style.getRendererFor(f,row).renderValue(cell,value);
          cell.attributes['t_field'] = f;
          cell.attributes['t_id'] = rowId;
          cell.attributes['nowrap'] = "nowrap";
          cell.attributes['style']="text-align:center;background-color: $headerBG;";
          cell.style.transition = "background-color .3s";
          cell.setInnerHtml(val);
          cell.onMouseEnter.listen((ev) {
            cell.style.background='$headerBGHover';
          } );
          cell.onMouseLeave.listen((ev) {
            cell.style.background = '$headerBG';
          } );
          cell.style.paddingBottom="6px";
          cell.style.paddingTop="6px";
        } 
    );
  }

}

class RLTableRowRenderer {

  renderRow( String rowId, TableRowElement target, RLDataRow row, RLTableRenderSpec style ) {    
    style.getFieldNames(row).forEach( 
        (f) {
          var value = row.getValue(f);
          TableCellElement cell = target.addCell();
          String val = style.getRendererFor(f,row).renderValue(cell,value);
          cell.attributes['t_field'] = f;
          cell.attributes['t_id'] = rowId;
          cell.attributes['nowrap'] = "nowrap";
          cell.setInnerHtml(val);
        } 
    );
  }
  
}