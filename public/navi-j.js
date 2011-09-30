if (document.getElementById)
 document.write('<style type="text/css"> .tree { display: none; }<'+'/style>');

function tree(id) {
 if (document.getElementById(id).style.display == "block")
  document.getElementById(id).style.display="none";
 else document.getElementById(id).style.display="block";
}
