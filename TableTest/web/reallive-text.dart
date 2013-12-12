import 'package:polymer/polymer.dart';
import 'dart:html';
import 'reallive-table.dart';

@CustomTag('reallive-text')
class RLText extends PolymerElement {
  
  RLText.created() : super.created() {}

  void enteredView() {
    init();
  }
  
  TextInputElement textField;
  DivElement div;
  List<RLDataRow> completionData = 
  [ 
    new RLMapRowData({"name:":"ARuedi", "description":"someone" }, 4), 
    new RLMapRowData({"name:":"BlaBla", "description":"someone" }, 5), 
    new RLMapRowData({"name:":"KnickKnack", "description":"someone" }, 6) 
  ];
  String completedField = "name"; 
  
  void init() {
    textField = shadowRoot.querySelector("#text");
    div = shadowRoot.querySelector("#completion");
    textField.onInput.listen((E) {
        print( textField.value );
        if ( textField.value.length > 1 ) {
          showCompletion(textField.value);
        }
      } 
    );
  }
  
  showCompletion(String text) {
    div.setInnerHtml("<p>"+text+"</p>");
  }
  
}
