import "dart:core";
import 'dart:html';
import 'dart:async';


final c_a = 'a'.codeUnits[0];
final c_z = 'z'.codeUnits[0]; 
final c_A = 'A'.codeUnits[0];
final c_Z = 'Z'.codeUnits[0];
final c_Cross = '#'.codeUnits[0];
final c_SlashN = '\n'.codeUnits[0];
final c_Qu = "'".codeUnits[0];
final c_DbQU = '"'.codeUnits[0];
final c_CBraceCl = '}'.codeUnits[0];
final c_CBraceOp = '{'.codeUnits[0];
final c_BraceCl = ']'.codeUnits[0];
final c_BraceOp = '['.codeUnits[0];
final c_DbP = ':'.codeUnits[0];
final c_Comma = ','.codeUnits[0];
final c_Point = '.'.codeUnits[0];
final c_0 = '0'.codeUnits[0];
final c_9 = '9'.codeUnits[0];
final c_Plus = '+'.codeUnits[0];
final c_Minus = '-'.codeUnits[0];
final c_Greater = '>'.codeUnits[0];
final c_Backslash = '\\'.codeUnits[0];
final c_b = 'b'.codeUnits[0];
final c_n = 'n'.codeUnits[0];
final c_f = 'f'.codeUnits[0];
final c_t = 't'.codeUnits[0];
final c_r = 'r'.codeUnits[0];
final c_u = 'u'.codeUnits[0];
final c_E = 'E'.codeUnits[0];
final c_e = 'e'.codeUnits[0];
final c_Slash = '/'.codeUnits[0];
final c_Semi = ';'.codeUnits[0];
final c_Lesser = '<'.codeUnits[0];
final c_Slash_b = '\b'.codeUnits[0];
final c_Slash_n = '\n'.codeUnits[0];
final c_Slash_f = '\f'.codeUnits[0];
final c_Slash_t = '\t'.codeUnits[0];
final c_Slash_r = '\r'.codeUnits[0];


// unused for now
abstract class DsonReflectable {
  String dsonName();
  operator []= ( String field, var val );
  operator [] ( String field );
  List<String> getFields();
}

Dson DSON = new Dson();

class Dson {
  
  static Dson self; 
  var classFactory;
  
  factory Dson() {
    if ( self == null )
      self = new Dson._internal();
    return self;
  }
  
  Dson._internal();
  
  String encode( var object ) {
    StringBuffer buff = new StringBuffer();
    buff = new StringBuffer();
    new DsonSerializer().serialize(object, buff, "");
    return buff.toString();
  }
  
  decode( String input ) {
    var ser = new DsonDeserializer.fromString(input);
    ser.fac = classFactory;
    return ser.readObject();
  }

}

class DsonSerializer {

  serialize( var obj, StringBuffer out, String indent ) {
    if ( obj is num ) {
      out.write(obj);
      return;
    } else
    if ( obj is String ) {
      encodeString(obj,out);
      return;
    } else if ( obj is List ) {
      out.writeln("[");
      obj.forEach((v) {
          out.write(indent+"    ");
          serialize( v, out, indent+"    " );   
          out.writeln();
        }
      );
      out.write(indent+"  ");
      out.write('] ');
    } else if ( obj is Map ) {
      String type = obj['@type'];
      if ( type == null ) {
        type = "map";
      }
      out.writeln();
      out.write(indent);
      out.writeln(type);
      out.write(indent+"  ");
      obj.forEach((k,v) {
        if ( v != null && k != '@type' ) { // fixme
          out.write(k+":");
          serialize( v, out, indent+"    " );   
          out.write(' ');
        }
      });
      out.writeln();
      out.write(indent);
      out.write(';');
    } else { // assume DsonReflectable
      out.writeln();
      out.write(indent);
      out.writeln(obj.dsonName());
      obj.getFields().forEach((String field) {
        if ( obj[field] != null ) {
          out.write(indent+"  ");
          out.write(field+":");
          serialize( obj[field], out, indent+"  " );
          out.writeln();
        }
      });
      out.writeln(';');
    }
  }

  bool isNullValue(Object fieldValue) {
    if ( fieldValue is num ) {
      return fieldValue != 0.0;
    }
    return fieldValue != null && fieldValue != false;
  }

