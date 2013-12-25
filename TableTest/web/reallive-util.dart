import 'dart:html';

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
