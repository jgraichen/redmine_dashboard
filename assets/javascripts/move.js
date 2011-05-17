function moveItem(drag, drop){
	drag.parentNode.removeChild(drag);
	drag.setStyle({top:0,left:0});
	drop.appendChild(drag);
}
function hideItem(drag, mouseevent) {
	drag.element.parentNode.removeChild(drag.element);
}