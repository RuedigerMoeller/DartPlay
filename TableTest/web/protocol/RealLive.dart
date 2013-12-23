
class And {

  dsonName() => 'And';

  String query;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'query': query = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'query': return query;
    }
  }

  List<String> getFields() {
    return [
       'query',
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

class Subscribe {

  dsonName() => 'Subscribe';

  String table;
  List query;

  operator []= ( String field, var val ) {
    switch (field) {
      case 'table': table = val; break;
      case 'query': query = val; break;
    }
  }

  operator [] ( String field ) {
    switch (field) {
      case 'table': return table;
      case 'query': return query;
    }
  }

  List<String> getFields() {
    return [
       'table', 'query',
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
      case 'And': return new And();
      case 'AuthReq': return new AuthReq();
      case 'ErrorMsg': return new ErrorMsg();
      case 'Subscribe': return new Subscribe();
      case 'AuthResponse': return new AuthResponse();
      default: null;
    }
  }
}
