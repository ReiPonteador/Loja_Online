<?php
include 'conexao.php';
$mensagem = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nome = trim($_POST['nome']);
    $email = filter_var(trim($_POST['email']), FILTER_SANITIZE_EMAIL);
    $telefone = trim($_POST['telefone']);
    $senha_plana = $_POST['senha'];

    if (empty($nome) || empty($email) || empty($senha_plana)) {
        $mensagem = "<div class='alert alert-danger'>Todos os campos são obrigatórios.</div>";
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $mensagem = "<div class='alert alert-danger'>E-mail inválido.</div>";
    } else {
        // Gera o hash da senha
        $senha_hash = password_hash($senha_plana, PASSWORD_DEFAULT);

        try {
            // Insere o novo cliente
            $stmt = $pdo->prepare("INSERT INTO Cliente (nome, email, telefone, senha_hash) VALUES (?, ?, ?, ?)");
            $stmt->execute([$nome, $email, $telefone, $senha_hash]);
            $mensagem = "<div class='alert alert-success'>Cadastro realizado com sucesso! Você já pode <a href='login.php'>fazer login</a>.</div>";
        } catch (PDOException $e) {
            // Verifica se o erro é de e-mail duplicado
            if ($e->getCode() == '23000') {
                $mensagem = "<div class='alert alert-danger'>Este e-mail já está cadastrado.</div>";
            } else {
                $mensagem = "<div class='alert alert-danger'>Erro ao cadastrar: " . $e->getMessage() . "</div>";
            }
        }
    }
}
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro de Cliente</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container d-flex justify-content-center align-items-center" style="min-height: 100vh;">
        <div class="card p-4 shadow-lg" style="width: 100%; max-width: 500px;">
            <h2 class="card-title text-center mb-4">Cadastre-se</h2>
            
            <?php echo $mensagem; ?>
            
            <form action="cadastro_cliente.php" method="POST">
                <div class="mb-3">
                    <label for="nome" class="form-label">Nome Completo</label>
                    <input type="text" name="nome" id="nome" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">E-mail</label>
                    <input type="email" name="email" id="email" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="telefone" class="form-label">Telefone (Opcional)</label>
                    <input type="text" name="telefone" id="telefone" class="form-control">
                </div>
                <div class="mb-3">
                    <label for="senha" class="form-label">Senha</label>
                    <input type="password" name="senha" id="senha" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-success w-100">Criar Conta</button>
            </form>
            <p class="text-center mt-3"><a href="login.php">Já tenho conta</a></p>
        </div>
    </div>
</body>
</html>