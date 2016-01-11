class AjusteCambioAnioProcedimientoNumerosExpedientes < ActiveRecord::Migration
  def self.up
    puts("############### ACTUALIZANDO PROCEDIMIENTO 10 DE ENERO DE 2016###############")
    execute("DROP PROCEDURE IF EXISTS update_folio_consecutivo;")
   execute("CREATE PROCEDURE `update_folio_consecutivo` (IN `v_anio` varchar(10), IN `v_id` int(11))
	SQL SECURITY DEFINER
	NOT DETERMINISTIC
	CONTAINS SQL
BEGIN

 DECLARE maximo INT;
 DECLARE consecutivo INT;
 DECLARE anterior_anterior INT;
 DECLARE anterior INT;
 DECLARE contador INT;
 DECLARE contador_anterior INT;
 DECLARE contador_anterior_anterior INT;

 DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

 DECLARE EXIT HANDLER FOR SQLWARNING
    BEGIN
        ROLLBACK;
    END;

 SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
 START TRANSACTION;
    SET maximo=(SELECT Max(folio_expediente) FROM tramites WHERE anio = v_anio FOR UPDATE);
    SET anterior_anterior=(SELECT Max(folio_expediente) - 2 FROM tramites WHERE anio = v_anio FOR UPDATE);
    SET anterior=(SELECT Max(folio_expediente) - 1 FROM tramites WHERE anio = v_anio FOR UPDATE);
    SET consecutivo=(SELECT Max(folio_expediente) + 1 FROM tramites WHERE anio = v_anio FOR UPDATE);
    SET contador_anterior_anterior = (SELECT Count(folio_expediente) FROM tramites WHERE anio = v_anio AND folio_expediente = anterior_anterior);
    SET contador_anterior = (SELECT Count(folio_expediente) FROM tramites WHERE anio = v_anio AND folio_expediente = anterior);
    SET contador=(SELECT Count(folio_expediente) FROM tramites WHERE anio = v_anio AND folio_expediente = consecutivo);

    IF(maximo IS NULL) THEN
        UPDATE tramites SET folio_expediente=1 WHERE id=v_id;
    ELSE
        IF (anterior_anterior > 0 AND contador_anterior_anterior < 1) THEN
            UPDATE tramites SET folio_expediente=anterior_anterior WHERE id=v_id;
        ELSE
            IF (anterior > 0 AND contador_anterior < 1) THEN
                UPDATE tramites SET folio_expediente=anterior WHERE id=v_id;
            ELSE
                IF (consecutivo > 0 AND contador < 1) THEN
                    UPDATE tramites SET folio_expediente=consecutivo WHERE id=v_id;
                END IF;
            END IF;
        END IF;
    END IF;
    COMMIT;
END")
  end

  def self.down
  end
end