  encodeString( String string, StringBuffer out ) {
    if (string==null) {
      out.write("null");
      return;
    }
    if (string.length == 0) {
      out.write("\"\"");
      return;
    }

    int         b;
    int         c = 0;
    int         i;
    int         len = string.length;
    String      t;

    out.write('"');
    for (i = 0; i < len; i += 1) {
      b = c;
      c = string.codeUnitAt(i);
      if ( c == c_Backslash || c == c_DbQU ) {
        out.write('\\'); out.writeCharCode(c);
      } else if ( c == c_Slash ) {
        if (b == c_Lesser ) {
          out.write('\\');
        }
        out.writeCharCode(c);
      } 
      else if ( c == c_Slash_b ) {
        out.write("\\b");
      } else if ( c == c_Slash_t ) {
        out.write("\\t");
      } else if ( c == c_Slash_n ) {
        out.write("\\n");
      } else if ( c == c_Slash_f ) {
        out.write("\\f");
      } else if ( c == c_Slash_r) {
        out.write("\\r");
      } else {
          if (c < 32 || (c >= 0x80 && c < 0xa0) ||
              (c >= 0x2000 && c < 0x2100) ) 
          {
            t = "000" + c.toRadixString(16);
            out.write("\\u" + t.substring(t.length - 4));
          } else {
            out.writeCharCode(c);
          }
      }
    }    
    out.write('"');
  }
}

class DsonDeserializer {

  var fac;
  
  bool isLetter( int num ) {
    return (num >= c_a && num <= c_z) || (num >= c_A && num <= c_Z );
  }
  
  bool isIdChar( int num ) {
    return isIdStart(num) || isDigit(num);
  }

  bool isIdStart( int num ) {
    return isLetter(num) || num == '#'.codeUnitAt(0) || num == '\$'.codeUnitAt(0);
  }

  bool isDigit( int num ) {
    return (num >= c_0 && num <= c_9);
  }

  DsonCharInput inp;
//  protected DsonTypeMapper mapper;

  DsonDeserializer(this.inp);

  DsonDeserializer.fromString(String instring) {
    inp = new DsonCharInput(instring);
  }
  
  skipWS() {
    int ch = inp.readChar();
    while ( ch >= 0 && ch <= 32 ) {
      ch = inp.readChar();
    }
    if ( ch == c_Cross ) {
      ch=inp.readChar();
      while ( ch >= 0 && ch != c_SlashN ) {
        ch = inp.readChar();
      }
      skipWS();
    } else
      inp.back(1);
  }

  String NULL_LITERAL = "_NULL_LITERAL_";
  mapLiteral( String s) {
    if ( s=='y' || s == 'yes' || s == 'true')
      return true;
    if ( s=='n' || s == 'no' || s == 'false')
      return false;
    if ( s == 'null')
      return null;
    return NULL_LITERAL;
  }
  
  readObject() {
    skipWS();
    var type = readId();
    var literal = mapLiteral(type);
    if (literal != NULL_LITERAL )
      return literal;
    skipWS();
    int ch = inp.readChar();
    if ( ch != c_CBraceOp ) {
//      throw ("expected { at ${inp.position}");
      inp.back(1);
    }
    String implied = null;
    if (inp.peekChar()==c_DbP) { // implied attribute
      implied = getImpliedAttr(type);
      if (implied==null)
        throw ("expected implied attribute");
    }
    var res = createObjectInstance(type);
    readFields(implied,res, new TypeInfo(type));
    return res;
  }
  
  getImpliedAttr(String type) {
    return null;
  }
  
  createObjectInstance( String name ) {
    var result;
    if ( fac != null ) {
      result = fac.newInstance(name);
    }
    if ( result == null ) {
      result = new Map();
      result['@type'] = name;
    }
    return result;
  }

  readFields(String implied, dynamic target, TypeInfo clz ) {
    while ( inp.peekChar() != c_CBraceCl && inp.peekChar() != c_Semi) {
      var name = readId();
      skipWS();
      if (name.length==0)
        name = implied;
      int ch = inp.readChar();
      FieldInfo fieldInfo = new FieldInfo(clz,name);
      if ( ch == c_DbP ) {
        // key val
        readValue(target, fieldInfo);
      } else {
        // assume boolean set by simple attribute occurence
        setObjectValue(target, fieldInfo, true);
        //throw ("expected key value ${inp.position}'"+inp.getString(inp.position-10,10)+"'");
      }
      skipWS();
    }
    inp.readChar(); // consume '}'
  }

