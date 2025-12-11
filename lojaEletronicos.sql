-- BD: loja_online
CREATE DATABASE IF NOT EXISTS loja_online;
USE loja_online;

-- Tabela Caracteristica
CREATE TABLE IF NOT EXISTS Caracteristica (
    id INT(4) AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT
);

-- Tabela Produto
CREATE TABLE IF NOT EXISTS Produto (
    id INT(4) AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    tipo ENUM('Novo', 'Usado', 'Promocao', 'Liquidacao', 'Outros') NOT NULL,
    categoria SET('Eletronico', 'Telefonia', 'Informatica', 'Eletrodomesticos', 'Acessorios', 'Outros') NOT NULL,
    data_lancamento DATE,
    desconto_usados DECIMAL(10, 2) DEFAULT 0.00
);

-- Tabela Produto_Caracteristica
CREATE TABLE IF NOT EXISTS Produto_Caracteristica (
    id INT(4) AUTO_INCREMENT PRIMARY KEY,
    id_produto INT(4),
    id_caracteristica INT(4),
    valor VARCHAR(255),
    FOREIGN KEY (id_produto) REFERENCES Produto(id) ON DELETE CASCADE,
    FOREIGN KEY (id_caracteristica) REFERENCES Caracteristica(id)
);

-- Tabela Loja
CREATE TABLE IF NOT EXISTS Loja (
    id INT(4) AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    telefone VARCHAR(15),
    rua varchar(45),
    numero int(5),
    bairro varchar(45),
    cep varchar(45),
    complemento varchar(45),
    cidade varchar(45)
);

-- Tabela Estoque
CREATE TABLE IF NOT EXISTS Estoque (
    id INT(4) AUTO_INCREMENT PRIMARY KEY,
    id_produto INT(4) NOT NULL,
    id_loja INT(4) NOT NULL,
    quantidade_disponivel INT(6) NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES Produto(id) ON DELETE CASCADE,
    FOREIGN KEY (id_loja) REFERENCES Loja(id)
);

-- NOVO: Tabela CLIENTE (Etapa 1 do PDF)
CREATE TABLE IF NOT EXISTS Cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    data_cadastro DATE DEFAULT (CURRENT_DATE),
    senha_hash VARCHAR(255) NOT NULL
);

-- NOVO: Tabela VENDA (Etapa 1 do PDF)
CREATE TABLE IF NOT EXISTS Venda (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_loja INT NOT NULL,
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id),
    FOREIGN KEY (id_loja) REFERENCES Loja(id)
);

-- NOVO: Tabela ITEMVENDA (Etapa 1 do PDF)
CREATE TABLE IF NOT EXISTS ItemVenda (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL, 
    FOREIGN KEY (id_venda) REFERENCES Venda(id) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES Produto(id)
);

-- NOVO: Tabela CARRINHOTEMPORARIO (Etapa 2 do PDF)
CREATE TABLE IF NOT EXISTS CarrinhoTemporario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL, 
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    data_adicao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES Produto(id),
    UNIQUE KEY (id_cliente, id_produto) 
);

-- View para relatórios (atualizada para incluir o id do produto)
CREATE OR REPLACE VIEW viewProdutosLoja AS
SELECT 
    p.id AS idprod,
    p.nome AS nomeprod, 
    p.preco, 
    p.descricao, 
    p.tipo, 
    p.categoria, 
    p.desconto_usados,
    p.data_lancamento, 
    e.quantidade_disponivel, 
    l.nome AS nomeLoja, 
    l.cidade, 
    l.telefone 
FROM Produto p
INNER JOIN Estoque e ON p.id = e.id_produto
INNER JOIN Loja l ON l.id = e.id_loja;

-- --------------------------------------------------------------------------------
-- POPULAÇÃO DO BANCO (Dados de lojaEletronicos.sql, adaptados para ON DUPLICATE KEY)
-- Nota: Adicionei descontos para Smartphone XYZ e Smartphone Premium para testes de carrinho

