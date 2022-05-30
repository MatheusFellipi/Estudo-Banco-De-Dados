/*a. Estoque de Produtos: nome, estoqueMinimo, qtd;*/
SELECT
  nome,
  estoque_minimo,
  qtd_estoque
FROM
  produto;

/*
 b. Contas a Receber: nomeCliente, data_vencimento, valor;
 Dica: contas a receber são as movimentações de entradas futuras, ou seja, ainda não foram
 efetivadas.
 */
/* esta certo mais nao otimizado */
SELECT
  cliente.nome,
  financeiro_entrada.data_vencimento,
  financeiro_entrada.valor
FROM
  financeiro_entrada
  INNER JOIN venda ON financeiro_entrada.fk_venda = venda.pk_venda
  JOIN cliente ON venda.fk_cliente = cliente.pk_cliente
WHERE
  data_baixa is null;

/* 
 c. Dica: contas a pagar são as movimentações de saídas futuras, ou seja, ainda não foram efetivadas.
 */
-- d. Movimento de Caixa: nome, data_vencimento, forma_recebimento/pagamento, valor,
-- origem;
-- Dica: aqui deverá ser feito uma união de todas as transações financeiras (entras e saídas)
-- efetivadas. O atributo ‘origem’ deverá ser uma constante capaz de identificar de qual
-- relação veio o registro, dessa forma: ‘E’ para entradas e ‘S’ para saídas.
SELECT
  *
from
  (
    SELECT
      *,
      'E' asa origem
    FROM
      financeiro_entrada
      JOIN venda ON financeiro_entrada.fk_venda = venda.pk_venda
      JOIN cliente on venda.fk_cliente = cliente.pk_cliente
    UNION
    SELECT
      *,
      'S' as origem
    from
      financeiro_saida
      JOIN compra ON financeiro_saida.fk_venda = compra.pk_compra
      JOIN fornecedor ON compra.fk_fornecedor = fornecedor.pk_fornecedor
    WHERE
      financeiro_saida IS NOT null
  ) mc
ORDER BY
  mc.data_vencimento
  /*----------Otimizando---------------------*/
SELECT
  *
from
  (
    SELECT
      *,
      'E' as origem
    FROM
      (
        SELECT
          *
        from
          financeiro_entrada
        WHERE
          data_baixa IS NOT null
      ) fe
      JOIN venda ON fe.fk_venda = venda.pk_venda
      JOIN cliente on venda.fk_cliente = cliente.pk_cliente
    UNION
    SELECT
      *,
      'S' as origem
    from
      (
        SELECT
          *
        from
          financeiro_saida
        WHERE
          data_baixa IS NOT null
      ) fs
      JOIN compra ON fs.fk_venda = compra.pk_compra
      JOIN fornecedor ON compra.fk_fornecedor = fornecedor.pk_fornecedor
  ) mc
ORDER BY
  mc.data_vencimento
  /*---------------------------------------------------------------------------------------------------------------------*/
  --   e. Caixa: ano, mes, saldo;
  --   Dicas: 1
  -- ) O caixa é um agrupamento dos saldos finais dentro de um determinado período (nesse caso por mês em cada ano).2
  -- ) uma das dificuldades imposta pelo problema será criar o saldo por ano / mês,
  -- já que nas relações [financeiro_entrada] e [financeiro_saida],
  -- os valores são sempre positivos,
  -- e,
  -- como se deve saber,
  -- para o cálculo do saldo final,
  -- deve - se subtrair os valores das saídas,
  -- portanto,
  -- desejo - lhes boa sorte 3
  -- ) convencionaremos a função date_part(‘ mês ’, < atributo >) para retornar somente o mês de um atributo do tipo data,
  -- por exemplo date_part(‘ mês ’, data_baixa).Use date_parte(‘ ano ’, < atributo >) para retornar somente o ano de um atributo do tipo data,
  -- por exemplo date_part(‘ ano ’, data_baixa).4
  -- ) para melhor visualização do que se espera,
  -- segue um exemplo hipotético de resultado f.Vendas por Clientes: nome,
  -- valorTotal;
SELECT
  *
from
  (
    SELECT
      date_part('month', data_baixa) mes,
      date_part('year', data_baixa) ano,
      sun(valor) 'E' as origem
    FROM
      (
        SELECT
          data_baixa,
          valor
        from
          financeiro_entrada
        WHERE
          data_baixa IS NOT null
      ) fe
    UNION
    SELECT
      *,
      'S' as origem
    from
      (
        SELECT
          data_baixa,
          valor * -1
        from
          financeiro_saida
        WHERE
          data_baixa IS NOT null
      ) fs
  ) mc
  /* se estiver um atributo ante da um fucao de agrupamento e necessario umar um group by*/
