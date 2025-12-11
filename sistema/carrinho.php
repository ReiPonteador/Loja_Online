<?php
session_start();
include 'conexao.php';

// Redireciona se não estiver logado
if (!isset($_SESSION['cliente_id'])) {
    header("Location: login.php");
    exit();
}

$id_cliente = $_SESSION['cliente_id'];
$mensagem_status = "";

// LÓGICA DE ADIÇÃO (Exemplo simples de adicionar ao carrinho. Deve ser chamado de 'catalogo.php')
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['id_produto_adicionar'])) {
    $id_produto = $_POST['id_produto_adicionar'];
    $quantidade = 1; // Adiciona 1 por padrão
    $id_loja = 1; // Simplificando, assumindo a primeira loja para verificar estoque

    try {
        // Verifica o estoque
        $stmt_estoque = $pdo->prepare("
            SELECT quantidade_disponivel FROM Estoque 
            WHERE id_produto = ? AND id_loja = ?
        ");
        $stmt_estoque->execute([$id_produto, $id_loja]);
        $estoque = $stmt_estoque->fetchColumn();

        if ($estoque > 0) {
            // Tenta inserir ou atualizar a quantidade (UPSERT)
            $stmt = $pdo->prepare("
                INSERT INTO CarrinhoTemporario (id_cliente, id_produto, quantidade)
                VALUES (?, ?, ?)
                ON DUPLICATE KEY UPDATE quantidade = quantidade + VALUES(quantidade)
            ");
            $stmt->execute([$id_cliente, $id_produto, $quantidade]);
            $mensagem_status = "<div class='alert alert-success'>Produto adicionado ao carrinho!</div>";
        } else {
            $mensagem_status = "<div class='alert alert-warning'>Produto sem estoque na loja selecionada.</div>";
        }
    } catch (PDOException $e) {
        $mensagem_status = "<div class='alert alert-danger'>Erro ao manipular carrinho.</div>";
    }
}

// LÓGICA DE EXIBIÇÃO DO CARRINHO
// Consulta que traz os produtos do carrinho e calcula o preço final com desconto
$sql_carrinho = $pdo->prepare("
    SELECT 
        ct.id AS id_carrinho_item, 
        p.id AS id_produto,
        p.nome, p.preco, p.desconto_usados, ct.quantidade,
        (p.preco * (1 - p.desconto_usados / 100)) AS preco_final,
        l.cidade, p.categoria, l.nome AS nomeLoja,
        e.quantidade_disponivel
    FROM CarrinhoTemporario ct
    JOIN Produto p ON ct.id_produto = p.id
    JOIN Estoque e ON p.id = e.id_produto
    JOIN Loja l ON e.id_loja = l.id
    WHERE ct.id_cliente = ? AND e.id_loja = 1 -- Assumindo Loja 1 para simplificar o link com estoque
");
$sql_carrinho->execute([$id_cliente]);
$itens_carrinho = $sql_carrinho->fetchAll(PDO::FETCH_ASSOC);

$valor_total_compra = 0.00;
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meu Carrinho de Compras</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container my-5">
        <h1>Meu Carrinho de Compras</h1>
        <a href="painel_cliente.php" class="btn btn-sm btn-outline-secondary mb-3">Voltar ao Painel</a>
        <?php echo $mensagem_status; ?>
        
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>Produto</th>
                    <th class="text-center">Categoria</th>
                    <th class="text-center">Loja</th>
                    <th class="text-center">Preço (s/ Desc)</th>
                    <th class="text-center">Desconto (%)</th>
                    <th class="text-center">Preço Final</th>
                    <th class="text-center">Qtd</th>
                    <th class="text-end">Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <?php if (empty($itens_carrinho)): ?>
                    <tr>
                        <td colspan="8" class="text-center">Seu carrinho está vazio.</td>
                    </tr>
                <?php else: ?>
                    <?php foreach ($itens_carrinho as $item): 
                        $subtotal = $item['preco_final'] * $item['quantidade'];
                        $valor_total_compra += $subtotal;
                    ?>
                    <tr>
                        <td><?php echo htmlspecialchars($item['nome']); ?></td>
                        <td class="text-center"><?php echo htmlspecialchars($item['categoria']); ?></td>
                        <td class="text-center"><?php echo htmlspecialchars($item['nomeLoja']) . ' - ' . htmlspecialchars($item['cidade']); ?></td>
                        <td class="text-center">R$ <?php echo number_format($item['preco'], 2, ',', '.'); ?></td>
                        <td class="text-center"><?php echo htmlspecialchars($item['desconto_usados']); ?>%</td>
                        <td class="text-center">R$ <?php echo number_format($item['preco_final'], 2, ',', '.'); ?></td>
                        <td class="text-center"><?php echo htmlspecialchars($item['quantidade']); ?></td>
                        <td class="text-end">R$ <?php echo number_format($subtotal, 2, ',', '.'); ?></td>
                    </tr>
                    <?php endforeach; ?>
                <?php endif; ?>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="7" class="text-end">Valor Total da Compra:</th>
                    <th class="text-end">R$ <?php echo number_format($valor_total_compra, 2, ',', '.'); ?></th>
                </tr>
            </tfoot>
        </table>

        <div class="d-flex justify-content-between mt-4">
            <a href="catalogo.php" class="btn btn-secondary">Continuar Comprando</a>
            <?php if (!empty($itens_carrinho)): ?>
                <form action="finalizar_compra.php" method="POST" onsubmit="return confirm('Deseja finalizar a compra de R$ <?php echo number_format($valor_total_compra, 2, ',', '.'); ?>?');">
                    <input type="hidden" name="valor_total" value="<?php echo $valor_total_compra; ?>">
                    <button type="submit" class="btn btn-success btn-lg">Finalizar Compra</button>
                </form>
            <?php endif; ?>
        </div>
    </div>
</body>
</html>