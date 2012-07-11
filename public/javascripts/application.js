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

function enable_disable_others(select, textfield1, textfield2)
{
    if(typeof select == "object")
        var selectElemen = select;
    else
        selectElemen = document.forms[0].elements[select];

    var textfieldElemen = document.forms[0].elements[textfield1];
    var tamano = selectElemen.length;

    for(i = 0; i < tamano; i++){
        if((selectElemen[i].value == 'otr' || selectElemen[i].value == 'si') && selectElemen[i].selected){
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