  setObjectValue( dynamic target, FieldInfo field, value ) {
    target[field.field] = value;
  }
  
  String coerceReading( FieldInfo field, dynamic target, String parsed ) {
    return parsed;
  }
  
  readValue( dynamic target, FieldInfo field) {
    skipWS();
    int ch = inp.peekChar();
    if ( ch == c_DbQU || ch == c_Qu ) {
      // string
      setObjectValue(target, field, coerceReading( field, target, readString()) );
    } else if ( ch == c_BraceOp ) {
      // primitive array
      readArray(target, field);
    } else if ( isLetter(ch) ) {
      // object
      setObjectValue(target,field, readObject());
    } else if ( isDigit(ch) || ch == c_Plus || ch == c_Minus || ch == c_Point ) {
      String number = readNums();
      if ( number.indexOf('.') >= 0 )
        setObjectValue( target, field, double.parse(number) );
      else
        setObjectValue( target, field, int.parse(number) );
    }
  }

  readArray(Object target, FieldInfo field) {
    inp.readChar(); // consume [
    skipWS();
    int ch = inp.peekChar();
    List objects = new List();
    while ( ch != c_BraceCl ) {
      // some code redundancy for efficiency (avoid objects for default key:val
      if ( ch == c_DbQU || ch == c_Qu ) {
        // string
        objects.add(readString());
      } else if ( isIdStart(ch) ) {
        // object
        objects.add(readObject());
      } else if ( isDigit(ch) || ch == c_Plus || ch == c_Minus || ch == c_Point ) {
        String number = readNums();
        if ( number.indexOf('.') >= 0 )
          objects.add( double.parse(number) );
        else
          objects.add( int.parse(number) );
      } else {
        throw ("could not parse '"+inp.getString(inp.position-10,10)+"' expected array elements or ]");
      }
      skipWS();
      ch = inp.peekChar();
      if ( ch == c_Comma || ch == c_Greater || ch == c_DbP ) {
        inp.readChar();skipWS();
        ch = inp.peekChar();
      }
    }
    inp.readChar();
    setObjectValue(target, field, objects);
  }

  int readLong() {
    int res = 0;
    int fak = 1;
    int ch = inp.readChar();
    while ( isDigit(ch) ) {
      res += (ch-c_0)*fak;
      fak*=10;
      ch = inp.readChar();
    }
    inp.back(1);
    int reverse = 0;
    while (res != 0) {
      reverse = reverse * 10+ (res % 10);
      res = res ~/ 10;
    }
    return reverse;
  }

  String readString() {
    StringBuffer b = new StringBuffer();
    int end = inp.readChar(); // " or '
    int ch = inp.readChar();
    while( ch != end ) {
      if ( ch == '\\' ) {
        ch = inp.readChar();
        if ( ch == c_Backslash ) {
          b.write(ch);
        } else if ( ch == c_DbQU ) {
          b.write('"');
        } else if ( ch == c_Slash ) {
          b.write('/');
        } else if ( ch == c_b ) {
          b.write("\b");  
        } else if ( ch == c_f ) {
          b.write('\f');
        } else if ( ch == c_n )  {
          b.write('\n');
        } else if ( ch == c_r ) {
          b.write('\r'); 
        } else if ( ch == c_t ) {
          b.write('\t');
        } else if ( ch == c_u ) {
          b.write("\\u"+new String.fromCharCodes([inp.readChar(),inp.readChar(),inp.readChar(),inp.readChar()])); 
        }
     } else
        b.writeCharCode(ch);
      ch = inp.readChar();
    }
    return b.toString();
  }

  String readNums() {
    skipWS();
    int pos = inp.position;
    int ch = inp.readChar();
    while( isDigit(ch) || ch == c_Point || ch == c_E || ch == c_e || ch == c_Plus || ch==c_Minus ) {
      ch = inp.readChar();
    }
    inp.back(1);
    return inp.getString(pos, inp.position - pos);
  }

  String readId() {
    skipWS();
    int pos = inp.position;
    int ch = inp.readChar();
    while( isIdChar(ch) && ch != c_DbP ) {
      ch = inp.readChar();
    }
    inp.back(1);
    return inp.getString(pos, inp.position - pos);
  }

}

