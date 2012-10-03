/* 
 * Centro de Justicia
 */



function alphanumeric(uadd)
{
var letters = /^[0-9a-zA-Z]+$/;
if(uadd.value.match(letters))
{
return true;
}
else
{
alert('User address must have alphanumeric characters only');
uadd.focus();
return false;
}
}


function validar_expediente()
{
 var formato = /^\d{1,4}\/20\d{2}$/
 if (document.getElementById("sesion_num_tramite").value.match(formato))
     {
      document.getElementById("submit").disabled = false;
      return true;
     }
 else
     {
      document.getElementById("submit").disabled = true;
      alert("Formato inválido, ej. 23/2012");
      document.getElementById("sesion_num_tramite").focus();
      return false
     }
}