SELECT
  nome,
  sum(valor)
from
  Movimento_caixa
group by
  nome
having
  sum(valor) > 1000;

/*---------------------------------------------------------------------------------------------------------------------*/
-- f. Vendas por Clientes: nome, valorTotal;
SELECT
  cliente.nome,
  sum(qtd * valor_unitario) valortotal
FROM
  venda
  join venda_item on venda.pk_venda = venda_item.fk_venda
  join cliente on venda.fk_cliente = cliente.pk_cliente
group by
  cliente.nome;

/*---------------------------------------------------------------------------------------------------------------------*/
-- g.Vendas por Vendedores: nome, valorTotal, comissão (5 % do valorTotal);
SELECT
  funcionario.pk_funcionario,
  funcionario.nome,
  sum(qtd * valor_unitario) valortotal,
  sum(qtd * valor_unitario) * 0.05 comissão
FROM
  venda
  join venda_item on venda.pk_venda = venda_item.fk_venda
  join funcionario on venda.fk_vendedor = funcionario.pk_funcionario
group by
  funcionario.pk_funcionario,
  funcionario.nome;

/*---------------------------------------------------------------------------------*/
/*
 h.Vendas por Cidades: nome, valorTotal;
 */
SELECT
  cliente_endereco.cidade,
  sum(qtd * valor_unitario) valortotal
from
  cliente
  JOIN cliente_endereco on cliente.pk_cliente = cliente_endereco.fk_cliente
  JOIN venda on venda.fk_cliente = cliente.pk_cliente
  join venda_item on venda_item.fk_venda = venda.pk_venda
group by
  cliente_endereco.cidade;

/*---------------------------------------------------------------------------------*/
/*i.Vendas por Estados: nome, valorTotal;*/
SELECT
  cliente_endereco.estado,
  sum(qtd * valor_unitario) valortotal
from
  cliente
  JOIN cliente_endereco on cliente.pk_cliente = cliente_endereco.fk_cliente
  JOIN venda on venda.fk_cliente = cliente.pk_cliente
  join venda_item on venda_item.fk_venda = venda.pk_venda
group by
  cliente_endereco.estado;

/*---------------------------------------------------------------------------------*/
/*j.Vendas por Produtos: nome, qtd, valorTotal;*/
SELECT
  produto.nome,
  sum(qtd * valor_unitario) valortotal
from
  produto
  join venda_item on produto.pk_produto = venda_item.fk_produto
group by
  produto.nome;

/*---------------------------------------------------------------------------------*/
/*
 k.Produtos por Vendedores: nomeProduto, nomeVendedor, ano, qtd;
 */
SELECT
  funcionario.nome,
  produto.nome,
  date_part('year', data) ano,
  sum(venda_item.qtd)
FROM
  venda
  JOIN venda_item on venda.pk_venda = venda_item.fk_venda
  JOIN funcionario on funcionario.pk_funcionario = venda.fk_vendedor
  join produto on produto.pk_produto = venda_item.fk_produto
group by
  funcionario.nome,
  produto.nome,
  ano;

/*---------------------------------------------------------------------------------*/
/*l.Compras por Produtos: nome, qtd, valorTotal;*/
/*---------------------------------------------------------------------------------*/
-- m.Lucro bruto por Produtos: nome, valorTotalComprado, valorTotalVendido, LucroBruto;
-- n.Faturamento Médio por Clientes: nome,valorMédioEfetivado,valorMédioPrevisto,valorMédioTotal;
-- o.Faturamento Médio por Vendedores: nome,valorMédioEfetivado,valorMédioPrevisto,valorMédioTotal;
-- p.Agendamento de Compras Urgentes (produtos abaixo do estoque mínimo): nomeProduto,estoqueMinimo,qtd;
/*---------------------------------------------------------------------------------*/
-- 3. Um auditor necessita que as informações abaixo sejam disponibilizadas. Codifique as instruções
-- SLQ que gerem os seguintes relatórios:
-- a. Existem vendas sem o cadastro de recebimentos? Qual o nome do cliente, do vendedor e da
-- data em que elas foram efetuadas?
select
  cliente.nome,
  fornecedor.nome,
  cr.data
