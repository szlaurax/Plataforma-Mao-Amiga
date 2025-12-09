<%@page language="java" import="java.sql.*"%> 
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
// Verificar se está logado
Integer idUsuarioLogado = (Integer) session.getAttribute("idUsuario");
if (idUsuarioLogado == null) {
    response.sendRedirect("login.html?redirect=prestador_dashboard.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"
        integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
    <title>Dashboard Prestador - Mão Amiga</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #16a5a8 0%, #91d96f 100%);
            min-height: 100vh;
            padding: 20px;
        }

        /* Header */
        header {
            background: white;
            padding: 20px 8%;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 24px;
            font-weight: bold;
            color: #333;
            text-decoration: none;
        }

        .logo-icon {
            font-size: 32px;
        }

        .nav-links {
            display: flex;
            list-style: none;
            gap: 40px;
        }

        .nav-links a {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            transition: all 0.3s;
        }

        .nav-links a:hover {
            color: #16a5a8;
        }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info {
            font-size: 14px;
            color: #666;
        }

        .user-icon {
            font-size: 24px;
            cursor: pointer;
            color: #333;
            transition: color 0.3s;
            text-decoration: none;
        }
        

        .container {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }

        .card-criar {
            background: white;
            border-radius: 25px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            height: fit-content;
            cursor: pointer;
            transition: all 0.3s;
        }

        .card-criar:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.3);
        }

        .card-criar h2 {
            font-size: 22px;
            margin-bottom: 25px;
            color: #333;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .icon-criar {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #16a5a8 0%, #91d96f 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
        }

        .notificacoes {
            background: white;
            border-radius: 25px;
            padding: 25px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            margin-top: 30px;
        }

        .notificacoes h3 {
            font-size: 20px;
            margin-bottom: 20px;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .badge-notif {
            background: #dc3545;
            color: white;
            width: 25px;
            height: 25px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
        }

        .notificacao-item {
            background: #f5f5f5;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 15px;
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .notif-avatar {
            width: 50px;
            height: 50px;
            background: #d0d0d0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 25px;
            flex-shrink: 0;
        }

        .notif-texto {
            flex: 1;
        }

        .notif-texto p {
            font-size: 14px;
            color: #333;
            line-height: 1.5;
        }

        .notif-alerta {
            color: #dc3545;
            font-size: 30px;
            flex-shrink: 0;
        }

        .notif-acoes {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .btn-aceitar,
        .btn-recusar {
            padding: 10px 25px;
            border: none;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-aceitar {
            background: linear-gradient(135deg, #16a5a8 0%, #91d96f 100%);
            color: white;
        }

        .btn-recusar {
            background: #dc3545;
            color: white;
        }

        .btn-aceitar:hover,
        .btn-recusar:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .card-perfil {
            background: white;
            border-radius: 25px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            height: fit-content;
        }

        .aviso-prestador {
            background: #dc3545;
            color: white;
            padding: 15px 20px;
            border-radius: 15px;
            font-size: 13px;
            margin-bottom: 25px;
            text-align: center;
        }

        .perfil-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 30px;
        }

        .perfil-avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #16a5a8 0%, #91d96f 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
        }

        .perfil-info h2 {
            font-size: 22px;
            margin-bottom: 5px;
            color: #333;
        }

        .perfil-info p {
            font-size: 14px;
            color: #666;
        }

        .rating {
            color: #ffd700;
            font-size: 18px;
            margin-top: 5px;
        }

        .secao {
            margin-bottom: 30px;
        }

        .secao h3 {
            font-size: 18px;
            margin-bottom: 15px;
            color: #333;
        }

        .lista-servicos,
        .lista-realizados {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 15px;
        }

        .item-servico {
            padding: 10px 0;
            border-bottom: 1px solid #e0e0e0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .item-servico:last-child {
            border-bottom: none;
        }

        .bullet {
            width: 8px;
            height: 8px;
            background: #16a5a8;
            border-radius: 50%;
        }

        .item-servico span {
            font-size: 14px;
            color: #333;
        }

        .sem-dados {
            text-align: center;
            color: #999;
            padding: 20px;
            font-style: italic;
        }

        @media (max-width: 900px) {
            .container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="lado-esquerdo">
            <div class="card-criar" onclick="window.location.href='criar_servico.jsp'">
                <h2>
                    <div class="icon-criar">➕</div>
                    Quero Prestar um Serviço
                </h2>
            </div>

            <div class="notificacoes">
                <%
                try {
                    String database = "maoamiga";
                    String endereco = "jdbc:mysql://localhost:3306/" + database;
                    String usuario = "root";
                    String senha = "";
                    String driver = "com.mysql.jdbc.Driver";

                    Class.forName(driver);
                    Connection conexao = DriverManager.getConnection(endereco, usuario, senha);

                    // Buscar notificações (contratações pendentes)
                    String sqlNotif = "SELECT c.idContratacao, c.dataAgendada, c.observacoes, " +
                                      "s.tipoServico, u.nome, u.sobrenome " +
                                      "FROM contratacoes c " +
                                      "INNER JOIN servicos s ON c.idServico = s.idServico " +
                                      "INNER JOIN usuario u ON c.idSolicitante = u.idUsuario " +
                                      "WHERE s.idPrestador = ? AND c.status = 'pendente' " +
                                      "ORDER BY c.dataContratacao DESC";
                    
                    PreparedStatement stmNotif = conexao.prepareStatement(sqlNotif);
                    stmNotif.setInt(1, idUsuarioLogado);
                    ResultSet rsNotif = stmNotif.executeQuery();

                    int totalNotif = 0;
                    StringBuilder notificacoesHTML = new StringBuilder();

                    while (rsNotif.next()) {
                        totalNotif++;
                        int idContratacao = rsNotif.getInt("idContratacao");
                        String dataAgendada = rsNotif.getString("dataAgendada");
                        String observacoes = rsNotif.getString("observacoes");
                        String tipoServico = rsNotif.getString("tipoServico");
                        String nomeCliente = rsNotif.getString("nome") + " " + rsNotif.getString("sobrenome");

                        notificacoesHTML.append("<div class='notificacao-item' id='notif-" + idContratacao + "'>");
                        notificacoesHTML.append("<div class='notif-avatar'>👤</div>");
                        notificacoesHTML.append("<div class='notif-texto'>");
                        notificacoesHTML.append("<p><strong>" + nomeCliente + " quer contratar seu serviço de " + tipoServico + "</strong>");
                        notificacoesHTML.append("<br>📅 " + dataAgendada);
                        notificacoesHTML.append("<br>📍 " + observacoes + "</p>");
                        notificacoesHTML.append("<div class='notif-acoes'>");
                        notificacoesHTML.append("<button class='btn-aceitar' onclick='responderSolicitacao(" + idContratacao + ", \"confirmado\")'>Aceitar</button>");
                        notificacoesHTML.append("<button class='btn-recusar' onclick='responderSolicitacao(" + idContratacao + ", \"cancelado\")'>Recusar</button>");
                        notificacoesHTML.append("</div></div>");
                        notificacoesHTML.append("<div class='notif-alerta'>❗</div>");
                        notificacoesHTML.append("</div>");
                    }

                    rsNotif.close();
                    stmNotif.close();
                %>
                
                <h3>
                    <span>🔔</span>
                    Notificações
                    <% if (totalNotif > 0) { %>
                    <span class="badge-notif"><%= totalNotif %></span>
                    <% } %>
                </h3>

                <% if (totalNotif > 0) { %>
                    <%= notificacoesHTML.toString() %>
                <% } else { %>
                    <p class="sem-dados">Nenhuma notificação no momento</p>
                <% } %>

                <%
                    conexao.close();
                } catch (Exception e) {
                    out.print("<p style='color:red;'>Erro ao carregar notificações: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                }
                %>
            </div>
        </div>

        <div class="card-perfil">
            <div class="aviso-prestador">
                Esta é a interface para quem deseja prestar serviços, dinâmica e simples
            </div>

            <%
            try {
                String database = "maoamiga";
                String endereco = "jdbc:mysql://localhost:3306/" + database;
                String usuario = "root";
                String senha = "";
                String driver = "com.mysql.jdbc.Driver";

                Class.forName(driver);
                Connection conexao = DriverManager.getConnection(endereco, usuario, senha);

                // Buscar dados do usuário
                String sqlUser = "SELECT nome, sobrenome FROM usuario WHERE idUsuario = ?";
                PreparedStatement stmUser = conexao.prepareStatement(sqlUser);
                stmUser.setInt(1, idUsuarioLogado);
                ResultSet rsUser = stmUser.executeQuery();

                String nomeCompleto = "Usuário";
                if (rsUser.next()) {
                    nomeCompleto = rsUser.getString("nome") + " " + rsUser.getString("sobrenome");
                }
                rsUser.close();
                stmUser.close();

                // Contar serviços oferecidos
                String sqlServicos = "SELECT tipoServico FROM servicos WHERE idPrestador = ? AND status = 'ativo'";
                PreparedStatement stmServicos = conexao.prepareStatement(sqlServicos);
                stmServicos.setInt(1, idUsuarioLogado);
                ResultSet rsServicos = stmServicos.executeQuery();

                StringBuilder servicosHTML = new StringBuilder();
                int totalServicos = 0;

                while (rsServicos.next()) {
                    totalServicos++;
                    servicosHTML.append("<div class='item-servico'>");
                    servicosHTML.append("<div class='bullet'></div>");
                    servicosHTML.append("<span>" + rsServicos.getString("tipoServico") + "</span>");
                    servicosHTML.append("</div>");
                }

                rsServicos.close();
                stmServicos.close();

                // Contar serviços concluídos
                String sqlConcluidos = "SELECT COUNT(*) as total FROM contratacoes c " +
                                      "INNER JOIN servicos s ON c.idServico = s.idServico " +
                                      "WHERE s.idPrestador = ? AND c.status = 'concluido'";
                PreparedStatement stmConcluidos = conexao.prepareStatement(sqlConcluidos);
                stmConcluidos.setInt(1, idUsuarioLogado);
                ResultSet rsConcluidos = stmConcluidos.executeQuery();

                int totalConcluidos = 0;
                if (rsConcluidos.next()) {
                    totalConcluidos = rsConcluidos.getInt("total");
                }
                rsConcluidos.close();
                stmConcluidos.close();
            %>

            <div class="perfil-header">
                <div class="perfil-avatar">👤</div>
                <div class="perfil-info">
                    <h2><%= nomeCompleto %></h2>
                    <p>Prestador de serviços</p>
                    <div class="rating">
                        ★★★★☆
                    </div>
                </div>
            </div>

            <div class="secao">
                <h3>Serviços oferecidos</h3>
                <div class="lista-servicos">
                    <% if (totalServicos > 0) { %>
                        <%= servicosHTML.toString() %>
                    <% } else { %>
                        <p class="sem-dados">Você ainda não cadastrou nenhum serviço</p>
                    <% } %>
                </div>
            </div>

            <div class="secao">
                <h3>Estatísticas</h3>
                <div class="lista-realizados">
                    <div class="item-servico">
                        <div class="bullet"></div>
                        <span><%= totalConcluidos %> serviços concluídos</span>
                    </div>
                    <div class="item-servico">
                        <div class="bullet"></div>
                        <span>98% de satisfação</span>
                    </div>
                    <div class="item-servico">
                        <div class="bullet"></div>
                        <span>Membro desde 2024</span>
                    </div>
                </div>
            </div>

            <%
                conexao.close();
            } catch (Exception e) {
                out.print("<p style='color:red;'>Erro: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
            %>
        </div>
    </div>

    <script>
        function responderSolicitacao(idContratacao, novoStatus) {
            const acao = novoStatus === 'confirmado' ? 'aceitar' : 'recusar';
            
            if(confirm('Deseja ' + acao + ' esta solicitação?')) {
                // Enviar para o servidor
                fetch('responder_contratacao.jsp?id=' + idContratacao + '&status=' + novoStatus)
                    .then(response => response.text())
                    .then(data => {
                        if (data.includes('sucesso')) {
                            alert('Solicitação ' + (acao === 'aceitar' ? 'aceita' : 'recusada') + ' com sucesso!');
                            document.getElementById('notif-' + idContratacao).remove();
                            
                            // Atualizar badge
                            const badge = document.querySelector('.badge-notif');
                            if (badge) {
                                const count = parseInt(badge.textContent) - 1;
                                if (count <= 0) {
                                    badge.remove();
                                } else {
                                    badge.textContent = count;
                                }
                            }
                        } else {
                            alert('Erro ao processar a solicitação');
                        }
                    })
                    .catch(error => {
                        alert('Erro: ' + error);
                    });
            }
        }
    </script>
</body>
</html>