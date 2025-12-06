<div align="center">

# 🛒 Loja Online  
### Sistema de Loja Virtual + Banco de Dados Relacional e Não Relacional

Projeto desenvolvido para disciplina de **Banco de Dados**, unindo MySQL e MongoDB, com uma interface simples feita em PHP.

<br>

<img src="https://img.shields.io/badge/Status-Em%20Desenvolvimento-blue?style=for-the-badge">
<img src="https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white">
<img src="https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white">
<img src="https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white">

</div>

---

# 📘 Sobre o Projeto

Este projeto tem como objetivo demonstrar a integração entre:

✔ **Banco Relacional (MySQL)** → Para dados estruturados como produtos, lojas e estoque  
✔ **Banco Não Relacional (MongoDB Atlas)** → Para dados flexíveis como características extras dos produtos  
✔ **Aplicação em PHP** → Responsável pela exibição dos produtos e consulta ao banco  

A proposta é criar uma **Loja Online funcional**, onde o sistema utiliza o que cada tipo de banco oferece de melhor.

---

# 🧰 Tecnologias Utilizadas

| Categoria | Ferramenta |
|---------|------------|
| Linguagem Backend | **PHP** |
| Banco Relacional | **MySQL** |
| Banco Não Relacional | **MongoDB Atlas** |
| Ambiente de Execução | **XAMPP (Apache + MySQL)** |
| Versionamento | **Git / GitHub** |

---

# 🗂 Estrutura do Banco (MySQL)

O banco utilizado é **`loja_online`** e possui as seguintes tabelas principais:

### 🛍 `produto`
- id  
- nome  
- descrição  
- preço  
- tipo (ENUM: Novo, Usado, Liquidação, etc.)  
- categoria (SET: Eletrônico, Telefonia, Informática, etc.)  
- data_de_lançamento  
- desconto  

---

### 🧩 `caracteristica`
- id  
- nome  
- descrição  

---

### 🔗 `produto_caracteristica`
Relaciona produtos ⇄ características.

---

### 🏬 `loja`
- id  
- nome  
- telefone  
- endereço completo  

---

### 📦 `estoque`
- id  
- id_produto  
- id_loja  
- quantidade_disponivel  

---

# 💾 Arquivos Importantes do Repositório

- **`lojaEletronicos.sql`** – script para criar o banco e tabelas  
- **`esquema_logico.png`** – diagrama do banco de dados  
- Código PHP da aplicação  
- Conexões MySQL e MongoDB  

---

# 🚀 Como Rodar o Projeto Localmente

### 1️⃣ Instale o XAMPP (ou outro ambiente Apache + MySQL)

### 2️⃣ Importe o banco:
No phpMyAdmin:
