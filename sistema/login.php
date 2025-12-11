<?php session_start(); ?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login de Cliente</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container d-flex justify-content-center align-items-center" style="min-height: 100vh;">
        <div class="card p-4 shadow-lg" style="width: 100%; max-width: 400px;">
            <h2 class="card-title text-center mb-4">Acesso ao Cliente</h2>
            
            <?php 
                // Exibe a mensagem de erro genérica
                if (isset($_SESSION['login_erro'])) {
                    echo '<div class="alert alert-danger" role="alert">E-mail ou senha inválidos.</div>';
                    unset($_SESSION['login_erro']); // Limpa a mensagem após exibir
                }
            ?>
            
            <form action="autenticar.php" method="POST">
                <div class="mb-3">
                    <label for="email" class="form-label">E-mail</label>
                    <input type="email" name="email" id="email" class="form-control" 
                           placeholder="Digite seu e-mail" required>
                </div>
                <div class="mb-3">
                    <label for="senha" class="form-label">Senha</label>
                    <input type="password" name="senha" id="senha" class="form-control" 
                           placeholder="Digite sua senha" required>
                </div>
                <button type="submit" class="btn btn-primary w-100 mb-2">Entrar</button>
                <a href="cadastro_cliente.php" class="btn btn-outline-secondary w-100">Criar Conta</a>
            </form>
        </div>
    </div>
</body>
</html>