INSERT INTO Produto 
(id, nome, descricao, preco, tipo, categoria, data_lancamento, desconto_usados) VALUES 
(1, "Smartphone XYZ", "Um smartphone de ultima geracao com câmera de alta resolucao.", 999.99, "Usado", "Eletronico", "2023-01-01", 10.00) ON DUPLICATE KEY UPDATE nome=VALUES(nome), preco=VALUES(preco), desconto_usados=VALUES(desconto_usados);
INSERT INTO Produto 
(id, nome, descricao, preco, tipo, categoria, data_lancamento, desconto_usados) VALUES 
(2, 'Camera DSLR 123', 'Camera com fotografia profissional.', 1299.99, 'Novo', 'Eletronico', '2023-09-29', 0.00) ON DUPLICATE KEY UPDATE nome=VALUES(nome), preco=VALUES(preco), desconto_usados=VALUES(desconto_usados);
INSERT INTO Produto 
(id, nome, descricao, preco, tipo, categoria, data_lancamento, desconto_usados) VALUES 
(3, 'Notebook Pro', 'Um poderoso notebook ultrafino.', 1799.99, 'Novo', 'Informatica', '2023-04-10', 0.00) ON DUPLICATE KEY UPDATE nome=VALUES(nome), preco=VALUES(preco), desconto_usados=VALUES(desconto_usados);
INSERT INTO Produto 
(id, nome, descricao, preco, tipo, categoria, data_lancamento, desconto_usados) VALUES 
(4, 'Smartphone Premium', 'Smartphone de alta qualidade.', 999.99, 'Usado', 'Telefonia', '2023-05-19', 5.00) ON DUPLICATE KEY UPDATE nome=VALUES(nome), preco=VALUES(preco), desconto_usados=VALUES(desconto_usados);
INSERT INTO Produto 
(id, nome, descricao, preco, tipo, categoria, data_lancamento, desconto_usados) VALUES 
(5, 'Impressora Laser X1000', 'Uma impressora laser rapida e de alta qualidade.', 399.99, 'Liquidacao', 'Informatica', '2023-03-19', 0.00) ON DUPLICATE KEY UPDATE nome=VALUES(nome), preco=VALUES(preco), desconto_usados=VALUES(desconto_usados);
INSERT INTO Produto 
(id, nome, descricao, preco, tipo, categoria, data_lancamento, desconto_usados) VALUES 
(6, 'Fone de Ouvido Bluetooth Pro', 'Fones de ouvido sem fio com cancelamento de ruido.', 149.99, 'Usado', 'Telefonia', '2023-08-23', 0.00) ON DUPLICATE KEY UPDATE nome=VALUES(nome), preco=VALUES(preco), desconto_usados=VALUES(desconto_usados);
INSERT INTO Produto 
(id, nome, descricao, preco, tipo, categoria, data_lancamento, desconto_usados) VALUES 
(7, 'TV LED 4K 55 polegadas', 'Uma televisao LED de alta resolucao para entretenimento em casa.', 799.99, 'Novo', 'Eletronico', '2023-09-19', 0.00) ON DUPLICATE KEY UPDATE nome=VALUES(nome), preco=VALUES(preco), desconto_usados=VALUES(desconto_usados);
INSERT INTO Produto 
(id, nome, descricao, preco, tipo, categoria, data_lancamento, desconto_usados) VALUES 
(8, 'Mouse sem Fio Ergonomico', 'Um mouse sem fio confortavel para uso diario.', 29.99, 'Promocao', 'Informática', '2023-09-19', 0.00) ON DUPLICATE KEY UPDATE nome=VALUES(nome), preco=VALUES(preco), desconto_usados=VALUES(desconto_usados);
INSERT INTO Produto 
(id, nome, descricao, preco, tipo, categoria, data_lancamento, desconto_usados) VALUES 
(9, 'Caixa de Som Bluetooth Portatil', 'Uma caixa de som portatil com conexão Bluetooth.', 59.99, 'Novo', 'Eletronico', '2023-03-10', 0.00) ON DUPLICATE KEY UPDATE nome=VALUES(nome), preco=VALUES(preco), desconto_usados=VALUES(desconto_usados);
INSERT INTO Produto 
(id, nome, descricao, preco, tipo, categoria, data_lancamento, desconto_usados) VALUES 
(10, 'Cafeteira Eletrica 1.5L', 'Uma cafeteira eletrica para preparar cafe fresco.', 49.99, 'Promocao', 'Eletrodomesticos', '2023-09-12', 0.00) ON DUPLICATE KEY UPDATE nome=VALUES(nome), preco=VALUES(preco), desconto_usados=VALUES(desconto_usados);
INSERT INTO Produto 
(id, nome, descricao, preco, tipo, categoria, data_lancamento, desconto_usados) VALUES 
(11, 'Roteador Wi-Fi Dual Band', 'Um roteador com tecnologia Dual Band para conexoes de alta velocidade.', 79.99, 'Novo', 'Informatica', '2023-09-19', 0.00) ON DUPLICATE KEY UPDATE nome=VALUES(nome), preco=VALUES(preco), desconto_usados=VALUES(desconto_usados);

