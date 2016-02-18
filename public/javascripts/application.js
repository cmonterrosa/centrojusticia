// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function CharNum(e, modo)
{
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    if (modo=='letra'){
        reg = /\D/;
        return reg.test(keychar);
    }
    else {
        return (key <= 13 || (key >= 48 && key <= 57) || key == 46 || key == 45);
    }
}




function enable_disable_razonsocial_OLD()
{
    var combo_tipo_persona = document.getElementById("participante_tipopersona_id")
    var razonsocial = document.getElementById("participante_razon_social")
    alert(document.getElementById("participante_tipopersona_id").value);
    if(combo_tipo_persona.value == '2')
    {
       alert("Cambiop");
       document.getElementById("participante_razon_social").disabled = false
       razonsocial.focus();
    }
}

function enable_disable_razonsocial()
{
     alert("prueba");
    var selectElemen = document.getElementById("participante_tipopersona_id")
    var textfieldElemen = document.getElementById("participante_razon_social")
    var tamano = selectElemen.length;

    for(i = 0; i < tamano; i++){
        if((selectElemen[i].value == '2') && selectElemen[i].selected){
             alert(document.getElementById("participante_tipopersona_id").value);
            textfieldElemen.disabled = false;
            textfieldElemen.focus();
            break;
        }
        else
            if(typeof select == "object"){
                textfieldElemen.value = "";
                textfieldElemen.disabled = true;
            }
    }
 }





function enable_disable_others(select, textfield1, textfield2)
{
    if(typeof select == "object")
        var selectElemen = select;
    else
        selectElemen = document.forms[0].elements[select];

    var textfieldElemen = document.forms[0].elements[textfield1];
    var tamano = selectElemen.length;

    for(i = 0; i < tamano; i++){
        if((selectElemen[i].value == 'MORAL' || selectElemen[i].value == 'si') && selectElemen[i].selected){
            textfieldElemen.disabled = false;
            break;
        }
        else
            if(typeof select == "object"){
                textfieldElemen.value = "";
                textfieldElemen.disabled = true;
                if(textfield2 != ""){
                    document.forms[0].elements[textfield2].disabled = true;
                    document.forms[0].elements[textfield2].value = "";
                }
            }
    }

}


function valida_fecha()
{
 //--- obtiene fecha entrevista -----
    var dia_e = document.forms[0].elements["geografica_e_fecha_3i"].value;
    var mes_e = document.forms[0].elements["geografica_e_fecha_2i"].value;
    var anio_e = document.forms[0].elements["geografica_e_fecha_1i"].value;
    var fecha_e = new Date(anio_e + "/" + mes_e + "/" +  dia_e);

 //--- obtiene fecha de supervisión -----
    var dia_s = document.forms[0].elements["geografica_s_fecha_3i"].value;
    var mes_s = document.forms[0].elements["geografica_s_fecha_2i"].value;
    var anio_s = document.forms[0].elements["geografica_s_fecha_1i"].value;
    var fecha_s = new Date(anio_s + "/" + mes_s + "/" +  dia_s);

 //--- obtiene fecha de captura -----
    var dia_c = document.forms[0].elements["geografica_c_fecha_3i"].value;
    var mes_c = document.forms[0].elements["geografica_c_fecha_2i"].value;
    var anio_c = document.forms[0].elements["geografica_c_fecha_1i"].value;
    var fecha_c = new Date(anio_c + "/" + mes_c + "/" +  dia_c);

    if(fecha_e > fecha_s)
        if(fecha_s > fecha_c){
            dia_c = dia_s = dia_e;
            mes_c = mes_s = mes_e;
            anio_c = anio_s = anio_e;
        }
        else
            if(fecha_e > fecha_c){
                dia_c = dia_s = dia_e;
                mes_c = mes_s = mes_e;
                anio_c = anio_s = anio_e;
            }
            else{
                dia_s = dia_e;
                mes_s = mes_e;
                anio_s = anio_e;
            }
    else
        if(fecha_s > fecha_c){
            dia_c = dia_s;
            mes_c = mes_s;
            anio_c = anio_s;
            }
         
        document.forms[0].elements["geografica_e_fecha_3i"].value = dia_e;
        document.forms[0].elements["geografica_e_fecha_2i"].value = mes_e;
        document.forms[0].elements["geografica_e_fecha_1i"].value = anio_e;
        document.forms[0].elements["geografica_s_fecha_3i"].value = dia_s;
        document.forms[0].elements["geografica_s_fecha_2i"].value = mes_s;
        document.forms[0].elements["geografica_s_fecha_1i"].value = anio_s;
        document.forms[0].elements["geografica_c_fecha_3i"].value = dia_c;
        document.forms[0].elements["geografica_c_fecha_2i"].value = mes_c;
        document.forms[0].elements["geografica_c_fecha_1i"].value = anio_c;

}

