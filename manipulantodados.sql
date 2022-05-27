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
  *
FROM
  financeiro_entrada
  INNER JOIN venda ON financeiro_entrada.fk_venda = venda.pk_venda
  JOIN cliente ON venda.fk_cliente = cliente.pk_cliente
WHERE
  data_baixa is null
  /*Otmizado*/
SELECT
  *
FROM
  (
    SELECT
      fk_venda,
      data_vencimento,
      valor
    FROM
      financeiro_entrada
    WHERE
      data_baixa is null
  ) fe
  INNER JOIN venda ON fe.fk_venda = venda.pk_venda
  JOIN cliente ON venda.fk_cliente = cliente.pk_cliente;

SELECT
  fk_venda,
  data_vencimento,
  valor
FROM
  financeiro_entrada
WHERE
  data_baixa is null c.Contas a Pagar: nomeFornecedor,
  data_vencimento,
  valor;

Dica: contas a pagar são as movimentações de saídas futuras,
ou seja,
ainda não foram efetivadas.-- d. Movimento de Caixa: nome, data_vencimento, forma_recebimento/pagamento, valor, 
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
-- g.Vendas por Vendedores: nome,
-- valorTotal,
-- comissão (5 % do valorTotal);
SELECT
  funcionario.pk_funcionario,
  funcionario.nome,
  sum(qtd * valor_unitario)
FROM
  vendas
  join venda_item on venda.pk_venda = venda_item.fk_venda
  join funcionario on venda.fk_vendedor = funcionario.pk_funcionario
group by
  funcionario.pk_funcionario,
  funcionario.nome;

/*---------------------------------------------------------------------------------*/
/*
 h.Vendas por Cidades: nome,
 valorTotal;
 */
/*---------------------------------------------------------------------------------*/
i.Vendas por Estados: nome,
valorTotal;

j.Vendas por Produtos: nome,
qtd,
valorTotal;

k.Produtos por Vendedores: nomeProduto,
nomeVendedor,
ano,
qtd;

l.Compras por Produtos: nome,
qtd,
valorTotal;

m.Lucro bruto por Produtos: nome,
valorTotalComprado,
valorTotalVendido,
LucroBruto;

n.Faturamento Médio por Clientes: nome,
valorMédioEfetivado,
valorMédioPrevisto,
valorMédioTotal;

o.Faturamento Médio por Vendedores: nome,
valorMédioEfetivado,
valorMédioPrevisto,
valorMédioTotal;

p.Agendamento de Compras Urgentes (produtos abaixo do estoque mínimo): nomeProduto,
estoqueMinimo,
qtd;