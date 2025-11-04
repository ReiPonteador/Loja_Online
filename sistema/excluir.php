<?php
    include 'conexao.php';
    $id = $_POST['btnExcluir'];

    // APAGAR MATRICULA SE EXISTIR
    $sql = $pdo->prepare("DELETE FROM matricula WHERE aluno = ?");
    $sql->execute([$id]);

    // APAGAR O ALUNO
    $sql = $pdo->prepare("DELETE FROM Aluno WHERE id = ?");
    $sql->execute([$id]);

    header("Location: index.php");
    exit;
?>