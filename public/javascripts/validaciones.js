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


function disable_submit()
{
 document.getElementById("submit").disabled = true;
 return true;
}


function validar_expediente()
{
 var formato = /^\d{1,4}\/20\d{2}$/
 if (document.getElementById("sesion_num_tramite").value.match(formato))
     {
      //document.getElementById("submit").disabled = false;
      return true;
     }
 else
     {
      //document.getElementById("submit").disabled = true;
      alert("Formato inválido, ej. 23/2012");
      document.getElementById("sesion_num_tramite").focus();
      return false
     }
}

function disable_num_expediente()
{
    document.getElementById("sesion_num_tramite").disabled=true;
    return true;
}



function textCounter(field, maxlimit)
{
    if (field.value.length > maxlimit)
        {
            alert("Se ha sobrepasado el limite de caracteres");
            field.focus();
        }
}


///* Funciones para evitar que cierren la página */
//
//window.onkeydown      = whatKey;
//window.onbeforeunload = closeSystem;
//
//function closeSystem(evt)
//{	//alert("Paso 2. Activa onbeforeunload");
//  	evt = (evt) ? evt : event;
//
//	clickY  = evt.clientY;
//        altKey  = evt.altKey;
//	keyCode = evt.keyCode;
//	keyVals = document.getElementById('ffKeyTrap');
//	bnclose=0;
//	if(!evt.clientY)
//		{
//
//			// Window Closing in FireFox
//			// capturing ALT + F4
//
//			if(keyVals.value == 'true115') bnclose=1;
//  			if(keyVals.value == ''||parseInt(keyVals.value)== 8)
//			{
//            	// capturing a window close by "X" ?
//             	// we have no keycodes
//				bnclose=1;
//         	}
//			if(keyVals.value == 'exit') return "CONFIRMA SALIR DEL SISTEMA?";
//     	}
//	else
//		{
//			if(clickY>0&&keyVals.value=='exit') bnclose=1;
//			else
//			{
//         		// Window Closing in IE
//		        // capturing ALT + F4
//    		    if (altKey == true && keyCode == 115){ //return "cierra con boton X";
//        	    	// capturing a window close by "X"
//					bnclose=1;
//         			}
//			 	else  //return "cierra con ?";
//					if(clickY < 0){
//        	     		// simply leaving the page via a link
//						//return "cierra con boton X";
//						bnclose=1;
//				     }
//					 else { return void(0); }
//     		}
//
//		}
//		if(bnclose)
//		{
//                        alert (document.URL);
//			return "ESTA CERRANDO EL SISTEMA SIN CERRAR SESION,\nSI NO HA GUARDADO CAMBIOS, ESTOS SE PERDERAN..." + document.URL;
//
//		}
//}
//
//function whatKey(evt)
//{
//     evt = (evt) ? evt : event;
//     keyVals = document.getElementById('ffKeyTrap');
//     altKey  = evt.altKey;
//     keyCode = evt.keyCode;
//
//     if(altKey && keyCode == 115){
//         keyVals.value = String(altKey) + String(keyCode);
//     	}
//	//agregado para no mostrar mensaje con F5
//	 else if(!altKey &&(keyCode == 116||keyCode==8)){ keyVals.value=String(keyCode);
//	 }
//}
