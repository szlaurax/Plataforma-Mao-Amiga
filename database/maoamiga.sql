-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 08/12/2025 às 02:10
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `maoamiga`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `avaliacoes`
--

CREATE TABLE `avaliacoes` (
  `idAvaliacao` int(11) NOT NULL,
  `idContratacao` int(11) NOT NULL,
  `idAvaliador` int(11) NOT NULL,
  `nota` int(11) DEFAULT NULL CHECK (`nota` between 1 and 5),
  `comentario` text DEFAULT NULL,
  `dataAvaliacao` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `categorias`
--

CREATE TABLE `categorias` (
  `idCategoria` int(11) NOT NULL,
  `nomeCategoria` varchar(100) NOT NULL,
  `icone` varchar(50) DEFAULT NULL,
  `descricao` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `categorias`
--

INSERT INTO `categorias` (`idCategoria`, `nomeCategoria`, `icone`, `descricao`) VALUES
(1, 'Cuidados e Suporte', '❤️', 'Acompanhamento e auxílio em necessidades diárias para idosos e crianças'),
(2, 'Serviços Gerais', '🔧', 'Pequenos reparos, manutenção, jardinagem e tarefas domésticas manuais'),
(3, 'Mobilidade e Transporte', '🚗', 'Acompanhamento, caronas e auxílio em pequenas mudanças ou entregas'),
(4, 'Tecnologia', '💻', 'Suporte técnico, instalação de software e auxílio básico com dispositivos'),
(5, 'Supermercado', '🛒', 'Ajuda com compras e entrega de itens de supermercado, farmácia ou lojas'),
(6, 'Administração', '📋', 'Organização de documentos, preenchimento de formulários e tarefas de escritório'),
(7, 'Tempo Livre e Hobbies', '🎨', 'Companhia para lazer, caminhadas, hobbies criativos ou projetos pessoais'),
(8, 'Estética e Bem-Estar', '💆', 'Serviços de beleza, massagens e cuidados pessoais básicos a domicílio');

-- --------------------------------------------------------

--
-- Estrutura para tabela `contratacoes`
--

CREATE TABLE `contratacoes` (
  `idContratacao` int(11) NOT NULL,
  `idServico` int(11) NOT NULL,
  `idSolicitante` int(11) NOT NULL,
  `dataContratacao` timestamp NOT NULL DEFAULT current_timestamp(),
  `dataAgendada` datetime DEFAULT NULL,
  `status` enum('pendente','confirmado','em_andamento','concluido','cancelado') DEFAULT 'pendente',
  `valorFinal` decimal(10,2) DEFAULT NULL,
  `observacoes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `contratacoes`
--

INSERT INTO `contratacoes` (`idContratacao`, `idServico`, `idSolicitante`, `dataContratacao`, `dataAgendada`, `status`, `valorFinal`, `observacoes`) VALUES
(1, 6, 1, '2025-12-07 23:38:37', '2025-12-16 11:00:00', 'pendente', 500.00, 'Rua Papa JoÃ£o Paulo, 678'),
(2, 7, 8, '2025-12-08 00:17:16', '2025-12-23 10:00:00', 'pendente', 150.00, 'Rua Papa JoÃ£o Paulo, 345'),
(3, 8, 8, '2025-12-08 00:21:16', '2025-12-10 13:00:00', 'confirmado', 40.00, 'Rua Papa JoÃ£o Paulo, 345'),
(4, 7, 9, '2025-12-08 00:57:09', '2025-12-14 14:30:00', 'cancelado', 150.00, 'Rua Rio de Janeiro, 790');

-- --------------------------------------------------------

--
-- Estrutura para tabela `servicos`
--

CREATE TABLE `servicos` (
  `idServico` int(11) NOT NULL,
  `idPrestador` int(11) NOT NULL,
  `tipoServico` varchar(100) NOT NULL,
  `descricao` text DEFAULT NULL,
  `precoEstimado` decimal(10,2) DEFAULT NULL,
  `tempoEstimado` varchar(50) DEFAULT NULL,
  `disponibilidade` varchar(100) DEFAULT NULL,
  `status` enum('ativo','inativo','pausado') DEFAULT 'ativo',
  `dataCriacao` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `servicos`
--

INSERT INTO `servicos` (`idServico`, `idPrestador`, `tipoServico`, `descricao`, `precoEstimado`, `tempoEstimado`, `disponibilidade`, `status`, `dataCriacao`) VALUES
(1, 1, 'Jardinagem', 'Serviço completo de jardinagem incluindo poda, plantio e manutenção. Trabalho realizado com equipamentos profissionais.', 150.00, '2-3 horas', NULL, 'ativo', '2025-12-07 02:34:46'),
(2, 2, 'Encanamento', 'Conserto de vazamentos, instalação de torneiras e registros, desentupimento. Atendimento rápido e eficiente.', 120.00, '1-2 horas', NULL, 'ativo', '2025-12-07 02:34:46'),
(3, 3, 'Limpeza Residencial', 'Limpeza completa de residências, incluindo cozinha, banheiros, quartos e áreas comuns. Produtos de limpeza inclusos.', 200.00, '3-4 horas', NULL, 'ativo', '2025-12-07 02:34:46'),
(4, 4, 'Aulas de Informática', 'Ensino básico de computador, internet, redes sociais e aplicativos para todas as idades. Paciência e didática.', 80.00, '1 hora', NULL, 'ativo', '2025-12-07 02:34:46'),
(5, 5, 'Eletricista', 'Instalação e manutenção elétrica residencial. Troca de lâmpadas, tomadas, disjuntores e pequenos reparos.', 100.00, '1-2 horas', NULL, 'ativo', '2025-12-07 02:34:46'),
(6, 1, 'Pintura', 'Pintura de paredes internas e externas. Orçamento inclui tinta e materiais.', 500.00, '1 dia', NULL, 'ativo', '2025-12-07 02:34:46'),
(7, 2, 'Cuidador de Idosos', 'Acompanhamento, auxílio com medicamentos, higiene pessoal e companhia para idosos.', 150.00, '4 horas', NULL, 'ativo', '2025-12-07 02:34:46'),
(8, 3, 'Passear com Pets', 'Passeio com cães de pequeno e médio porte. Experiência com animais.', 40.00, '30 minutos', NULL, 'ativo', '2025-12-07 02:34:46'),
(9, 3, 'Maquiagem Festa de Debutante', 'Maquiagem Profissional para meninas que vÃ£o ter sua tÃ£o sonhada festa de 15 anos', 150.00, '2 horas', NULL, 'ativo', '2025-12-08 00:34:42'),
(10, 9, 'TÃ©cnico de Computador', 'ManutenÃ§Ã£o geral de computadores, InstalaÃ§Ã£o (atualizaÃ§Ã£o) do Windows, Limpeza de peÃ§a e etc...', 100.00, '3 horas', NULL, 'ativo', '2025-12-08 01:00:08');

-- --------------------------------------------------------

--
-- Estrutura para tabela `servico_categoria`
--

CREATE TABLE `servico_categoria` (
  `idServico` int(11) NOT NULL,
  `idCategoria` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `servico_categoria`
--

INSERT INTO `servico_categoria` (`idServico`, `idCategoria`) VALUES
(1, 2),
(2, 2),
(3, 2),
(4, 4),
(5, 2),
(6, 2),
(7, 1),
(8, 7),
(9, 8),
(10, 4);

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `idUsuario` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `sobrenome` varchar(100) NOT NULL,
  `dataNascimento` date DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `genero` varchar(10) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `endereco` varchar(255) DEFAULT NULL,
  `cidade` varchar(100) DEFAULT NULL,
  `estado` varchar(2) DEFAULT NULL,
  `cep` varchar(10) DEFAULT NULL,
  `tipoConta` enum('solicitante','prestador','ambos') DEFAULT 'solicitante',
  `dataCadastro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `usuario`
--

INSERT INTO `usuario` (`idUsuario`, `nome`, `sobrenome`, `dataNascimento`, `email`, `senha`, `genero`, `telefone`, `endereco`, `cidade`, `estado`, `cep`, `tipoConta`, `dataCadastro`) VALUES
(1, 'João', 'Silva', NULL, 'joao@email.com', '123456', NULL, '(11) 98888-8888', NULL, 'São Paulo', 'SP', NULL, 'prestador', '2025-12-07 02:34:46'),
(2, 'Maria', 'Santos', NULL, 'maria@email.com', '123456', NULL, '(11) 97777-7777', NULL, 'São Paulo', 'SP', NULL, 'prestador', '2025-12-07 02:34:46'),
(3, 'Carlos', 'Oliveira', NULL, 'carlos@email.com', '123456', NULL, '(11) 96666-6666', NULL, 'São Paulo', 'SP', NULL, 'prestador', '2025-12-07 02:34:46'),
(4, 'Ana', 'Costa', NULL, 'ana@email.com', '123456', NULL, '(11) 95555-5555', NULL, 'São Paulo', 'SP', NULL, 'prestador', '2025-12-07 02:34:46'),
(5, 'Pedro', 'Ferreira', NULL, 'pedro@email.com', '123456', NULL, '(11) 94444-4444', NULL, 'São Paulo', 'SP', NULL, 'prestador', '2025-12-07 02:34:46'),
(6, 'Jessica', 'Souza ', '2002-01-25', 'jessicasilva@gmail.com', '123456', NULL, '11983685241', 'Rua Papa JoÃ£o Paulo, 345 ', 'Guarulhos', 'SP', '08623456', 'solicitante', '2025-12-08 00:10:53'),
(8, 'Matheus', 'Santos Barros', '2004-07-13', 'matheus@gmail.com', '123456', NULL, '11967542987', 'Rua Papa JoÃ£o Paulo, 378', 'Guarulhos', 'SP', '08623456', 'solicitante', '2025-12-08 00:16:12'),
(9, 'Amanda', 'Barros', '1999-05-21', 'amandabarros@email.com', '123456', NULL, '11965472347', 'Rua Rio de Janeiro, 790', 'Aruja', 'SP', '12345678', 'solicitante', '2025-12-08 00:55:39');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `avaliacoes`
--
ALTER TABLE `avaliacoes`
  ADD PRIMARY KEY (`idAvaliacao`),
  ADD KEY `idContratacao` (`idContratacao`),
  ADD KEY `idAvaliador` (`idAvaliador`);

--
-- Índices de tabela `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`idCategoria`);

--
-- Índices de tabela `contratacoes`
--
ALTER TABLE `contratacoes`
  ADD PRIMARY KEY (`idContratacao`),
  ADD KEY `idServico` (`idServico`),
  ADD KEY `idSolicitante` (`idSolicitante`);

--
-- Índices de tabela `servicos`
--
ALTER TABLE `servicos`
  ADD PRIMARY KEY (`idServico`),
  ADD KEY `idPrestador` (`idPrestador`);

--
-- Índices de tabela `servico_categoria`
--
ALTER TABLE `servico_categoria`
  ADD PRIMARY KEY (`idServico`,`idCategoria`),
  ADD KEY `idCategoria` (`idCategoria`);

--
-- Índices de tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idUsuario`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `avaliacoes`
--
ALTER TABLE `avaliacoes`
  MODIFY `idAvaliacao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `categorias`
--
ALTER TABLE `categorias`
  MODIFY `idCategoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `contratacoes`
--
ALTER TABLE `contratacoes`
  MODIFY `idContratacao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `servicos`
--
ALTER TABLE `servicos`
  MODIFY `idServico` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `avaliacoes`
--
ALTER TABLE `avaliacoes`
  ADD CONSTRAINT `avaliacoes_ibfk_1` FOREIGN KEY (`idContratacao`) REFERENCES `contratacoes` (`idContratacao`) ON DELETE CASCADE,
  ADD CONSTRAINT `avaliacoes_ibfk_2` FOREIGN KEY (`idAvaliador`) REFERENCES `usuario` (`idUsuario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `contratacoes`
--
ALTER TABLE `contratacoes`
  ADD CONSTRAINT `contratacoes_ibfk_1` FOREIGN KEY (`idServico`) REFERENCES `servicos` (`idServico`) ON DELETE CASCADE,
  ADD CONSTRAINT `contratacoes_ibfk_2` FOREIGN KEY (`idSolicitante`) REFERENCES `usuario` (`idUsuario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `servicos`
--
ALTER TABLE `servicos`
  ADD CONSTRAINT `servicos_ibfk_1` FOREIGN KEY (`idPrestador`) REFERENCES `usuario` (`idUsuario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `servico_categoria`
--
ALTER TABLE `servico_categoria`
  ADD CONSTRAINT `servico_categoria_ibfk_1` FOREIGN KEY (`idServico`) REFERENCES `servicos` (`idServico`) ON DELETE CASCADE,
  ADD CONSTRAINT `servico_categoria_ibfk_2` FOREIGN KEY (`idCategoria`) REFERENCES `categorias` (`idCategoria`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
