use bdtiendas;
-- 15.2.9 
-- Crear un procedimiento llamado ‘insertaPedido’ que recibirá dos parámetros:
-- un identificador de fabricante y un código postal. 
-- Para cada una de las tiendas que tengan el código postal especificado, 
-- inserta un pedido de una unidad de cada uno de  los artículos del fabricante especificado.

drop procedure if exists insertaPedido;
delimiter $$
create procedure insertaPedido(p_idFab int, p_codPostal int)
begin
	declare flag bool default false;
    declare v_idArt int;
    declare v_nifTienda varchar(10);
    declare cur1 cursor for (select nif
							 from tiendas
							 where codpostal = p_codPostal);
	declare cur2 cursor for (select id from articulos
							 where id_fabricante = p_idFab);
	declare continue handler for not found set flag = true;
    open cur1;
		fetch cur1 into v_nifTienda;
        while not flag do
			open cur2;
				fetch cur2 into v_idArt;
                while not flag do
					insert into pedidos values(v_nifTienda, v_idArt, now(), 1);
                    fetch cur2 into v_idArt;
                end while;
                set flag = false;
            close cur2;
			fetch cur1 into v_nifTienda;
        end while;
    close cur1;
end $$
delimiter ;

call insertaPedido(30, 19104);
select * from pedidos;