function enable_disable_mpio()
{
    var comboSelect=document.forms[0].elements['_reporte'];

    if(comboSelect.value == 'EGEML' || comboSelect.value == 'EGNGrHML' 
      || comboSelect.value == 'EGEcCML' || comboSelect.value == 'EGEsCML'
      || comboSelect.value == 'EGEcAML' || comboSelect.value == 'EGEsAML'){
        document.forms[0].elements['_municipio'].disabled = false;
    }
    else{
        document.forms[0].elements['_municipio'].disabled = true;
        document.forms[0].elements['_municipio'].value = "";
    }

    if(comboSelect.value == 'GHNA')
    {
        document.forms[0].elements['_municipio'].disabled = true;
        document.forms[0].elements['_ciclo'].disabled = true;
        document.forms[0].elements['_municipio'].value = "";
        document.forms[0].elements['_ciclo'].value = "";
    }
    else
    {
        document.forms[0].elements['_ciclo'].disabled = false;
    }

   if(comboSelect.value=='EGENyGM')
   {
       document.forms[0].elements['_ciclo'].disabled = false;
       document.forms[0].elements['_nivel'].disabled = false;
   }
   else if(comboSelect.value=='EGENyGML')
   {
       document.forms[0].elements['_municipio'].disabled = false;
       document.forms[0].elements['_ciclo'].disabled = false;
       document.forms[0].elements['_nivel'].disabled = false;
   }
   else
   {
       document.forms[0].elements['_nivel'].disabled = true;
       document.forms[0].elements['_nivel'].value='';
   }

}

function enable_civil_by_anio_nac()
{
    var h = new Date()
    var hoy = h.getFullYear();
    var anio_nac = document.forms[0].elements['identificacion_anio_nac'].value;
    var fecha = (parseInt(hoy) - parseInt(anio_nac));
    if((document.forms[0].elements['identificacion_sexo'].value =="M") && (fecha >= 10)){
        document.forms[0].elements['identificacion_civil_id'].disabled=false;
    }
    else{
        document.forms[0].elements['identificacion_civil_id'].value = "";
        document.forms[0].elements['identificacion_civil_id'].disabled=true;
    }
}

function enable_civil()
{
    var edad = parseInt(document.forms[0].elements['identificacion_edad'].value);
    if((document.forms[0].elements['identificacion_sexo'].value =="M") && (edad >= 10)){
        document.forms[0].elements['identificacion_civil_id'].disabled=false;
    }
    else{
        document.forms[0].elements['identificacion_civil_id'].value = "";
        document.forms[0].elements['identificacion_civil_id'].disabled=true;
    }
}


var post = {
  validate: function() {
    var title = $('post_title');
    var content = $('post_content');
    var postSubmit = $('post_submit');
    var errors = "";
    if (title.value == "") {
      title.setStyle({backgroundColor: "#fff9f9"});
			errors += "* Please enter a title.\n";
		}
		if (content.value == "") {
      content.setStyle({backgroundColor: "#fff9f9"});
			errors += "* Please enter some content.\n";
		}
    if (errors == "") {
		  postSubmit.value = "Processing...";
		  postSubmit.disabled = true;
			return true;
		} else {
			alert("Please fix the following errors:\n"+errors);
			return false;
		}
  }
}

