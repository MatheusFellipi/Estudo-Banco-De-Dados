/*Incluir cinco clientes com seus respectivos endereços*/
INSERT INTO
  cliente (nome, cpf)
values
  ('Noah', '23608627073'),
  ('Slhama', '00685428010'),
  ('Tsuki', '72208245059'),
  ('Siehoot', '91072636000'),
  ('Max', '82914123086');

SELECT
  *
FROM
  cliente;

INSERT INTO
  cliente_endereco (
    fk_cliente,
    logradouro,
    bairro,
    cidade,
    estado,
    pais,
    cep
  )
values
  (
    '1',
    'Avenida César Lattes',
    'Setor Novo Horizonte',
    'Goiânia',
    'GO',
    'BRASIL',
    '74363-400'
  ),
  (
    '2',
    'Quadra Quadra 40',
    'Mansões de Recreio Estrela Dalva VI',
    'Luziânia',
    'GO',
    'BRASIL',
    '72809-200'
  ),
  (
    '3',
    'Rua Doutor Eurípedes Zerbine',
    'Cidade Universitária',
    'Anápolis',
    'GO',
    'BRASIL',
    '75074-760'
  ),
  (
    '4',
    'Rua das Sapucaias',
    'Residencial Aldeia do Vale',
    'Goiânia',
    'GO',
    'BRASIL',
    '74680-127'
  ),
  (
    '5',
    'Rua Dona Neguinha',
    'Conjunto Habitacional Filostro Machado Carneiro',
    'Anápolis',
    'GO',
    'BRASIL',
    '75091-165'
  );

/*Incluir os cargos de Vendedor, Secretária e Gerente;*/
INSERT INTO
  cargo (nome, descricao)
values
  ('Vendedor', 'Gerencia os item das loja'),
  ('Gerente', 'Gerencia os vendedor'),
  (
    'Secretária',
    'Receber, selecionar, ordenar, encaminhar e arquivar documentos'
  );

/* Incluir duas Secretárias, um Gerente e três Vendedores*/
SELECT
  *
FROM
  cargo;

INSERT INTO
  funcionario (fk_cargo, nome, cpf)
values
  ('1', 'Geadobir', '42222305020'),
  ('1', 'Ziak', '13593323087'),
  ('1', 'Kegor', '38086383032'),
  ('2', 'Kegor', '57886439023'),
  ('3', 'Gecao', '95313592025'),
  ('3', 'Baralas', '44317948087');

/*Incluir três fornecedores*/
INSERT INTO
  fornecedor (nome, cpf)
values
  ('Bugddele', '33240483033'),
  ('Doiza', '28440418094'),
  ('Dayriecae', '62969712067');

/* Incluir cinco produtos */
INSERT INTO
  produto (nome, estoque_minimo, qtd_estoque)
VALUES
  ('arroz', 20, 50),
  ('macarrao', 10, 100),
  ('coca-cola', 15, 25),
  ('cochinha', 30, 50),
  ('pizza', 10, 200);

/* Para cada um dos três fornecedores, incluir duas compras, contendo no mínimo três itens cada */
INSERT INTO
  comprar (fk_fornecedor)
VALUES
  ('1'),
  ('1'),
  ('2'),
  ('2'),
  ('3'),
  ('3');

/*Para cada um dos cinco clientes, incluir duas vendas com vendedores diferentes e ao menos 
 três itens cada, de tal forma que garanta que cada um dos cinco produtos seja vendido ao 
 menos duas vezes*/
INSERT INTO
  venda (fk_cliente, fk_vendedor)
VALUES
  ('1', '1'),
  ('1', '2'),
  ('2', '3'),
  ('2', '1'),
  ('3', '2'),
  ('3', '3'),
  ('4', '1'),
  ('4', '2'),
  ('5', '3'),
  ('5', '1');

INSERT INTO
  venda_item (fk_venda, fk_produto, qtd, valor_unitario)
VALUES
  ('1', '1', '5', 10),
  ('1', '2', '3', 2),
  ('1', '3', '3', 50),
  ('2', '5', '5', 10),
  ('2', '1', '3', 9),
  ('2', '2', '3', 50),
  ('3', '3', '5', 10),
  ('3', '4', '50', 3),
  ('3', '5', '3', 50),
  ('4', '1', '3', 10),
  ('4', '2', '3', 3),
  ('4', '3', '3', 10),
  ('5', '4', '3', 10),
  ('5', '5', '3', 3),
  ('5', '1', '3', 10),
  ('6', '2', '5', 10),
  ('6', '3', '3', 9),
  ('6', '4', '3', 50),
  ('7', '5', '5', 10),
  ('7', '1', '3', 2),
  ('7', '2', '3', 50),
  ('8', '3', '5', 10),
  ('8', '4', '50', 3),
  ('8', '5', '3', 50),
  ('9', '1', '3', 10),
  ('9', '2', '3', 3),
  ('9', '3', '3', 10),
  ('10', '4', '3', 10),
  ('10', '5', '3', 3),
  ('10', '1', '3', 10);

INSERT INTO
  comprar_item (fk_compra, fk_produto, qtd, valor_unitario)
VALUES
  ('1', '1', '5', 10),
  ('1', '2', '3', 2),
  ('1', '3', '3', 50),
  ('2', '5', '5', 10),
  ('2', '1', '3', 9),
  ('2', '2', '3', 50),
  ('3', '3', '5', 10),
  ('3', '4', '50', 3),
  ('3', '5', '3', 50),
  ('4', '1', '3', 10),
  ('4', '2', '3', 3),
  ('4', '3', '3', 10),
  ('5', '4', '3', 10),
  ('5', '5', '3', 3),
  ('5', '1', '3', 10),
  ('6', '2', '5', 10),
  ('6', '3', '3', 9),
  ('6', '4', '3', 50);

/*
 Para cada compra e venda efetuada nos itens ‘f’ e ‘g’, inserir ao menos duas movimentações 
 financeiras, de tal forma que a soma delas seja a mesma do valor total de cada venda ou 
 compra efetuada
 */
SELECT
  *
FROM
  comprar;

INSERT INTO
  financeiro_entrada (
    fk_venda,
    data_vencimento,
    data_baixa,
    valor,
    forma_recebimento
  )
VALUES
  ('1', '2022-06-01', '2022-05-30', 86, 'dinheiro'),
  ('6', '2022-06-26', '2022-06-27', 107, 'cartao');

INSERT INTO
  financeiro_saida (
    fk_comprar,
    data_vencimento,
    data_baixa,
    valor,
    forma_pagamento
  )
VALUES
  ('1', '2022-06-01', '2022-05-30', 86, 'dinheiro'),
  ('6', '2022-06-26', '2022-06-27', 107, 'cartao');