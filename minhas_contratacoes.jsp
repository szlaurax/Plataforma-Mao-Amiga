<%@page language="java" import="java.sql.*"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
Integer idUsuario = (Integer) session.getAttribute("idUsuario");
String nomeUsuario = (String) session.getAttribute("nomeUsuario");
if(idUsuario == null) {
    response.sendRedirect("login.html?redirect=minhas_contratacoes.jsp");
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
    <title>Minhas Contratações - Mão Amiga</title>
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
        }

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

        .user-menu {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info {
            font-size: 14px;
            color: #666;
        }

        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            background-color: white;
            min-width: 200px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
            border-radius: 10px;
            z-index: 1;
            margin-top: 10px;
        }

        .dropdown-content a {
            color: #333;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .user-icon {
            font-size: 24px;
            cursor: pointer;
            color: #333;
            text-decoration: none;
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .page-header {
            text-align: center;
            color: white;
            margin-bottom: 40px;
        }

        .page-header h1 {
            font-size: 36px;
            margin-bottom: 10px;
        }

        .page-header p {
            font-size: 16px;
            opacity: 0.9;
        }

        .filtros-status {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-bottom: 30px;
        }

        .btn-filtro-status {
            padding: 10px 25px;
            background: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-filtro-status:hover,
        .btn-filtro-status.active {
            background: #16a5a8;
            color: white;
            transform: translateY(-2px);
        }

        .contratacoes-grid {
            display: grid;
            gap: 20px;
        }

        .contratacao-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }

        .contratacao-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
        }

        .contratacao-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .contratacao-numero {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }

        .status-badge {
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-pendente {
            background: #fff3cd;
            color: #856404;
        }

        .status-confirmado {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-concluido {
            background: #d4edda;
            color: #155724;
        }

        .status-cancelado {
            background: #f8d7da;
            color: #721c24;
        }

        .contratacao-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-icon {
            width: 35px;
            height: 35px;
            background: #f5f5f5;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }

        .info-text strong {
            display: block;
            font-size: 12px;
            color: #666;
            margin-bottom: 3px;
        }

        .info-text span {
            font-size: 14px;
            color: #333;
        }

        .contratacao-acoes {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .btn-acao {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-avaliar {
            background: #16a5a8;
            color: white;
        }

        .btn-avaliar:hover {
            background: #138b8e;
            transform: translateY(-2px);
        }

        .btn-detalhes {
            background: #6c757d;
            color: white;
        }

        .btn-detalhes:hover {
            background: #5a6268;
        }

        .btn-cancelar {
            background: #dc3545;
            color: white;
        }

        .btn-cancelar:hover {
            background: #c82333;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 20px;
        }

        .empty-state-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            font-size: 24px;
            color: #333;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #666;
            margin-bottom: 30px;
        }

        .btn-novo-servico {
            display: inline-block;
            padding: 15px 40px;
            background: linear-gradient(135deg, #16a5a8 0%, #91d96f 100%);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-novo-servico:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(22, 165, 168, 0.4);
        }

        @media (max-width: 768px) {
            .nav-links {
                display: none;
            }
            
            .contratacao-info {
                grid-template-columns: 1fr;
            }
            
            .contratacao-acoes {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <header>
        <nav>
            <a href="index.jsp" class="logo">
                <i class="fa-solid fa-people-robbery" id="nav-logo">Mao amiga</i>
            </a>

            <ul class="nav-links">
                <li><a href="index.jsp">Inicio</a></li>
                <li><a href="servicos_lista.jsp">Contratar Serviços</a></li>
                <li><a href="prestador_dashboard.jsp">Prestadores</a></li>
            </ul>

            <div class="user-menu">
                <span class="user-info">Olá, <%= nomeUsuario %></span>
                <div class="dropdown">
                    <a href="#" class="user-icon">👤</a>
                    <div class="dropdown-content">
                        <a href="minhas_contratacoes.jsp">Minhas Contratações</a>
                        <a href="perfil.jsp">Meu Perfil</a>
                        <a href="logout.jsp">Sair</a>
                    </div>
                </div>
            </div>
        </nav>
    </header>

    <div class="container">
        <div class="page-header">
            <h1>Minhas Contratações</h1>
            <p>Acompanhe o status de todos os seus serviços contratados</p>
        </div>

        <div class="filtros-status">
            <button class="btn-filtro-status active" onclick="filtrarStatus('todos')">Todos</button>
            <button class="btn-filtro-status" onclick="filtrarStatus('pendente')">Pendentes</button>
            <button class="btn-filtro-status" onclick="filtrarStatus('confirmado')">Confirmados</button>
            <button class="btn-filtro-status" onclick="filtrarStatus('concluido')">Concluídos</button>
            <button class="btn-filtro-status" onclick="filtrarStatus('cancelado')">Cancelados</button>
        </div>

        <div class="contratacoes-grid" id="contratacoes-grid">
            <%
            try {
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/maoamiga", "root", "");
                
                String sql = "SELECT c.idContratacao, c.dataAgendada, c.valorFinal, c.status, c.observacoes, " +
                             "s.tipoServico, u.nome, u.sobrenome, u.telefone " +
                             "FROM contratacoes c " +
                             "INNER JOIN servicos s ON c.idServico = s.idServico " +
                             "INNER JOIN usuario u ON s.idPrestador = u.idUsuario " +
                             "WHERE c.idSolicitante = ? " +
                             "ORDER BY c.dataContratacao DESC";
                
                PreparedStatement stm = conn.prepareStatement(sql);
                stm.setInt(1, idUsuario);
                ResultSet rs = stm.executeQuery();
                
                boolean temContratacoes = false;
                
                while(rs.next()) {
                    temContratacoes = true;
                    int idContratacao = rs.getInt("idContratacao");
                    String dataAgendada = rs.getString("dataAgendada");
                    double valorFinal = rs.getDouble("valorFinal");
                    String status = rs.getString("status");
                    String observacoes = rs.getString("observacoes");
                    String tipoServico = rs.getString("tipoServico");
                    String nomePrestador = rs.getString("nome") + " " + rs.getString("sobrenome");
                    String telefone = rs.getString("telefone");
                    
                    String statusClass = "status-" + status;
                    String statusTexto = status.substring(0, 1).toUpperCase() + status.substring(1);
            %>
            
            <div class="contratacao-card" data-status="<%= status %>">
                <div class="contratacao-header">
                    <span class="contratacao-numero">Contratação #<%= idContratacao %></span>
                    <span class="status-badge <%= statusClass %>"><%= statusTexto %></span>
                </div>

                <div class="contratacao-info">
                    <div class="info-item">
                        <div class="info-icon">🔧</div>
                        <div class="info-text">
                            <strong>Serviço</strong>
                            <span><%= tipoServico %></span>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">👤</div>
                        <div class="info-text">
                            <strong>Prestador</strong>
                            <span><%= nomePrestador %></span>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">📅</div>
                        <div class="info-text">
                            <strong>Data Agendada</strong>
                            <span><%= dataAgendada %></span>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">💰</div>
                        <div class="info-text">
                            <strong>Valor</strong>
                            <span>R$ <%= String.format("%.2f", valorFinal) %></span>
                        </div>
                    </div>

                    <% if(telefone != null) { %>
                    <div class="info-item">
                        <div class="info-icon">📞</div>
                        <div class="info-text">
                            <strong>Telefone</strong>
                            <span><%= telefone %></span>
                        </div>
                    </div>
                    <% } %>

                    <% if(observacoes != null && !observacoes.trim().isEmpty()) { %>
                    <div class="info-item" style="grid-column: 1/-1;">
                        <div class="info-icon">📝</div>
                        <div class="info-text">
                            <strong>Endereço/Observações</strong>
                            <span><%= observacoes %></span>
                        </div>
                    </div>
                    <% } %>
                </div>

                <div class="contratacao-acoes">
                    <% if("concluido".equals(status)) { %>
                        <button class="btn-acao btn-avaliar" onclick="window.location.href='avaliacao.html?id=<%= idContratacao %>'">
                            ⭐ Avaliar Serviço
                        </button>
                    <% } %>
                    
                    <% if("pendente".equals(status)) { %>
                        <button class="btn-acao btn-cancelar" onclick="cancelarContratacao(<%= idContratacao %>)">
                            ❌ Cancelar
                        </button>
                    <% } %>
                </div>
            </div>

            <%
                }
                
                if(!temContratacoes) {
            %>
            
            <div class="empty-state">
                <div class="empty-state-icon">📋</div>
                <h3>Nenhuma contratação encontrada</h3>
                <p>Você ainda não contratou nenhum serviço. Que tal começar agora?</p>
                <a href="servicos_lista.jsp" class="btn-novo-servico">Contratar Serviço</a>
            </div>

            <%
                }
                
                rs.close();
                stm.close();
                conn.close();
                
            } catch(Exception e) {
                out.print("<div class='empty-state'>");
                out.print("<h3>Erro ao carregar contratações</h3>");
                out.print("<p>" + e.getMessage() + "</p>");
                out.print("</div>");
                e.printStackTrace();
            }
            %>
        </div>
    </div>

    <script>
        function filtrarStatus(status) {
            const cards = document.querySelectorAll('.contratacao-card');
            const buttons = document.querySelectorAll('.btn-filtro-status');
            
            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            cards.forEach(card => {
                if(status === 'todos' || card.dataset.status === status) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        function cancelarContratacao(id) {
            if(confirm('Tem certeza que deseja cancelar esta contratação?')) {
                window.location.href = 'cancelar_contratacao.jsp?id=' + id;
            }
        }
    </script>
</body>
</html>