// -------------------------
// Multiple File Upload
// -------------------------
function MultiSelector(list_target, max) {
  this.list_target = list_target;this.count = 0;this.id = 0;if( max ){this.max = max;} else {this.max = -1;};this.addElement = function( element ){if( element.tagName == 'INPUT' && element.type == 'file' ){element.name = 'attachment[file_' + (this.id++) + ']';element.multi_selector = this;element.onchange = function(){var new_element = document.createElement( 'input' );new_element.type = 'file';this.parentNode.insertBefore( new_element, this );this.multi_selector.addElement( new_element );this.multi_selector.addListRow( this );this.style.position = 'absolute';this.style.left = '-1000px';};if( this.max != -1 && this.count >= this.max ){element.disabled = true;};this.count++;this.current_element = element;} else {alert( 'Error: not a file input element' );};};this.addListRow = function( element ){var new_row = document.createElement('li');var new_row_button = document.createElement( 'a' );new_row_button.title = 'Remove This Image';new_row_button.href = '#';new_row_button.innerHTML = 'Eliminar';new_row.element = element;new_row_button.onclick= function(){this.parentNode.element.parentNode.removeChild( this.parentNode.element );this.parentNode.parentNode.removeChild( this.parentNode );this.parentNode.element.multi_selector.count--;this.parentNode.element.multi_selector.current_element.disabled = false;return false;};new_row.innerHTML = element.value.split('/')[element.value.split('/').length - 1];new_row.appendChild( new_row_button );this.list_target.appendChild( new_row );};
}


//---------------  FUNCIONES JQUERY -----------

// Datetimepicker
$(function() {
$j('#sesion_start_at').datetimepicker({
	timeFormat: 'h:m'
});
});



$(function() {
  $j('#sesion_fecha').datepicker({
      showMonthAfterYear: false,
      numberOfMonths: 2,
      showOn: 'both',
      buttonImage: '/images/iconos/calendar_mini.png',
      buttonImageOnly: true
  });
});


$(function() {
  $j('#fecha_inicio').datepicker({
      showMonthAfterYear: false,
      numberOfMonths: 2,
      showOn: 'both',
      buttonImage: '/images/iconos/calendar_mini.png',
      buttonImageOnly: true
  });
});

$(function() {
  $j('#fecha_fin').datepicker({
      showMonthAfterYear: false,
      numberOfMonths: 2,
      showOn: 'both',
      buttonImage: '/images/iconos/calendar_mini.png',
      buttonImageOnly: true
  });
});

//$(function() {
//  $j('#movimiento_fecha_inicio').datepicker({
//      showMonthAfterYear: false,
//      numberOfMonths: 2,
//      showOn: 'both',
//      buttonImage: '/images/iconos/calendar_mini.png',
//      buttonImageOnly: true
//  });
//});

//$(function() {
//  $j('#movimiento_fecha_fin').datepicker({
//      showMonthAfterYear: false,
//      numberOfMonths: 2,
//      showOn: 'both',
//      buttonImage: '/images/iconos/calendar_mini.png',
//      buttonImageOnly: true
//  });
//});

$(function() {
$j('#movimiento_fecha_inicio').datetimepicker({
      timeFormat: 'h:m',
      showMonthAfterYear: false,
      numberOfMonths: 2,
      showOn: 'both',
      buttonImage: '/images/iconos/calendar_mini.png',
      buttonImageOnly: true
});
});

$(function() {
$j('#movimiento_fecha_fin').datetimepicker({
      timeFormat: 'h:m',
      showMonthAfterYear: false,
      numberOfMonths: 2,
      showOn: 'both',
      buttonImage: '/images/iconos/calendar_mini.png',
      buttonImageOnly: true
});
});

$(function() {
$j('#festivo_fecha_inicio').datetimepicker({
      timeFormat: 'h:m',
      showMonthAfterYear: false,
      numberOfMonths: 2,
      showOn: 'both',
      buttonImage: '/images/iconos/calendar_mini.png',
      buttonImageOnly: true
});
});

$(function() {
$j('#festivo_fecha_fin').datetimepicker({
      timeFormat: 'h:m',
      showMonthAfterYear: false,
      numberOfMonths: 2,
      showOn: 'both',
      buttonImage: '/images/iconos/calendar_mini.png',
      buttonImageOnly: true
});
});



