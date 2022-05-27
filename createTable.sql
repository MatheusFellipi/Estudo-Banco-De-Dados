CREATE TABLE cliente (
  pk_cliente serial PRIMARY KEY,
  nome VARCHAR (50) NOT NULL,
  cpf VARCHAR (20) UNIQUE NOT NULL
);

CREATE TABLE cliente_endereco (
  pk_endereco serial PRIMARY KEY,
  fk_cliente int NOT NULL,
  logradouro VARCHAR (50) NOT NULL,
  bairro VARCHAR (50) NOT NULL,
  cidade VARCHAR (50) NOT NULL,
  estado VARCHAR (50) NOT NULL DEFAULT 'GO',
  pais VARCHAR (50) NOT NULL DEFAULT 'Brasil',
  cep VARCHAR (50),
  UNIQUE(
    fk_cliente,
    logradouro,
    bairro,
    cidade,
    estado,
    pais,
    cep
  ),
  FOREIGN KEY (fk_cliente) REFERENCES cliente(pk_cliente) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE cargo (
  pk_cargo serial PRIMARY KEY,
  nome VARCHAR (50) UNIQUE NOT NULL,
  descricao VARCHAR (300)
);

CREATE TABLE funcionario (
  pk_funcionario serial PRIMARY KEY,
  fk_cargo int NOT NULL,
  nome VARCHAR (50) NOT NULL,
  cpf VARCHAR (20) UNIQUE NOT NULL,
  FOREIGN key(fk_cargo) REFERENCES cargo(pk_cargo) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE funcionário_endereco (
  pk_endereco serial PRIMARY KEY,
  fk_funcionario int NOT NULL,
  logradouro VARCHAR (50) NOT NULL,
  bairro VARCHAR (50) NOT NULL,
  cidade VARCHAR (50) NOT NULL,
  estado VARCHAR (50) NOT NULL DEFAULT 'GO',
  pais VARCHAR (50) NOT NULL DEFAULT 'Brasil',
  cep VARCHAR (50),
  UNIQUE(
    fk_funcionario,
    logradouro,
    bairro,
    cidade,
    estado,
    pais,
    cep
  ),
  FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE produto(
  pk_produto serial PRIMARY KEY,
  nome VARCHAR (30) NOT NULL,
  estoque_minimo INT DEFAULT 100,
  qtd_estoque INT DEFAULT 0
);

/* Null de um valor desconhecido no bando de dados. */
CREATE SEQUENCE venda_numero_seq;

CREATE TABLE venda (
  pk_venda serial PRIMARY KEY,
  fk_cliente INT,
  fk_vendedor INT,
  numero INT DEFAULT NEXTVAL('venda_numero_seq'),
  data DATE DEFAULT CURRENT_DATE,
  CHECK(numero >= 0),
  CHECK(data >= CURRENT_DATE),
  FOREIGN key (fk_cliente) REFERENCES cliente(pk_cliente) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN key (fk_vendedor) REFERENCES funcionario(pk_funcionario) ON DELETE restrict ON UPDATE CASCADE
);

CREATE TABLE venda_item (
  pk_item serial PRIMARY KEY,
  fk_venda INT NOT NULL,
  fk_produto INT NOT NULL,
  qtd DECIMAL(6, 2),
  valor_unitario DECIMAL(18, 2),
  UNIQUE(fk_venda, fk_produto),
  CHECK (
    qtd > 0
    and valor_unitario > 0
  ),
  FOREIGN KEY (fk_venda) REFERENCES venda(pk_venda) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (fk_produto) REFERENCES produto(pk_produto) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE financeiro_entrada(
  pk_financeiro serial PRIMARY KEY,
  fk_venda INT,
  data_emissao TIMESTAMP DEFAULT CURRENT_DATE,
  data_vencimento TIMESTAMP,
  data_baixa TIMESTAMP,
  valor DECIMAL(10, 2),
  forma_recebimento VARCHAR (48),
  CHECK(data_emissao >= CURRENT_DATE),
  CHECK(data_vencimento > data_emissao),
  CHECK(valor > 0),
  FOREIGN KEY (fk_venda) REFERENCES venda(pk_venda) ON DELETE RESTRICT on UPDATE CASCADE
);

CREATE TABLE fornecedor (
  pk_fornecedor serial PRIMARY KEY,
  nome VARCHAR (50) NOT NULL,
  cpf VARCHAR (20) UNIQUE NOT NULL
);

CREATE TABLE fornecedor_endereco (
  pk_endereco serial PRIMARY KEY,
  fk_fornecedor int NOT NULL,
  logradouro VARCHAR (50) NOT NULL,
  bairro VARCHAR (50) NOT NULL,
  cidade VARCHAR (50) NOT NULL,
  estado VARCHAR (50) NOT NULL DEFAULT 'GO',
  pais VARCHAR (50) NOT NULL DEFAULT 'Brasil',
  cep VARCHAR (50),
  UNIQUE(
    fk_fornecedor,
    logradouro,
    bairro,
    cidade,
    estado,
    pais,
    cep
  ),
  FOREIGN KEY (fk_fornecedor) REFERENCES fornecedor(pk_fornecedor) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE SEQUENCE compra_numero_seq;

CREATE TABLE comprar (
  pk_compra serial PRIMARY KEY,
  fk_fornecedor INT,
  numero INT DEFAULT NEXTVAL('compra_numero_seq'),
  data DATE DEFAULT CURRENT_DATE,
  CHECK(numero > 0),
  CHECK(data >= CURRENT_DATE),
  FOREIGN KEY (fk_fornecedor) REFERENCES fornecedor(pk_fornecedor) ON DELETE RESTRICT on UPDATE CASCADE
);

CREATE TABLE comprar_item (
  pk_item serial PRIMARY KEY,
  fk_compra INT NOT NULL,
  fk_produto INT NOT NULL,
  qtd DECIMAL(6, 2),
  valor_unitario DECIMAL(18, 2),
  UNIQUE(fk_compra, fk_produto),
  CHECK (
    qtd > 0
    and valor_unitario > 0
  ),
  FOREIGN KEY (fk_compra) REFERENCES comprar(pk_compra) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (fk_produto) REFERENCES produto(pk_produto) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE financeiro_saida(
  pk_financeiro serial PRIMARY KEY,
  fk_comprar INT,
  data_emissao TIMESTAMP DEFAULT CURRENT_DATE,
  data_vencimento TIMESTAMP,
  data_baixa TIMESTAMP,
  valor DECIMAL(10, 2),
  forma_pagamento VARCHAR (48),
  CHECK(data_emissao >= CURRENT_DATE),
  CHECK(data_vencimento > data_emissao),
  CHECK(valor > 0),
  FOREIGN KEY (fk_comprar) REFERENCES comprar(pk_compra) ON DELETE RESTRICT on UPDATE CASCADE
);