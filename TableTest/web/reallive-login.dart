import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dson/dson.dart';
import 'protocol/RealLive.dart';

@CustomTag('reallive-login')
class RLLogin extends PolymerElement {
  
  TextInputElement user,pwd;
  ButtonInputElement login;
  HtmlElement status;
  DivElement glass;
  
  RLLogin.created() : super.created() {}

  void enteredView() {
    user = shadowRoot.querySelector("#user");
    pwd = shadowRoot.querySelector("#pwd");
    login = shadowRoot.querySelector("#login");
    status = shadowRoot.querySelector("#status");
    glass = shadowRoot.querySelector("#glasspane");
    login.onClick.listen((ev) {
      status.setInnerHtml("<img src='ajax-loader.gif'> &nbsp; authentication in process ..");
      AuthReq login = new AuthReq();
      login.userName = user.value;
      login.passWord = pwd.value;
      DSONSocket.authenticate(login, (resp) { 
        bool success = resp is AuthResponse;
        if ( success ) {
          status.setInnerHtml("");
//          glass.style.opacity = "0";
          glass.style.width="0px";
        } else {
          status.setInnerHtml("<font color=red><b> Wrong user or password</b></font>");
        }
        return success;
      });      
    });
  }
}
