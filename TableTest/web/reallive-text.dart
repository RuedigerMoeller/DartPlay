import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:math';
import 'reallive-table.dart';
import 'reallive-util.dart';

@CustomTag('reallive-text')
class RLText extends PolymerElement {
  
  RLText.created() : super.created() {}

  void enteredView() {
    init();
  }
  
  TextInputElement textField;
  DivElement div;
  List<RLDataRow> completionData; 
  String completedField = "name"; 
  RLTable table;
  
  void init() {
    textField = shadowRoot.querySelector("#text");
    div = shadowRoot.querySelector("#completion");
    div.style.display="none";
    table = shadowRoot.querySelector("#compltable").xtag;
    table.onSelection = () {
      var row = table.singleSelection();
      if ( row != null ) {
        String val = row.getValue(completedField);
        if ( val != null ) {
          textField.value = val;
          closePopup();
        }
      }
    };
    
    textField.onKeyDown.listen((event) {
      switch( event.keyCode ) {
        case 9:
        case 27:
          closePopup();
          break;
        case 13: 
//        case 32: 
        {
          table.selectKeyTriggered(event);
        }
        break;
        case 38: 
        {
          // up
          table.upKeyTriggered(event);
        }
        break;
        case 40:  
        { // down
          table.downKeyTriggered(event);
        } 
      }        
    });
    
    var onInput = (E) {
      print( textField.value );
      if ( textField.value.length > 0 ) {
        showCompletion(textField.value);
      } else {
        closePopup();
      }
    }; 
    
    var onContext = (E) {
      showCompletion("");
      E.preventDefault();
      E.stopImmediatePropagation();    
    }; 

    textField.onInput.listen( onInput );
    textField.onContextMenu.listen( onContext );
    
  }
  
  setCompletionList( List<RLDataRow> rows, String fieldName ) {
    completedField = fieldName;
    completionData = rows;
    completionData.sort( (a,b) => table.listSorter(a,b,fieldName,true));
  }
  
  closePopup() {
    div.style.display="none";
    textField.focus();
  }
  
  showCompletion(String text) {
    table.clear();
    completionData.forEach( (E) {
        String string = E.getValue(completedField).toString().toUpperCase();
        if ( string.startsWith(text.toUpperCase()) )
          table.rowAdded(E); 
      } 
    );
    if ( table.rowCount > 0 ) {
      div.style.top = (textField.documentOffset.y+4+textField.clientHeight).toString()+"px";
      div.style.left= textField.documentOffset.x.toString()+"px";
      num height = table.table.clientHeight+4;
      div.style.height = min(200,height).toString() + "px";
      div.style.width =  (table.table.marginEdge.width+4).toString() + "px";;
      div.style.display="inline";
      num width = table.table.marginEdge.width+4;
      table.setTableWidth(width);
    } else {
      div.style.display="none";
    }
  }
  
}
