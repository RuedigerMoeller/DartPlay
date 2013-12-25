import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dson/dson.dart';
import 'protocol/RealLive.dart';
import 'reallive-util.dart';

typedef onLoginSuccess(var loginResp);

@CustomTag('reallive-login')
class RLLogin extends PolymerElement {
  
  TextInputElement user,pwd;
  AnchorElement login;
  HtmlElement status;
  DivElement glass;
  // called with application still locked and
  // spinwheel displayed. use for app init
  onLoginSuccess onLoginSucc;
  
  RLLogin.created() : super.created() {}

  var ttip;
  void enteredView() {
    user = shadowRoot.querySelector("#user");
    pwd = shadowRoot.querySelector("#pwd");
    login = shadowRoot.querySelector("#login");
    status = shadowRoot.querySelector("#status");
    glass = shadowRoot.querySelector("#glasspane");
    user.focus();
    login.onClick.listen((ev) {
      if ( ttip != null )
        ttip.remove();
      status.setInnerHtml("<img src='ajax-loader.gif'>");
      AuthReq login = new AuthReq();
      login.userName = user.value;
      login.passWord = pwd.value;
      DSONSocket.authenticate(login, (resp) { 
        bool success = resp is AuthResponse;
        if ( success ) {
          if ( onLoginSucc != null )
            onLoginSucc(resp);
          status.setInnerHtml("");
//          glass.style.opacity = "0";
          glass.style.width="0px";
        } else {
          ttip = rlTooltip(user,"Wrong user or password");
          user.focus();
          status.setInnerHtml("");
        }
        return success;
      });      
    });
  }
}
