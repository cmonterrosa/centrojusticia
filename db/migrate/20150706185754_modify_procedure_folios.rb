class ModifyProcedureFolios < ActiveRecord::Migration
  
def self.up
  puts("############### ACTUALIZANDO PROCEDIMIENTO ###############")
  execute("DROP PROCEDURE IF EXISTS update_folio_consecutivo;")
  execute("CREATE PROCEDURE `update_folio_consecutivo`  (IN `v_anio` varchar(10), IN `v_id` int(11))
	SQL SECURITY DEFINER
	NOT DETERMINISTIC
	CONTAINS SQL
BEGIN

 DECLARE consecutivo INT;
 DECLARE contador INT;

 DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

 DECLARE exit handler for SQLWARNING
    BEGIN
        ROLLBACK;
    END;

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
 START TRANSACTION;
    SET consecutivo=(SELECT Max(folio_expediente) + 1 FROM tramites WHERE anio = v_anio);
    SET contador=(SELECT Count(folio_expediente) FROM tramites WHERE anio = v_anio AND folio_expediente = consecutivo);

    IF (contador < 1) THEN
        UPDATE tramites SET folio_expediente=consecutivo WHERE id=v_id;
    END IF;
 COMMIT;
END")

end

  def self.down
    execute("DROP PROCEDURE IF EXISTS update_folio_consecutivo;")
  end


end
