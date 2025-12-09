<%@page language="java" import="java.sql.*"%> 
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
Integer idUsuario = (Integer) session.getAttribute("idUsuario");
String nomeUsuario = (String) session.getAttribute("nomeUsuario");
if(idUsuario == null) {
    response.sendRedirect("login.html?redirect=servicos_lista.jsp");
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
    
    <title>Encontre o Serviço Ideal - Mão Amiga</title>
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
            transition: all 0.3s;
        }

        .dropdown-content a:hover {
            background-color: #f1f1f1;
            color: #16a5a8;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .dropdown::after {
    content: '';
    position: absolute;
    top: 100%;
    right: 0;
    width: 100%;
    height: 20px;
    background: transparent;
}

.dropdown-content {
    display: none;
    position: absolute;
    right: 0;
    background-color: white;
    min-width: 220px;
    box-shadow: 0 8px 16px rgba(0,0,0,0.2);
    border-radius: 10px;
    z-index: 9999;
    margin-top: 15px;
    padding: 8px 0;
}

.dropdown:hover .dropdown-content,
.dropdown-content:hover {
    display: block;
}

        .container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            padding: 40px 8%;
            max-width: 1400px;
            margin: 0 auto;
        }

        .lado-esquerdo {
            background: white;
            border-radius: 25px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            height: fit-content;
        }

        .lado-esquerdo h1 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
        }

        .filtros {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .btn-filtro {
            background: #E8E8E8;
            border: none;
            border-radius: 10px;
            width: 50px;
            height: 50px;
            cursor: pointer;
            font-size: 20px;
            transition: all 0.3s;
        }

        .btn-filtro:hover {
            background: #D0D0D0;
        }

        .search-box {
            flex: 1;
        }

        .search-box input {
            width: 100%;
            padding: 12px 20px;
            border: none;
            border-radius: 25px;
            background: #E8E8E8;
            font-size: 14px;
            outline: none;
        }

        .lista-servicos {
            display: flex;
            flex-direction: column;
            gap: 15px;
            max-height: 500px;
            overflow-y: auto;
            padding-right: 10px;
        }

        .lista-servicos::-webkit-scrollbar {
            width: 8px;
        }

        .lista-servicos::-webkit-scrollbar-thumb {
            background: #16a5a8;
            border-radius: 10px;
        }

        .servico-item {
            background: #F5F5F5;
            border-radius: 15px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .servico-item:hover {
            background: #E8E8E8;
            transform: translateX(5px);
        }

        .servico-item.active {
            background: #16a5a8;
            color: white;
        }

        .servico-header {
            margin-bottom: 10px;
        }

        .servico-tipo {
            font-weight: 600;
            font-size: 14px;
        }

        .prestador-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .avatar {
            width: 50px;
            height: 50px;
            background: #D0D0D0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }

        .info h3 {
            font-size: 16px;
            margin-bottom: 5px;
        }

        .info p {
            font-size: 12px;
            color: #666;
            line-height: 1.4;
        }

        .servico-item.active .info p {
            color: rgba(255, 255, 255, 0.9);
        }

        .lado-direito {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .info-box {
            background: #FF4757;
            color: white;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(255, 71, 87, 0.3);
        }

        .detalhes-servico {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .prestador-detalhes {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 25px;
        }

        .avatar-grande {
            width: 80px;
            height: 80px;
            background: #E8E8E8;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
        }

        .prestador-detalhes h2 {
            font-size: 24px;
            margin-bottom: 5px;
            color: #333;
        }

        .prestador-detalhes p {
            font-size: 14px;
            color: #666;
        }

        .descricao-box {
            background: #F5F5F5;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 25px;
        }

        .descricao-box h3 {
            font-size: 18px;
            margin-bottom: 10px;
            color: #333;
        }

        .descricao-box p {
            font-size: 14px;
            color: #666;
            line-height: 1.6;
        }

        .btn-contratar {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #16a5a8 0%, #91d96f 100%);
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(22, 165, 168, 0.3);
        }

        .btn-contratar:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(22, 165, 168, 0.4);
        }

        .btn-contratar:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .btn-voltar {
            display: block;
            text-align: center;
            color: white;
            text-decoration: none;
            margin-top: 20px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .btn-voltar:hover {
            color: #333;
        }

        @media (max-width: 900px) {
            .container {
                grid-template-columns: 1fr;
            }
            .nav-links {
                display: none;
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
        <div class="lado-esquerdo">
            <h1>Encontre o serviço ideal</h1>
            
            <div class="filtros">
                <button class="btn-filtro" onclick="window.location.href='servicos_lista.jsp'">🔄</button>
                <div class="search-box">
                    <form method="GET" action="">
                        <%
                        String categoriaParam = request.getParameter("categoria");
                        if (categoriaParam != null) {
                        %>
                        <input type="hidden" name="categoria" value="<%= categoriaParam %>">
                        <%
                        }
                        %>
                        <input type="text" name="busca" placeholder="Buscar serviço..." 
                               value="<%= request.getParameter("busca") != null ? request.getParameter("busca") : "" %>">
                    </form>
                </div>
            </div>

            <div class="lista-servicos">
                <%
                try {
                    String database = "maoamiga";
                    String endereco = "jdbc:mysql://localhost:3306/" + database;
                    String usuario = "root";
                    String senha = "";
                    String driver = "com.mysql.jdbc.Driver";

                    Class.forName(driver);
                    Connection conexao = DriverManager.getConnection(endereco, usuario, senha);

                    String sql = "SELECT s.idServico, s.tipoServico, s.descricao, s.precoEstimado, " +
                                 "s.tempoEstimado, u.nome, u.sobrenome, u.telefone " +
                                 "FROM servicos s " +
                                 "INNER JOIN usuario u ON s.idPrestador = u.idUsuario " +
                                 "WHERE s.status = 'ativo' ";
                    
                    if (categoriaParam != null && !categoriaParam.trim().isEmpty()) {
                        sql += "AND s.idServico IN (SELECT idServico FROM servico_categoria WHERE idCategoria = ?) ";
                    }
                    
                    String termoBusca = request.getParameter("busca");
                    if (termoBusca != null && !termoBusca.trim().isEmpty()) {
                        sql += "AND (s.tipoServico LIKE ? OR u.nome LIKE ? OR u.sobrenome LIKE ?) ";
                    }
                    
                    sql += "ORDER BY s.idServico DESC";

                    PreparedStatement stm = conexao.prepareStatement(sql);
                    
                    int paramIndex = 1;
                    if (categoriaParam != null && !categoriaParam.trim().isEmpty()) {
                        stm.setInt(paramIndex++, Integer.parseInt(categoriaParam));
                    }
                    
                    if (termoBusca != null && !termoBusca.trim().isEmpty()) {
                        String busca = "%" + termoBusca + "%";
                        stm.setString(paramIndex++, busca);
                        stm.setString(paramIndex++, busca);
                        stm.setString(paramIndex++, busca);
                    }

                    ResultSet rs = stm.executeQuery();

                    boolean temResultados = false;
                    while (rs.next()) {
                        temResultados = true;
                        int idServico = rs.getInt("idServico");
                        String tipoServico = rs.getString("tipoServico");
                        String descricao = rs.getString("descricao");
                        double preco = rs.getDouble("precoEstimado");
                        String tempo = rs.getString("tempoEstimado");
                        String nomePrestador = rs.getString("nome") + " " + rs.getString("sobrenome");
                        String telefone = rs.getString("telefone");
                %>
                
                <div class="servico-item" data-id="<%= idServico %>" 
                     data-tipo="<%= tipoServico %>"
                     data-prestador="<%= nomePrestador %>"
                     data-descricao="<%= descricao != null ? descricao.replace("\"", "&quot;") : "" %>"
                     data-preco="<%= preco %>"
                     data-tempo="<%= tempo != null ? tempo : "" %>"
                     data-telefone="<%= telefone != null ? telefone : "" %>">
                    <div class="servico-header">
                        <span class="servico-tipo"><%= tipoServico %></span>
                    </div>
                    <div class="prestador-info">
                        <div class="avatar">👤</div>
                        <div class="info">
                            <h3><%= nomePrestador %></h3>
                            <p>R$ <%= String.format("%.2f", preco) %> • <%= tempo != null ? tempo : "A combinar" %></p>
                        </div>
                    </div>
                </div>

                <%
                    }

                    if (!temResultados) {
                        out.print("<p style='text-align:center; color:#666; padding:20px;'>Nenhum serviço encontrado.</p>");
                    }

                    rs.close();
                    stm.close();
                    conexao.close();

                } catch (Exception e) {
                    out.print("<p style='color:red; padding:20px;'>Erro: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                }
                %>
            </div>
        </div>

        <div class="lado-direito">
            <div class="info-box">
                <p><strong>Clique em um serviço para ver mais detalhes e poder contratar!</strong></p>
            </div>

            <div class="detalhes-servico" id="detalhes-servico">
                <div class="prestador-detalhes">
                    <div class="avatar-grande">👤</div>
                    <div>
                        <h2 id="nome-prestador">Selecione um serviço</h2>
                        <p id="info-prestador">Clique em um serviço ao lado para ver os detalhes</p>
                    </div>
                </div>

                <div class="descricao-box">
                    <h3>Descrição do serviço</h3>
                    <p id="descricao-servico">A descrição aparecerá aqui</p>
                </div>

                <button class="btn-contratar" id="btn-contratar" onclick="contratarServico()" disabled>
                    Contratar este serviço
                </button>
            </div>

            <a href="index.jsp" class="btn-voltar">← Voltar para home</a>
        </div>
    </div>

    <script>
        let servicoSelecionadoId = null;

        document.querySelectorAll('.servico-item').forEach(item => {
            item.addEventListener('click', function() {
                servicoSelecionadoId = this.dataset.id;
                
                document.querySelectorAll('.servico-item').forEach(s => s.classList.remove('active'));
                this.classList.add('active');
                
                document.getElementById('nome-prestador').textContent = this.dataset.prestador;
                document.getElementById('info-prestador').textContent = 
                    this.dataset.tipo + ' - R$ ' + parseFloat(this.dataset.preco).toFixed(2) + 
                    (this.dataset.telefone ? ' - Tel: ' + this.dataset.telefone : '');
                document.getElementById('descricao-servico').textContent = 
                    this.dataset.descricao + '\n\nTempo estimado: ' + this.dataset.tempo;
                
                document.getElementById('btn-contratar').disabled = false;
            });
        });

        function contratarServico() {
            if (servicoSelecionadoId) {
                window.location.href = 'contratar_servico.jsp?id=' + servicoSelecionadoId;
            } else {
                alert('Por favor, selecione um serviço primeiro!');
            }
        }

        const primeiro = document.querySelector('.servico-item');
        if (primeiro) {
            primeiro.click();
        }
    </script>
</body>
</html>