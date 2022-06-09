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