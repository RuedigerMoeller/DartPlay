
class Condition {

  dsonName() => 'Condition';

  int neg;
  int negate;
  String attribute;
  List<Condition> or;
  List<Condition> and;
  String attr;
  var greater;
  String contains;
  var lesser;
  var equals;
  var greaterEq;
  var lesserEq;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'neg': neg = val; break;
      case 'negate': negate = val; break;
      case 'attribute': attribute = val; break;
      case 'or': or = val; break;
      case 'and': and = val; break;
      case 'attr': attr = val; break;
      case 'greater': greater = val; break;
      case 'contains': contains = val; break;
      case 'lesser': lesser = val; break;
      case 'equals': equals = val; break;
      case 'greaterEq': greaterEq = val; break;
      case 'lesserEq': lesserEq = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'neg': return neg;
      case 'negate': return negate;
      case 'attribute': return attribute;
      case 'or': return or;
      case 'and': return and;
      case 'attr': return attr;
      case 'greater': return greater;
      case 'contains': return contains;
      case 'lesser': return lesser;
      case 'equals': return equals;
      case 'greaterEq': return greaterEq;
      case 'lesserEq': return lesserEq;
    }
  }

  List<String> getFields() {
    return [
       'neg', 'negate', 'attribute', 'or', 'and', 'attr', 'greater', 'contains', 'lesser', 'equals', 'greaterEq', 'lesserEq',
    ];
  }
}

class AuthReq {

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

class ErrorMsg {

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

class Query {

  dsonName() => 'Query';

  int subscribe;
  int reqId;
  int respToId;
  Condition cond;
  
  Condition buildCond() { cond = new Condition(); return cond;}
  Query subs(int val) { subscribe = val; return this; } 
  
  operator []= ( String field, var val ) {
    switch (field) {
      case 'subscribe': subscribe = val; break;
      case 'reqId': reqId = val; break;
      case 'respToId': respToId = val; break;
      case 'cond': cond = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'subscribe': return subscribe;
      case 'reqId': return reqId;
      case 'respToId': return respToId;
      case 'cond': return cond;
    }
  }

  List<String> getFields() {
    return [
       'subscribe', 'reqId', 'respToId', 'cond',
    ];
  }
}

class AuthResponse {

  dsonName() => 'AuthResponse';

  int reqId;
  int respToId;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'reqId': reqId = val; break;
      case 'respToId': respToId = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'reqId': return reqId;
      case 'respToId': return respToId;
    }
  }

  List<String> getFields() {
    return [
       'reqId', 'respToId',
    ];
  }
}

class RealLiveFactory {
  newInstance( String name ) {
    switch(name) {
      case 'Condition': return new Condition();
      case 'AuthReq': return new AuthReq();
      case 'ErrorMsg': return new ErrorMsg();
      case 'Query': return new Query();
      case 'AuthResponse': return new AuthResponse();
      default: null;
    }
  }
}

