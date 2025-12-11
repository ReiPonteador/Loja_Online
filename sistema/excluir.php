<?php
    include 'conexao.php';
    $id = $_POST['btnExcluir'];

    // É importante deletar primeiro os registros que dependem de Produto
    // (Produto_Caracteristica e Estoque) devido às chaves estrangeiras.

    // APAGAR produto-caracteristica
    $sql = $pdo->prepare("DELETE FROM Produto_Caracteristica WHERE id_produto = ?");
    $sql->execute([$id]);

    // APAGAR estoque
    $sql = $pdo->prepare("DELETE FROM Estoque WHERE id_produto = ?");
    $sql->execute([$id]);

    // APAGAR O Produto
    $sql = $pdo->prepare("DELETE FROM Produto WHERE id = ?");
    $sql->execute([$id]);

    header("Location: produtos.php");
    exit;
?>