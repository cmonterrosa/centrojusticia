class AddTransactionToNumeroExpediente < ActiveRecord::Migration
  def self.up
  puts("############### CREANDO PROCEDIMIENTO ###############")
  execute("CREATE PROCEDURE update_folio_consecutivo(IN v_anio VARCHAR(10), IN v_id INT)

 BEGIN

 DECLARE consecutivo INT;

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
    UPDATE tramites SET folio_expediente=consecutivo WHERE id=v_id;
 COMMIT;
END; ")

end

  def self.down
  end
end
