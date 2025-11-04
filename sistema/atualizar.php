<?php
    include 'conexao.php';
    $id = $_POST['id'];
    $nome = $_POST['nome'];
    $email = $_POST['email'];
    $data = $_POST['data'];

    $sql = $pdo->prepare("UPDATE Aluno SET nome = ?, email = ?, 
    data_nascimento = ? WHERE id = ?");
    $sql->execute([$nome, $email, $data, $id]);

    header("Location: index.php");
    exit;
?>