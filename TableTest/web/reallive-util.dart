import 'dart:html';
import 'protocol/RealLive.dart';
import 'reallive-table.dart';

rlTooltip( Element elem, String text ) {
  DivElement div = document.createElement("div");
//  div.attributes["style"] = """
//    border:1px solid black; padding:1px 4px; background: #A00;     
//  """;
  div.setInnerHtml("<p class='triangle-isosceles'><font size='-1'>"+text+"</font></p>");
  document.body.append(div);
  div.style.position = "fixed";
  CssRect rect = elem.borderEdge;
  div.style.top = (rect.top-div.borderEdge.height+10).toString()+"px";
  div.style.left = (rect.left-8).toString()+"px";
  div.style.zIndex = "1000";
  div.style.color="#fff";
  return div;
}

convertRowListToMap( List msg ) {
  Map map = new Map();
  var it = msg.iterator;
  while (it.moveNext()) {
    var key = it.current;
    it.moveNext();
    var val = it.current;
    if ( val is List ) // fixme: destroys real arrays
      val = convertRowListToMap(val);
    map[key]=val;
  }
  return map;
}

RLLoginContext LoginContext;

class RLLoginContext {
  Scheme scheme;
  Map<String, RLTableMeta> tableMap;
  Map<num, RLTableMeta> tableIdMap;
  
  RLLoginContext(this.scheme) {
    init();
  }
  
  init() {
    tableMap = new Map();
    tableIdMap = new Map();
    scheme.tables.forEach((e){
      RLTableMeta meta = new RLTableMeta(e);
      tableMap[e.tableName] = meta;
      tableIdMap[e.tableId] = meta;
    });
  }
  
  RLTableMeta getTable( int tableId ) {
    return tableIdMap[tableId];
  }
  
  RLTableMeta getTableByName( String name ) {
    return tableMap[name];
  }
      
}

class RLTableColumnMeta {
  TableAttribute attr;
  
  RLTableColumnMeta(this.attr);
  
  String get name {
    return attr.name;
  }
  
  String get displayName {
    return attr.displayName == null ? name : attr.displayName;
  }

}

class RLTableMeta extends RLDataRow {

  TableMetaData data;
  List<RLTableColumnMeta> fields;
  Map<String,RLTableColumnMeta> fieldMap;
  List<String> fieldNames;
  
  RLTableMeta(this.data) {
    fields = new List();
    fieldMap = new Map();
    data.attributes.forEach((e) {
      var cm = new RLTableColumnMeta(e);
      fields.add(cm);
      fieldMap[cm.name] = cm;
     });
  }
  
  List<String> getFieldNames() {
    if ( fieldNames == null ) {
      List res = new List();
      fields.forEach((e) => res.add(e.name));
      fieldNames = res;
    }
    return fieldNames;
  }

  num getId() {
    return data.tableId;
  }

  getValue(String fieldName) {
    RLTableColumnMeta cm = fieldMap[fieldName];
    if ( cm == null )
      return "NULL";
    return cm.displayName;
  }

  setValue(String fieldName, value) {
    throw ("unsupported operation");
  }
}

class RLTableRow extends RLDataRow {
  
  Map data;
  RLTableMeta meta;
  
  RLTableRow(this.data, this.meta);
  
  List<String> getFieldNames() {
    return meta.getFieldNames();
  }

  num getId() {
    return data['id'];
  }

  getValue(String fieldName) {
    return data[fieldName];
  }

  setValue(String fieldName, value) {
    throw("not implemented");
  }
}