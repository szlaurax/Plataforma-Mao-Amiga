📖 README:Plataforma Conecta Comunidade


🌐 1. Visão Geral do Projeto
A Plataforma Conecta Comunidade é uma aplicação web desenvolvida como Produto Mínimo Viável (MVP). Seu principal objetivo é resolver a dificuldade de encontrar micro-serviços e ajuda voluntária de forma organizada e segura dentro de comunidades locais. O sistema funciona como um marketplace que conecta diretamente usuários que Solicitam tarefas (reparos, compras, suporte tecnológico) com Prestadores/Voluntários que oferecem esses serviços na mesma vizinhança.

O projeto visa demonstrar a construção de um ciclo de desenvolvimento web completo (Full Stack) utilizando uma arquitetura robusta de três camadas.


🛠️ 2. Stack Tecnológica e Funções
O projeto é construído sobre uma arquitetura Web tradicional baseada em Java/JSP e MySQL.

Tecnologias Utilizadas:
Banco de Dados (MySQL/SQL): Responsável pelo gerenciamento de dados estruturados (Usuários, Tarefas, Agendamentos, Avaliações) e pela garantia da integridade referencial através do uso de Chaves Primárias e Estrangeiras (PK, FK).

Backend / Servidor (JSP / Servlets - Java): Executa a lógica de negócios, gerencia a autenticação e o controle de sessão, e realiza a comunicação com o MySQL via JDBC (Java Database Connectivity). O servidor utilizado é o Apache Tomcat.

Frontend (HTML5 e CSS3): Cria a estrutura semântica das páginas e aplica a estilização responsiva do layout.

Interatividade (JavaScript - Vanilla JS / AJAX): Implementa a validação de formulários, os filtros dinâmicos de tarefas no Dashboard e realiza a comunicação assíncrona (AJAX) com o Servidor, melhorando a experiência do usuário.


🔑 3. Funcionalidades Implementadas (Escopo do MVP)
O escopo do MVP abrange todas as funcionalidades necessárias para simular o ciclo de vida completo de um serviço comunitário:

Módulo de Autenticação: Implementa o cadastro de novos usuários (com seleção de perfil Solicitante/Prestador) e o processo de Login/Logout seguro.

Módulo de Tarefas: Permite a publicação de novas tarefas pelo Solicitante e a visualização das tarefas abertas pelo Prestador no Dashboard.

Filtros Dinâmicos: Possui funcionalidade de filtragem de tarefas por Tipo de Serviço e Localização (CEP/Bairro), utilizando AJAX para atualizar a lista sem recarregar a página.

Módulo de Agendamento: Permite que o Prestador se candidate e aceite a tarefa (relação 1:1), atualizando o status do serviço.

Sistema de Reputação: Implementa o sistema de Avaliação e Feedback (notas 1 a 5 e comentários) após a conclusão do serviço.

Habilidades: Inclui o módulo para o Prestador definir e listar os serviços que OFERECE (modelado através de uma tabela N:N).



📊 4. Modelo de Dados (DER)
O projeto segue um Modelo Entidade-Relacionamento (DER) robusto, onde a integridade dos dados é garantida pelas seguintes entidades e relacionamentos:

Entidades Chave: USUARIO, CONTRATACOES, CATEGORIAS, AVALIACOES, e as tabelas de suporte SERVICO e SERVICO_CATEGORIA.

Relacionamentos Cruciais: O modelo define que o USUARIO SOLICITA (1:N) a CONTRATACOES; O USUARIO (Prestador) OFERECE (N:N) as CATEGORIAS de serviço. Este relacionamento é resolvido pela tabela de junção SERVICO_CATEGORIA;  A CONTRATACOES RESOLVE (1:1) o AGENDAMENTO; O USUARIO (Prestador) PRESTA (1:N) o serviço, sendo ligado ao AGENDAMENTO.

Rastreabilidade: A tabela AVALIACAO possui as Chaves Estrangeiras (id_avaliador e id_avaliado) para registrar quem avaliou quem, garantindo a transparência do sistema.



⚙️ 5. Guia de Instalação e Execução
Para rodar o projeto localmente, são necessários os seguintes passos:

Requisitos: Instale Java JDK, o servidor Apache Tomcat e o MySQL Server.

Banco de Dados: Crie o banco de dados (conecta_comunidade) e execute os comandos CREATE TABLE (disponíveis na documentação do projeto, pasta /docs/sql) para construir todas as tabelas.

Configuração JDBC: Adicione o driver JDBC do MySQL (.jar) ao seu projeto e atualize as credenciais de conexão (URL, usuário e senha do MySQL) no arquivo de configuração Java.

Implantação: Compile o projeto na sua IDE e faça o deploy do arquivo .war no diretório webapps do Apache Tomcat.

Acesso: Inicie o servidor Tomcat e acesse o projeto através do navegador (Ex: http://localhost:8080/nome-do-projeto/index.jsp).



🤝 6. Contato e Licença
Desenvolvedores: Laura Gonçalves David, Emanuelly da Silva e Isabella do Nascimento

Contato:lauragoncalvesdavid891@gmail.com

Este projeto está sob a Licença MIT.
