
class UpdateRowMsg /*implements DsonReflectable*/ {

  dsonName() => 'UpdateRowMsg';

  int reqId;
  int respToId;
  var row;
  List<String> changedFields;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'reqId': reqId = val; break;
      case 'respToId': respToId = val; break;
      case 'row': row = val; break;
      case 'changedFields': changedFields = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'reqId': return reqId;
      case 'respToId': return respToId;
      case 'row': return row;
      case 'changedFields': return changedFields;
    }
  }

  List<String> getFields() {
    return [
       'reqId', 'respToId', 'row', 'changedFields',
    ];
  }
}

class Scheme /*implements DsonReflectable*/ {

  dsonName() => 'Scheme';

  List<TableMetaData> tables;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'tables': tables = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'tables': return tables;
    }
  }

  List<String> getFields() {
    return [
       'tables',
    ];
  }
}

class TableMetaData /*implements DsonReflectable*/ {

  dsonName() => 'TableMetaData';

  int tableId;
  String tableName;
  String description;
  String className;
  List<TableAttribute> attributes;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'tableId': tableId = val; break;
      case 'tableName': tableName = val; break;
      case 'description': description = val; break;
      case 'className': className = val; break;
      case 'attributes': attributes = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'tableId': return tableId;
      case 'tableName': return tableName;
      case 'description': return description;
      case 'className': return className;
      case 'attributes': return attributes;
    }
  }

  List<String> getFields() {
    return [
       'tableId', 'tableName', 'description', 'className', 'attributes',
    ];
  }
}

class TableAttribute /*implements DsonReflectable*/ {

  dsonName() => 'TableAttribute';

  int maxLen;
  String type;
  String name;
  String description;
  String displayName;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'maxLen': maxLen = val; break;
      case 'type': type = val; break;
      case 'name': name = val; break;
      case 'description': description = val; break;
      case 'displayName': displayName = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'maxLen': return maxLen;
      case 'type': return type;
      case 'name': return name;
      case 'description': return description;
      case 'displayName': return displayName;
    }
  }

  List<String> getFields() {
    return [
       'maxLen', 'type', 'name', 'description', 'displayName',
    ];
  }
}

class AddRowMsg /*implements DsonReflectable*/ {

  dsonName() => 'AddRowMsg';

  int reqId;
  int respToId;
  var row;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'reqId': reqId = val; break;
      case 'respToId': respToId = val; break;
      case 'row': row = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'reqId': return reqId;
      case 'respToId': return respToId;
      case 'row': return row;
    }
  }

  List<String> getFields() {
    return [
       'reqId', 'respToId', 'row',
    ];
  }
}

class Request /*implements DsonReflectable*/ {

  dsonName() => 'Request';

  int reqId;
  int respToId;
  String unparsedRequest;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'reqId': reqId = val; break;
      case 'respToId': respToId = val; break;
      case 'unparsedRequest': unparsedRequest = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'reqId': return reqId;
      case 'respToId': return respToId;
      case 'unparsedRequest': return unparsedRequest;
    }
  }

  List<String> getFields() {
    return [
       'reqId', 'respToId', 'unparsedRequest',
    ];
  }
}

class Expression /*implements DsonReflectable*/ {

  dsonName() => 'Expression';

  int negated;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'negated': negated = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'negated': return negated;
    }
  }

  List<String> getFields() {
    return [
       'negated',
    ];
  }
}

class And /*implements DsonReflectable*/ {

  dsonName() => 'And';

  int negated;
  List<Expression> expr;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'negated': negated = val; break;
      case 'expr': expr = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'negated': return negated;
      case 'expr': return expr;
    }
  }

  List<String> getFields() {
    return [
       'negated', 'expr',
    ];
  }
}

class Or /*implements DsonReflectable*/ {

  dsonName() => 'Or';

  int negated;
  List<Expression> expr;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'negated': negated = val; break;
      case 'expr': expr = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'negated': return negated;
      case 'expr': return expr;
    }
  }

  List<String> getFields() {
    return [
       'negated', 'expr',
    ];
  }
}

class Condition /*implements DsonReflectable*/ {

  dsonName() => 'Condition';