//$(function() {
//$j('#sesion_fecha').datepicker({
//        numberOfMonths: 2
//
//},
//
// $j.datepicker.regional['es'] = {
//		monthNames: ['Enero','Febrero','Marzo','Abril','Mayo','Junio',
//		'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'],
//		monthNamesShort: ['Ene','Feb','Mar','Abr','May','Jun',
//		'Jul','Ago','Sep','Oct','Nov','Dic'],
//		dayNames: ['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'],
//		dayNamesShort: ['Dom','Lun','Mar','Mié','Juv','Vie','Sáb'],
//		dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','Sá'],
//		dateFormat: 'dd/mm/yyyy', firstDay: 1,
//		renderer: $.datepick.defaultRenderer,
//		prevText: '&#x3c;Ant', prevStatus: '',
//		prevJumpText: '&#x3c;&#x3c;', prevJumpStatus: '',
//		nextText: 'Sig&#x3e;', nextStatus: '',
//		nextJumpText: '&#x3e;&#x3e;', nextJumpStatus: '',
//		currentText: 'Hoy', currentStatus: '',
//		todayText: 'Hoy', todayStatus: '',
//		clearText: 'Limpiar', clearStatus: '',
//		closeText: 'Cerrar', closeStatus: '',
//		yearStatus: '', monthStatus: '',
//		weekText: 'Sm', weekStatus: '',
//		dayStatus: 'D, M d', defaultStatus: '',
//		isRTL: false
// }
//);
//});


//$(function() {
//  $('#Date').datepicker({
//      showMonthAfterYear: false,
//      showOn: 'both',
//      buttonImage: 'media/img/calendar.png',
//      buttonImageOnly: true,
//      dateFormat:'d MM, y'
//    },
//    $.datepicker.regional['fr']
//  );
//});


/* Orientaciones */

$(function() {
    $j('#orientacion_fechahora').datetimepicker({
        dayOfWeekStart : 1,
        lang:'es'
    });
});

$(function() {
    $j('#convenio_fechahora').datetimepicker({
        dayOfWeekStart : 1,
        lang:'es'
    });
});

$(function() {
    $j('#seguimiento_fechahora').datetimepicker({
        dayOfWeekStart : 1,
        lang:'es'
    });
});





//$(function() {
//$j("#sesion_fecha").datepicker({
//   showOn: 'both',
//   buttonImage: 'calendar.png',
//   buttonImageOnly: true,
//   changeYear: true,
//   numberOfMonths: 2,
//   onSelect: function(textoFecha, objDatepicker){
//      $j("#mensaje").html("<p>Has seleccionado: " + textoFecha + "</p>");
//   }
//});
//});


/* Habilita datos de expedientes en comparecencias */

  function habilitar_datos(datos, label_datos){
      objeto_datos = document.getElementById(datos);
      objeto_label_datos = document.getElementById(label_datos);
      if (document.getElementById("comparecencia_conocimiento_si").checked == true)
        {
          objeto_datos.style.display = 'inline';
          objeto_label_datos.style.display = 'inline';
          objeto_datos.disabled = false;
        }
      else
          if (document.getElementById("comparecencia_conocimiento_no").checked == true)
           {
                objeto_datos.style.display = 'none';
                objeto_label_datos.style.display = 'none';
                objeto_datos.value = "";
                objeto_datos.disabled = true;
            }
  }


/* Funciones de empleado */
$(function() {
    $j('#empleado_fecha_ingreso').datetimepicker({
            lang:'es',
            timepicker:false,
            format:'Y/m/d',
            formatDate:'Y/m/d'
    });
});


$(function() {
    $j('#empleado_fecha_baja').datetimepicker({
            lang:'es',
            timepicker:false,
            format:'Y/m/d',
            formatDate:'Y/m/d'
    });
})

$(function() {
    $j('#certificacion_fecha_emision').datetimepicker({
            lang:'es',
            timepicker:false,
            format:'Y/m/d',
            formatDate:'Y/m/d'
    });
})

/* Tramite historico */

$(function() {
    $j('#tramite_fechahora').datetimepicker({
        dayOfWeekStart : 1,
        lang:'es'
    });
});

/* Tramite extraordinario */
$(function() {
    $j('#extraordinaria_fechahora').datetimepicker({
        dayOfWeekStart : 1,
        lang:'es'
    });
});

