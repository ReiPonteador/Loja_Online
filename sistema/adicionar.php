<?php 
    include 'conexao.php';

    $nome = $_POST['txtNome'];
    $email = $_POST['txtEmail'];
    $data = $_POST['txtData'];

    $sql = $pdo->prepare("INSERT INTO Aluno (nome, email, data_nascimento)
    VALUES (?, ?, ?)");

    $sql->execute([$nome, $email, $data]);

    header("Location: index.php");
    exit;
?>