  int negated;
  String field;
  String contains;
  var greater;
  var lesser;
  var equals;
  var greaterEq;
  var lesserEq;
  Expression or;
  Expression and;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'negated': negated = val; break;
      case 'field': field = val; break;
      case 'contains': contains = val; break;
      case 'greater': greater = val; break;
      case 'lesser': lesser = val; break;
      case 'equals': equals = val; break;
      case 'greaterEq': greaterEq = val; break;
      case 'lesserEq': lesserEq = val; break;
      case 'or': or = val; break;
      case 'and': and = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'negated': return negated;
      case 'field': return field;
      case 'contains': return contains;
      case 'greater': return greater;
      case 'lesser': return lesser;
      case 'equals': return equals;
      case 'greaterEq': return greaterEq;
      case 'lesserEq': return lesserEq;
      case 'or': return or;
      case 'and': return and;
    }
  }

  List<String> getFields() {
    return [
       'negated', 'field', 'contains', 'greater', 'lesser', 'equals', 'greaterEq', 'lesserEq', 'or', 'and',
    ];
  }
}

class AuthReq /*implements DsonReflectable*/ {

  dsonName() => 'AuthReq';

  int reqId;
  int respToId;
  String userName;
  String passWord;
  var attachment;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'reqId': reqId = val; break;
      case 'respToId': respToId = val; break;
      case 'userName': userName = val; break;
      case 'passWord': passWord = val; break;
      case 'attachment': attachment = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'reqId': return reqId;
      case 'respToId': return respToId;
      case 'userName': return userName;
      case 'passWord': return passWord;
      case 'attachment': return attachment;
    }
  }

  List<String> getFields() {
    return [
       'reqId', 'respToId', 'userName', 'passWord', 'attachment',
    ];
  }
}

class ErrorMsg /*implements DsonReflectable*/ {

  dsonName() => 'ErrorMsg';

  int reqId;
  int respToId;
  int errNo;
  String text;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'reqId': reqId = val; break;
      case 'respToId': respToId = val; break;
      case 'errNo': errNo = val; break;
      case 'text': text = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'reqId': return reqId;
      case 'respToId': return respToId;
      case 'errNo': return errNo;
      case 'text': return text;
    }
  }

  List<String> getFields() {
    return [
       'reqId', 'respToId', 'errNo', 'text',
    ];
  }
}

class QueryReq /*implements DsonReflectable*/ {

  dsonName() => 'QueryReq';

  int subscribe;
  int reqId;
  int respToId;
  String table;
  Expression having;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'subscribe': subscribe = val; break;
      case 'reqId': reqId = val; break;
      case 'respToId': respToId = val; break;
      case 'table': table = val; break;
      case 'having': having = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'subscribe': return subscribe;
      case 'reqId': return reqId;
      case 'respToId': return respToId;
      case 'table': return table;
      case 'having': return having;
    }
  }

  List<String> getFields() {
    return [
       'subscribe', 'reqId', 'respToId', 'table', 'having',
    ];
  }
}

class AuthResponse /*implements DsonReflectable*/ {

  dsonName() => 'AuthResponse';

  int reqId;
  int respToId;
  Scheme tables;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'reqId': reqId = val; break;
      case 'respToId': respToId = val; break;
      case 'tables': tables = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'reqId': return reqId;
      case 'respToId': return respToId;
      case 'tables': return tables;
    }
  }

  List<String> getFields() {
    return [
       'reqId', 'respToId', 'tables',
    ];
  }
}

class RealLiveFactory {
  newInstance( String name ) {
    switch(name) {
      case 'UpdateRowMsg': return new UpdateRowMsg();
      case 'Scheme': return new Scheme();
      case 'TableMetaData': return new TableMetaData();
      case 'TableAttribute': return new TableAttribute();
      case 'AddRowMsg': return new AddRowMsg();
      case 'Request': return new Request();
      case 'Expression': return new Expression();
      case 'And': return new And();
      case 'Or': return new Or();
      case 'Condition': return new Condition();
      case 'AuthReq': return new AuthReq();
      case 'ErrorMsg': return new ErrorMsg();
      case 'QueryReq': return new QueryReq();
      case 'AuthResponse': return new AuthResponse();
      default: null;
    }
  }
}