// Habilita/Deshabilita Catalogo de Estados si selecciona diferente de Mexico
function showHideListadoDeEstados(comboSelect, divField,divSub, clave){
    var select = document.getElementById(comboSelect);
    var subselect = document.getElementById(divSub);
    var div = document.getElementById(divField);
    var num = isNaN(parseInt(select.value)) ? 0 : parseInt(select.value)
    if(num == parseInt(clave)){
        div.style.display = 'inline';
        subselect.disabled = false;
        subselect.style.display = 'inline';
        }
    else{
        div.style.display = 'none';
        subselect.disabled = true;
        subselect.style.display = 'none';
        }
}


// Habilita/Deshabilita Paises y Municipios
function ena_originario(checkBox, elemento1, elemento2){
  var txtField1, txtField2, cBox;

    if(typeof checkBox == "object")
        cBox = checkBox;
    else
        cBox = document.getElementById(checkBox)

   if(cBox.checked)
        if(cBox.value == "NO"){
            document.getElementById(elemento1).style.display='none';
            document.getElementById(elemento2).style.display='none';
            document.getElementById(elemento1).value="";
            document.getElementById(elemento2).value="";
            document.getElementById(elemento1).disabled=true;
            document.getElementById(elemento2).disabled=true;
        }
        else{
            document.getElementById(elemento1).style.display='inline';
            document.getElementById(elemento2).style.display='inline';
            document.getElementById(elemento1).disabled=false;
            document.getElementById(elemento2).disabled=false;
        }
    else{
    
           document.getElementById(elemento1).style.display='inline';
           document.getElementById(elemento2).style.display='inline';
           document.getElementById(elemento1).disabled=false;
           document.getElementById(elemento2).disabled=false;
    }
}


// Deshabilita controladores de fecha de nacimiento y edad //

function ena_edad(checkBox, elemento_fecha, elemento_edad){
  var objeto_select, objeto_fecha1, objeto_fecha2, objeto_fecha3, cBox;

  objeto_select = document.getElementById(elemento_edad);
  objeto_fecha1 = document.getElementById(elemento_fecha + "_1i");
  objeto_fecha2 = document.getElementById(elemento_fecha + "_2i");
  objeto_fecha3 = document.getElementById(elemento_fecha + "_3i");


    if(typeof checkBox == "object")
        cBox = checkBox;
    else
        cBox = document.getElementById(checkBox)

   if(cBox.checked)
        if(cBox.value == "NO"){
            objeto_select.style.display='none';
            objeto_fecha1.style.display='none';
            objeto_fecha2.style.display='none';
            objeto_fecha3.style.display='none';
            objeto_select.value='';
            objeto_fecha1.value='';
            objeto_fecha2.value='';
            objeto_fecha3.value='';
             objeto_select.disabled=true;
            objeto_fecha1.disabled=true;
            objeto_fecha2.disabled=true;
            objeto_fecha3.disabled=true;
            
        }
        else{
            objeto_select.style.display='inline';
            objeto_fecha1.style.display='inline';
            objeto_fecha2.style.display='inline';
            objeto_fecha3.style.display='inline';
            objeto_select.disabled=false;
            objeto_fecha1.disabled=false;
            objeto_fecha2.disabled=false;
            objeto_fecha3.disabled=false;
        }
    else{

           objeto_select.style.display='inline';
            objeto_fecha1.style.display='inline';
            objeto_fecha2.style.display='inline';
            objeto_fecha3.style.display='inline';
            objeto_select.disabled=false;
            objeto_fecha1.disabled=false;
            objeto_fecha2.disabled=false;
            objeto_fecha3.disabled=false;
    }
}