from
  (
    SELECT
      *
    from
      venda
    EXCEPT
    select
      venda.pk_venda,
      venda.fk_cliente,
      venda.fk_vendedor,
      venda.numero,
      venda.data
    from
      venda
      join financeiro_entrada on financeiro_entrada.fk_venda = venda.pk_venda
  ) cr
  join cliente on cr.fk_cliente = cliente.pk_cliente
  join fornecedor on cr.fk_vendedor = fornecedor.pk_fornecedor;

-- b. Existem vendas cuja soma dos recebimentos relacionados é menor do que os seus
-- respectivos valores totais? Qual o nome do cliente, do vendedor e da data em que elas foram
-- efetuadas?
-- Dica: para se descobrir o valor total de uma venda será necessário agrupar os valor total
-- dos itens que foram vendidos; não se esqueça que em cada item, o valor total deverá ser
-- calculado.
select
  cliente.nome,
  fornecedor.nome,
  valortotalreal.data
from
  (
    SELECT
      *
    from
      (
        SELECT
          venda.pk_venda,
          venda.fk_cliente,
          venda.fk_vendedor,
          venda.data,
          sum(qtd * valor_unitario) valorTotal
        from
          venda
          join venda_item on venda_item.fk_venda = venda.pk_venda
        group by
          venda.pk_venda,
          venda.fk_cliente,
          venda.fk_vendedor,
          venda.data
      ) valortotalvenda
      join financeiro_entrada on financeiro_entrada.fk_venda = valortotalvenda.pk_venda
    WHERE
      valortotalvenda.valorTotal > financeiro_entrada.valor
  ) valortotalreal
  join cliente on cliente.pk_cliente = valortotalreal.fk_cliente
  join fornecedor on fornecedor.pk_fornecedor = valortotalreal.fk_vendedor;

-- c. Existem compras cuja soma dos pagamentos relacionados é maior do que os seus respectivos
-- valores totais? Qual o nome do fornecedor e a data em que elas foram efetuadas? Dica: veja
-- a dica do item anterior.
SELECT
  *
from
  (
    SELECT
      *
    from
      (
        SELECT
          comprar.pk_compra,
          comprar.fk_fornecedor,
          comprar.data,
          sum(qtd * valor_unitario) valorTotal
        from
          comprar
          join comprar_item on comprar.pk_compra = comprar_item.fk_compra
        group by
          comprar.pk_compra,
          comprar.fk_fornecedor,
          comprar.data
      ) comparVentaTotalSoma
      join financeiro_saida on financeiro_saida.fk_comprar = comparVentaTotalSoma.pk_compra
    WHERE
      comparVentaTotalSoma.valorTotal > financeiro_saida.valor
  ) cmt
  join fornecedor on fornecedor.pk_fornecedor = cmt.fk_fornecedor;

/*---------------------------------------------------------------------------------*/
-- d. Existem pagamentos que não pertencem a nenhuma compra?
SELECT
  pk_financeiro,
  fk_comprar,
  data_vencimento,
  W data_emissao,
  data_baixa,
  valor,
  forma_pagamento
FROM
  financeiro_saida
EXCEPT
SELECT
  pk_financeiro,
  fk_comprar,
  data_vencimento,
  data_emissao,
  data_baixa,
  valor,
  forma_pagamento
FROM
  comprar
  JOIN financeiro_saida on financeiro_saida.fk_comprar = comprar.pk_compra;

/*---------------------------------------------------------------------------------*/
-- e. Existe algum produto com estoque negativo? Qual o nome e a qtd de estoque de cada um?
SELECT
  nome,
  qtd_estoque
from
  produto
WHERE
  produto.qtd_estoque < 0;

/*---------------------------------------------------------------------------------*/
-- f. Algum cliente também um funcionário?
SELECT
  *
from
  cliente
  join funcionario on cliente.cpf = funcionario.cpf
  /*---------------------------------------------------------------------------------*/
  -- g. Existe algum cliente que reside no mesmo endereço de um funcionário?
select
  *
from
  (
    SELECT
      pk_endereco,
      fk_cliente as fk,
      logradouro,
      bairro,
      cidade,
      estado,
      pais,
      cep
    from
      cliente
      join cliente_endereco on cliente.pk_cliente = cliente_endereco.fk_cliente
    INTERSECT
    SELECT
      pk_endereco,
      fk_funcionario as fk,
      logradouro,
      bairro,
      cidade,
      estado,
      pais,
      cep
    from
      funcionario
      join "funcionário_endereco" as fe on funcionario.pk_funcionario = fe.fk_funcionario
  ) ce
  JOIN cliente on ce.fk = cliente.pk_cliente;