class DsonCharInput {
  String str;
  int position = 0;
  
  DsonCharInput(this.str);
  
  int readChar() {
    if ( position < str.length ) {
      return str.codeUnitAt(position++);
    }
    return -1;
  }
  
  int peekChar() {
    if ( position < str.length ) {
      return str.codeUnitAt(position);
    }
    return -1;
  }
  
  int back(int num) {
    position -= num;
  }
  
  String getString(int pos, int length) {
    return str.substring(pos,pos+length);
  }
}

class TypeInfo {
  String name;
  TypeInfo(this.name);
}

class FieldInfo {
  String field;
  TypeInfo type;
  
  FieldInfo(this.type,this.field);
}

final int CONNECTING = 0;
final int OPEN = 1;
final int CLOSING = 2;
final int CLOSED = 3;

DsonWebSocket DSONSocket;

class DsonWebSocket {
  
  WebSocket socket;
  bool log = true;
  var authRequest;
  var authHandler;
  int reqCount = 1;
  int receiveCount = 0;
  Map responseHandlers = new Map();
  Set subscriptions = new Set();
  bool loggedIn = false;
  
  // server induced messages which are not responses of
  // a client request
  var onMessage = (msg) => print( "unhandled dson received "+msg );
  var onDecodingException = (e) => print( "exception in decoding:$e" );
  var onLogin = () => print("logged in");
  
  factory DsonWebSocket(String url) {
    if ( DSONSocket == null )
      DSONSocket = new DsonWebSocket._fromURL(url);
    return DSONSocket;
  }

  factory DsonWebSocket.fromWS(WebSocket aSocket) {
    if ( DSONSocket == null )
      DSONSocket = new DsonWebSocket._fromWS(aSocket);
    return DSONSocket;
  }
  
  DsonWebSocket._fromURL( String url ) {
    socket = new WebSocket(url);
    init();
  }
  
  DsonWebSocket._fromWS(WebSocket aSocket) {
    socket = aSocket;
    init();
  }
  
  init() {
    socket.onOpen.listen((T) {
      if ( ! loggedIn )
        _auth();
    });
    
    socket.onMessage.listen((MessageEvent e) {
      if ( log )
        print("received:${e.data}");
      try {
        var msg = DSON.decode(e.data);
        num respId = msg['respToId'];
        if ( responseHandlers[respId] != null ) {
          responseHandlers[respId](msg);
          if ( ! subscriptions.contains(respId) ) {
            responseHandlers[respId] = null;
          }
        }
        onMessage(msg);
      } catch (e) {
        onDecodingException(e);
      }
    });

    socket.onError.listen((e) { 
      print("error:$e"); } 
    );    
  }
  
  authenticate( var authmsg, dynamic handler(var dsonResp) ) {
    authRequest = authmsg;
    authHandler = handler;
    if ( ! loggedIn )
      _auth();
  }
  
  _auth() {
    if ( authRequest != null ) {
      sendForResponse(
          authRequest, 
          10000, 
          false,
          (resp) { 
            bool res = authHandler(resp); 
            if (res) { 
              loggedIn = true;
              onLogin();
            }
          } 
        );
    }
  }

  bool isOpen() => socket.readyState == OPEN;  
  
  send( var dsonObject ) {
    if ( isOpen() ) {
      dsonObject['reqId'] = reqCount++;
      socket.send(DSON.encode(dsonObject));
    }
  }

  unsubscribe( int rq ) {
    responseHandlers[rq] = null;
    subscriptions.remove(rq);
  }
  
  sendForResponse( var dsonObject, num timeoutMillis, bool subscribe, dynamic response(respMsgOrErrorOrTimeout) ) {
    if ( isOpen() ) {
      final num rq = reqCount;
      dsonObject['reqId'] = reqCount++;
      responseHandlers[rq] = response;
      socket.send(DSON.encode(dsonObject));
      if ( ! subscribe ) {
        new Timer(new Duration(milliseconds: timeoutMillis), () { 
            if ( responseHandlers[rq] != null ) {
              responseHandlers[rq]("Timeout");
              responseHandlers[rq] = null;
            }
          } 
        );
      } else {
        subscriptions.add(rq);
      }
      return rq;
    }
    return -1;
  }
  
}

 