// Habilita los campos de hora y dias de preferencias //
function ena_disponibilidad(checkBox, elemento_hora, elemento_dia, label_hora, label_dia){
  var objeto_hora, objeto_dia, objeto_label_dia, objeto_label_hora, cBox;

  objeto_hora = document.getElementById(elemento_hora);
  objeto_dia = document.getElementById(elemento_dia);
  objeto_label_hora = document.getElementById(label_hora);
  objeto_label_dia = document.getElementById(label_dia);
  

    if(typeof checkBox == "object")
        cBox = checkBox;
    else
        cBox = document.getElementById(checkBox)

   if(cBox.checked)
        if(cBox.value == "SI"){
            objeto_hora.style.display='none';
            objeto_dia.style.display='none';
            objeto_label_hora.style.display='none';
            objeto_label_dia.style.display='none';
            objeto_hora.value='';
            objeto_dia.value='';
            objeto_hora.disabled=true;
            objeto_dia.disabled=true;
            
        }
        else{
            objeto_hora.style.display='inline';
            objeto_dia.style.display='inline';
            objeto_label_hora.style.display='inline';
            objeto_label_dia.style.display='inline';
            objeto_hora.disabled=false;
            objeto_dia.disabled=false;
            
        }
    else{
           objeto_hora.style.display='none';
           objeto_dia.style.display='none';
           objeto_label_hora.style.display='none';
            objeto_label_dia.style.display='none';
           objeto_hora.disabled=false;
           objeto_dia.disabled=false;
           
        }
}


/* Funciones para asignacion de materia */

function enaPreguntasAsignacionMateria(radioButton, comboSelect){
    var select = document.getElementById(comboSelect);

    if(typeof radioButton == "object")
        var radio = radioButton;
    else
        if(document.getElementById(radioButton+'_si').checked)
            {
              radio = document.getElementById(radioButton+'_si');
              document.getElementById("pregunta2").style.display = "none";
              document.getElementById("pregunta3").style.display = "inline";
              document.getElementById("pregunta4").style.display = "inline";
              document.getElementById("pregunta5").style.display = "inline";
              document.getElementById("pregunta6").style.display = "inline";
              document.getElementById("tramite_noprocedente_id").value = "";
            }
            
        else
            {
            radio = document.getElementById(radioButton+'_no');
            document.getElementById("pregunta2").style.display = "inline";
            document.getElementById("pregunta3").style.display = "none";
            document.getElementById("pregunta4").style.display = "none";
            document.getElementById("pregunta5").style.display = "none";
            document.getElementById("pregunta6").style.display = "none";
            /* Limpiamos los campos */
            document.getElementById("tramite_objeto_solicitud").value = "";
            document.getElementById("tramite_documentacion_anexa").value = "";
            document.getElementById("tramite_observaciones_generales").value = "";
            document.getElementById("tramite_materia_id").value = "";
            }

    if(radio.checked && radio.id.match('_no')){
        enableSelect(select);
    }
    else{
        clearSelect(select);
        disableSelect(select);
    }
}

function clearSelect(select){
    var element = select;
    var tamano = element.length;
    for(i = 0; i < tamano; i++){
        element[i].selected = false;
    }
}



function enableSelect(select){
    var element = select;
    element.style.display = '';
    element.disabled = false;
}

function disableSelect(select){
    var element = select;
    element.style.display = 'none';
    element.disabled = true;
}



function ValidarConocimientoAutoridad(){
    var ReturnVal = false;
    if (ElementIsChecked("comparecencia_conocimiento_si") == true){
        if (isEmpty('comparecencia_datos') == true){
           ReturnVal = false;
        }
        else
            ReturnVal = true;
    }
    else {
        if (ElementIsChecked("comparecencia_conocimiento_no") == true){
            JQuery("#comparecencia_datos_span").html("");
            ReturnVal = true;
        }
        else
            {
               ReturnVal = true;
            }
    }
    return ReturnVal;
}


/* Funciones del formulario de participantes */

function enaOrigenEtnico(radioButton, comboSelect){
    var select = document.getElementById(comboSelect);
    if(typeof radioButton == "object")
        var radio = radioButton;
    else
        if(document.getElementById(radioButton+'_si').checked)
            {
              radio = document.getElementById(radioButton+'_si');
               document.getElementById("origen_etnico").style.display = "inline";
               select.style.display   = "inline";
            }

        else
            {
            radio = document.getElementById(radioButton+'_no');
            document.getElementById("origen_etnico").style.display = "none";
            select.style.display   = "none";
            }
}


function LoadOrigenEtnico(radioButton, comboSelect){
    var select = document.getElementById(comboSelect);
        if(document.getElementById(radioButton).checked)
            {
              document.getElementById("origen_etnico").style.display = "inline";
               select.style.display   = "inline";
            }
        else
            {
            document.getElementById("origen_etnico").style.display = "none";
            select.style.display   = "none";
            }
  }