-- h. Existem clientes que residem em um mesmo endereço?
SELECT
  *
FROM
  cliente
  JOIN cliente_endereco ON cliente.pk_cliente = cliente_endereco.fk_cliente;

-- i. Existem funcionários que residem em um mesmo endereço?
-- j. Existem produtos que foram vendidos abaixo do preço médio de compra? Qual o nome, o
-- valor médio compra e o valor de venda.
-- k. Existem recebimentos em atraso? Qual o nome do cliente, a data de emissão, a data de
-- vencimento e o valor?
-- l. Existem pagamentos adiantados? Qual o nome do fornecedor, a data de emissão, a data de
-- vencimento e a data da baixa?
-- 4. Como os relatórios j, k e l são do exercício anterior são executados com muita freqüência, o seu
-- gerente requisitou que fossem criadas ‘views’ para cada um destes relatórios.
-- 5. Usando apenas as views criadas no exercício anterior codifique as instruções SLQ que gerem os
-- seguintes relatórios:
-- a. Produtos vendidos abaixo do preço médio de compra, cuja a diferença entre esses
-- valores seja maior do que 70% do valor de compra.
-- b. Recebimentos que estão com mais do que um mês de atraso
-- c. Pagamentos que foram adiantados em mais do que 15 dias
-- 6. Crie uma view chamada ‘rel_venda’ que deverá exibir todas as vendas, com o nome dos clientes
-- e vendedores e seus respectivos valores totais (calculado a partir dos itens), total que já foi
-- recebido (entradas já baixadas) e total que ainda será recebido (entradas não baixadas).
SELECT
  cliente.nome,
  funcionario.nome,
  sum(venda_item.qtd * venda_item.valor_unitario)
from
  venda
  join venda_item on venda_item.fk_venda = venda.pk_venda
  join cliente on cliente.pk_cliente = venda.fk_cliente
  join funcionario on funcionario.pk_funcionario = venda.fk_vendedor
GROUP by
  cliente.nome,
  funcionario.nome;

-- 7. Realize as seguintes alterações na estrutura do banco de dados:
-- a. Adicione a coluna ‘salario’ em funcionario, com o valor padrão de 1100,00
Alter Table
  funcionario
add
  salario DECIMAL(6, 2) DEFAULT 1100.00;

-- b. Adicione uma checagem em funcionario para que não se possa inserir salários
-- negativos
Alter Table
  funcionario
ADD
  CONSTRAINT check (salario < 0);

-- c. Remova a coluna ‘descricao’ da tabela cargos
ALTER TABLE
  cargo DROP COLUMN descricao;

-- d. Remova a restrição de unicidade do nome da tabela cargos
-- e. Aumente 50 caracteres na quantidade de caracteres aceitos no nome dos
-- funcionários
-- f. Remova a restrição de chaves da tabela fornecedores_endereco com a tabela
-- fornecedores
-- g. Adiciona a restrição de chaves entre as tabelas fornecedores_endereco e
-- fornecedores
-- h. Crie uma tabla log (pk_log, data_hora, usuario, tabela, tipo_acao).
-- i. Depois de criada a tabela log_alteraoes (não pode ser feito durante a criação)
-- i. Faça com que a data_hora tenha valor padrão o current_time
-- ii. Faça com a data_hora não possa ser retroativa
-- iii. Faça com que data_hora e usuario não possam ser nulos
-- iv. Adicione uma coluna ‘acao’ de 100 caracteres variáveis que não possa ser
-- nula
-- v. Altere o nome da tabela log_alteracoes para log
-- vi. Altere para que a coluna ação criada na letra iv comporte até 200
-- caracteres.
-- vii. Retire a restrição de não nulidade da coluna ação criada na letra iv
-- 8. Dê um aumento de salário de 5% para todos os vendedores do estado de goiás.
Select
  funcionario.nome,
  salario * 0.05 + salario
from
  "funcionário_endereco" as fe
  join funcionario on fe.fk_funcionario = funcionario.pk_funcionario
  join cargo on cargo.pk_cargo = funcionario.pk_funcionario
WHERE
  fe.estado = 'GO'
  AND cargo.nome = 'Vendedor'