INSERT INTO Caracteristica (id, nome, descricao) VALUES (1, 'Sistema Operacional', 'Android 12') ON DUPLICATE KEY UPDATE nome=VALUES(nome);
INSERT INTO Caracteristica (id, nome, descricao) VALUES (2, 'Tela', '6.5 polegadas AMOLED') ON DUPLICATE KEY UPDATE nome=VALUES(nome);
INSERT INTO Caracteristica (id, nome, descricao) VALUES (3, 'Bluetooth', 'Recursos de conectividade Bluetooth.') ON DUPLICATE KEY UPDATE nome=VALUES(nome);
INSERT INTO Caracteristica (id, nome, descricao) VALUES (4, 'Tela HD', 'Tela de alta definição para qualidade de imagem superior.') ON DUPLICATE KEY UPDATE nome=VALUES(nome);
INSERT INTO Caracteristica (id, nome, descricao) VALUES (5, 'Bateria de Longa Duracao', 'Bateria com longa autonomia para uso prolongado.') ON DUPLICATE KEY UPDATE nome=VALUES(nome);
INSERT INTO Caracteristica (id, nome, descricao) VALUES (6, 'Camera de 48MP', 'Câmera com resolução de 48 megapixels para fotos detalhadas.') ON DUPLICATE KEY UPDATE nome=VALUES(nome);
INSERT INTO Caracteristica (id, nome, descricao) VALUES (7, 'Armazenamento SSD', 'Armazenamento em estado solido para alta velocidade de acesso.') ON DUPLICATE KEY UPDATE nome=VALUES(nome);
INSERT INTO Caracteristica (id, nome, descricao) VALUES (8, 'À Prova de agua', 'Proteção contra água e umidade.') ON DUPLICATE KEY UPDATE nome=VALUES(nome);
INSERT INTO Caracteristica (id, nome, descricao) VALUES (9, 'Tela Touchscreen', 'Tela sensivel ao toque para interação intuitiva.') ON DUPLICATE KEY UPDATE nome=VALUES(nome);
INSERT INTO Caracteristica (id, nome, descricao) VALUES (10, 'Processador de Alto Desempenho', 'Processador potente para tarefas exigentes.') ON DUPLICATE KEY UPDATE nome=VALUES(nome);
INSERT INTO Caracteristica (id, nome, descricao) VALUES (11, 'Design Compacto', 'Design compacto e portatil.') ON DUPLICATE KEY UPDATE nome=VALUES(nome);
INSERT INTO Caracteristica (id, nome, descricao) VALUES (12, 'Sistema Operacional Android', 'Sistema operacional Android para flexibilidade e aplicativos.') ON DUPLICATE KEY UPDATE nome=VALUES(nome);

INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (1, 1, 1) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (2, 1, 2) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (3, 1, 5) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (4, 2, 5) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (5, 3, 5) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (6, 4, 5) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (7, 5, 3) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (8, 6, 3) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (9, 7, 4) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (10, 8, 8) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (11, 9, 3) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (12, 10, 11) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (13, 11, 11) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (14, 1, 6) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (15, 3, 7) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (16, 4, 9) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (17, 3, 10) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);
INSERT INTO Produto_Caracteristica (id, id_produto, id_caracteristica) VALUES (18, 4, 12) ON DUPLICATE KEY UPDATE id_produto=VALUES(id_produto);

INSERT INTO Loja (id, nome, telefone, rua, numero, bairro, cep, complemento, cidade) VALUES (1, 'Amazon(as)', '123-456-7890', 'Rua 1', 123, 'Bairro A', '12345-678', 'Complemento A', 'Jaragua do Sul') ON DUPLICATE KEY UPDATE nome=VALUES(nome);
INSERT INTO Loja (id, nome, telefone, rua, numero, bairro, cep, complemento, cidade) VALUES (2, 'Amazon(as)', '987-654-3210', 'Rua 2', 456, 'Bairro B', '56789-012', 'Complemento B', 'Sao Paulo') ON DUPLICATE KEY UPDATE nome=VALUES(nome);
INSERT INTO Loja (id, nome, telefone, rua, numero, bairro, cep, complemento, cidade) VALUES (3, 'Amazon(as)', '555-555-5555', 'Rua 3', 789, 'Bairro C', '99999-999', 'Complemento C', 'Rio de Janeiro') ON DUPLICATE KEY UPDATE nome=VALUES(nome);
INSERT INTO Loja (id, nome, telefone, rua, numero, bairro, cep, complemento, cidade) VALUES (4, 'Amazon(as)', '111-222-3333', 'Rua 4', 101, 'Bairro D', '11111-222', 'Complemento D', 'Salvador') ON DUPLICATE KEY UPDATE nome=VALUES(nome);

INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (1, 1, 0) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (1, 2, 1) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (1, 3, 25) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (1, 4, 10) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (2, 1, 5) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (3, 4, 10) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (4, 1, 20) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (5, 2, 0) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (6, 2, 10) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (7, 3, 5) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (8, 4, 2) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (8, 3, 5) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (9, 3, 0) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (9, 4, 6) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (10, 1, 8) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (10, 2, 1) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (10, 3, 2) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (11, 2, 10) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);
INSERT INTO Estoque (id_produto, id_loja, quantidade_disponivel) VALUES (11, 3, 3) ON DUPLICATE KEY UPDATE quantidade_disponivel=VALUES(quantidade_disponivel);

-- Clientes para teste (Senha plana: '123456')
-- Senha hash gerada por password_hash('123456', PASSWORD_DEFAULT)
INSERT INTO Cliente (nome, email, telefone, senha_hash) VALUES
('Joao Silva', 'joao@teste.com', '11900001111', '$2y$10$tMh4b8j2R.K.2WlF8eN2iO.H7M.E8uH1c/k6p2G8q.q2L/h/L.O4')
ON DUPLICATE KEY UPDATE nome=VALUES(nome);
INSERT INTO Cliente (nome, email, telefone, senha_hash) VALUES
('Maria Cliente', 'maria@teste.com', '21900002222', '$2y$10$tMh4b8j2R.K.2WlF8eN2iO.H7M.E8uH1c/k6p2G8q.q2L/h/L.O4')
ON DUPLICATE KEY UPDATE nome=VALUES(nome);