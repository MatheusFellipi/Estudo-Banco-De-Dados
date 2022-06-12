CREATE
OR REPLACE FUNCTION minha_primeira_vez() RETURNS TRIGGER AS $ BODY $ BEGIN NEW.qtd_estoque = 0;

RETURN NEW;

END $ BODY $ LANGUAGE PLPGSQL;

CREATE TRIGGER estoque_zero BEFORE
INSERT
  on produto for EACH ROW EXECUTE PROCEDURE minha_primeira_vez();

INSERT INTO
  produto(nome, estoque_minimo, qtd_estoque)
VALUES
  ('mascara', 50, 100);

DROP TRIGGER produto ON estoque_zero;

DROP FUNCTION minha_primeira_vez() CASCADE;

CREATE
OR REPLACE FUNCTION minha_primeira_vez() RETURNS TRIGGER AS $ BODY $ BEGIN IF(TG_when = 'AFTER') THEN NEW.qtd_estoque = 0;

END IF;

RETURN NEW;

END $ BODY $ LANGUAGE PLPGSQL;

/*
 TG_when aflter or befor
 TG_Op insert updade delete   
 */
CREATE TABLE LOG (
  pk_log serial PRIMARY KEY,
  usuario VARCHAR(200),
  data TIMESTAMP,
  descricao VARCHAR(200),
  Tabela VARCHAR(50),
  opr VARCHAR(8)
);

CREATE
or REPLACE FUNCTION grave_log() RETURNS TRIGGER AS $ BODY $ DECLARE AUX TEXT;

BEGIN IF (TG_OP = 'INSERT') THEN AUX = NEW;

END IF;

IF(TG_OP = 'DELETE') THEN AUX = OLD;

END IF;

IF(TG_OP = 'UPDATE') THEN AUX = OLD || '->' || NEW;

END IF;

INSERT INTO
  LOG (usuario, data, descricao, Tabela, opr)
VALUES
  (CURRENT_USER, NOW(), AUX, TG_TABLE_NAME, TG_OP);

RETURN NEW;

END $ BODY $ LANGUAGE PLPGSQL;

CREATE
OR REPLACE TRIGGER grave_log
AFTER
INSERT
  OR
UPDATE
  OR DELETE on cargo FOR EACH ROW EXECUTE PROCEDURE grave_log();

INSERT INTO
  cargo (nome)
values
  ('Teste2');

/*
 Criar um conjunto de funções engatilhadas e gatilhos que sejam capazes de atualizar o valor do 
 atributo “produto.qtd_estoque” toda vez que uma compra ou uma venda for inserida, alterada 
 ou excluída.
 
 Dica:
 Suponha uma inserção de uma item de venda qualquer. O seguinte código pode ser 
 facilmente executado dentro de uma função engatilhada chamada após a inserção 
 desse item na tabela venda_item:
 
 UPDATE produto SET
 qtd_estoque = qtd_estoque - new.qtd
 WHERE pk_produto = new.fk_produto
 
 
 Observe que ‘new.qtd’ representa a quantidade que um produto foi vendido e que 
 ‘new.fk_produto’ é a chave estrangeira para o produto que foi vendido na tabela 
 venda_item.
 */
CREATE
OR REPLACE FUNCTION controle_de_estoque_venda_compra() RETURNS TRIGGER AS $ BODY $ BEGIN IF (
  TG_OP = 'INSERT'
  and TG_TABLE_NAME = 'comprar_item'
) THEN
UPDATE
  produto
SET
  qtd_estoque = qtd_estoque + new.qtd
WHERE
  pk_produto = new.fk_produto;

END IF;

IF (
  TG_OP = 'DELETE'
  and TG_TABLE_NAME = 'comprar_item'
) THEN
UPDATE
  produto
SET
  qtd_estoque = qtd_estoque - OLD.qtd
WHERE
  pk_produto = new.fk_produto;

END IF;

IF (
  TG_OP = 'UPDATE'
  and TG_TABLE_NAME = 'comprar_item'
) THEN
UPDATE
  produto
SET
  qtd_estoque = qtd_estoque - OLD.qtd + new.qtd
WHERE
  pk_produto = new.fk_produto;

END IF;

IF (
  TG_OP = 'INSERT'
  and TG_TABLE_NAME = 'venda_item'
) THEN
UPDATE
  produto
SET
  qtd_estoque = qtd_estoque - new.qtd
WHERE
  pk_produto = new.fk_produto;

END IF;

IF (
  TG_OP = 'DELETE'
  and TG_TABLE_NAME = 'venda_item'
) THEN
UPDATE
  produto
SET
  qtd_estoque = qtd_estoque + OLD.qtd
WHERE
  pk_produto = new.fk_produto;

END IF;

IF (
  TG_OP = 'UPDATE'
  and TG_TABLE_NAME = 'venda_item'
) THEN
UPDATE
  produto
SET
  qtd_estoque = qtd_estoque + OLD.qtd - new.qtd
WHERE
  pk_produto = new.fk_produto;

END IF;

RETURN NEW;

END $ BODY $ LANGUAGE PLPGSQL;

CREATE
OR REPLACE TRIGGER controle_de_estoque
AFTER
INSERT
  OR
UPDATE
  OR DELETE on venda_item FOR EACH ROW EXECUTE PROCEDURE controle_de_estoque();

CREATE
OR REPLACE TRIGGER controle_de_estoque
AFTER
INSERT
  OR
UPDATE
  OR DELETE on comprar_item FOR EACH ROW EXECUTE PROCEDURE controle_de_estoque();

INSERT INTO
  venda_item (fk_venda, fk_produto, qtd, valor_unitario)
VALUES
  ('1', '5', '110', 10);

select
  *
from
  produto;