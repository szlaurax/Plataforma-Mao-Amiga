<%@page language="java" import="java.sql.*"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
Integer idUsuario = (Integer) session.getAttribute("idUsuario");
String nomeUsuario = (String) session.getAttribute("nomeUsuario");
if(idUsuario == null) {
    response.sendRedirect("login.html");
    return;
}

try {
    // Pegar parâmetros do formulário
    String tipoServico = request.getParameter("tipoServico");
    String descricao = request.getParameter("descricao");
    String precoEstimadoStr = request.getParameter("precoEstimado");
    String tempoEstimado = request.getParameter("tempoEstimado");
    String disponibilidade = request.getParameter("disponibilidade");
    String[] categorias = request.getParameterValues("categorias");
    
    // Validar dados
    if(tipoServico == null || descricao == null || precoEstimadoStr == null || 
       tempoEstimado == null || categorias == null || categorias.length == 0) {
        throw new Exception("Por favor, preencha todos os campos obrigatórios!");
    }
    
    double precoEstimado = Double.parseDouble(precoEstimadoStr);
    
    // Conectar ao banco
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/maoamiga", "root", "");
    
    // Inserir serviço
    String sql = "INSERT INTO servicos (idPrestador, tipoServico, descricao, precoEstimado, tempoEstimado, status, dataCriacao) " +
                 "VALUES (?, ?, ?, ?, ?, 'ativo', NOW())";
    
    PreparedStatement stm = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
    stm.setInt(1, idUsuario);
    stm.setString(2, tipoServico);
    stm.setString(3, descricao);
    stm.setDouble(4, precoEstimado);
    stm.setString(5, tempoEstimado);
    
    int resultado = stm.executeUpdate();
    
    // Pegar ID do serviço criado
    int idServico = 0;
    ResultSet rsKeys = stm.getGeneratedKeys();
    if(rsKeys.next()) {
        idServico = rsKeys.getInt(1);
    }
    rsKeys.close();
    stm.close();
    
    // Inserir categorias
    if(idServico > 0 && categorias != null) {
        String sqlCategoria = "INSERT INTO servico_categoria (idServico, idCategoria) VALUES (?, ?)";
        PreparedStatement stmCategoria = conn.prepareStatement(sqlCategoria);
        
        for(String categoriaId : categorias) {
            stmCategoria.setInt(1, idServico);
            stmCategoria.setInt(2, Integer.parseInt(categoriaId));
            stmCategoria.executeUpdate();
        }
        
        stmCategoria.close();
    }
    
    conn.close();
    
    if(resultado > 0 && idServico > 0) {
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"
        integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
    <title>Serviço Criado - Mão Amiga</title>
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
            position: sticky;
            top: 0;
            z-index: 1000;
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
            padding-bottom: 5px;
            transition: all 0.3s;
            position: relative;
        }

        .nav-links a:hover,
        .nav-links a.active {
            color: #16a5a8;
        }

        .nav-links a.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: #16a5a8;
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

        .user-icon:hover {
            color: #16a5a8;
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

        .dropdown-content a:first-child {
            border-radius: 10px 10px 0 0;
        }

        .dropdown-content a:last-child {
            border-radius: 0 0 10px 10px;
            color: #dc3545;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        /* Success Box */
        .page-content {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 60px 20px;
            min-height: calc(100vh - 80px);
        }

        .sucesso-box {
            background: white;
            padding: 60px 50px;
            border-radius: 25px;
            text-align: center;
            max-width: 600px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        .sucesso-icon {
            font-size: 100px;
            margin-bottom: 20px;
            animation: scaleIn 0.5s ease-out;
        }

        @keyframes scaleIn {
            from { transform: scale(0); }
            to { transform: scale(1); }
        }

        h1 {
            color: #16a5a8;
            margin-bottom: 15px;
            font-size: 32px;
        }

        .mensagem {
            color: #666;
            line-height: 1.6;
            margin-bottom: 30px;
            font-size: 16px;
        }

        .detalhes-servico {
            background: #f5f5f5;
            padding: 25px;
            border-radius: 15px;
            margin: 25px 0;
            text-align: left;
        }

        .detalhes-servico h3 {
            color: #333;
            margin-bottom: 15px;
        }

        .detalhe-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #e0e0e0;
        }

        .detalhe-item:last-child {
            border-bottom: none;
        }

        .btn-dashboard {
            display: inline-block;
            padding: 15px 40px;
            background: linear-gradient(135deg, #16a5a8 0%, #91d96f 100%);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s;
            margin: 10px;
        }

        .btn-dashboard:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(22, 165, 168, 0.4);
        }

        .btn-novo {
            display: inline-block;
            padding: 15px 40px;
            background: white;
            color: #16a5a8;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            border: 2px solid #16a5a8;
            transition: all 0.3s;
            margin: 10px;
        }

        .btn-novo:hover {
            background: #16a5a8;
            color: white;
        }

        @media (max-width: 768px) {
            .nav-links {
                display: none;
            }

            .sucesso-box {
                padding: 40px 30px;
            }

            h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <header>
        <nav>
            <a href="index.jsp" class="logo">
                <i class="fa-solid fa-people-robbery logo-icon"></i>
                Mão Amiga
            </a>

            <ul class="nav-links">
                <li><a href="index.jsp">Inicio</a></li>
                <li><a href="servicos_lista.jsp">Contratar Serviços</a></li>
                <li><a href="prestador_dashboard.jsp" class="active">Prestadores de Serviços</a></li>
            </ul>

            <div class="user-menu">
                <span class="user-info">Olá, <%= nomeUsuario %></span>
                <div class="dropdown">
                    <a href="#" class="user-icon">👤</a>
                    <div class="dropdown-content">
                        <a href="minhas_contratacoes.jsp">Minhas Contratações</a>
                        <a href="perfil.jsp">Meu Perfil</a>
                        <a href="prestador_dashboard.jsp">Área do Prestador</a>
                        <a href="logout.jsp">Sair</a>
                    </div>
                </div>
            </div>
        </nav>
    </header>

    <div class="page-content">
        <div class="sucesso-box">
            <div class="sucesso-icon">✅</div>
            <h1>Serviço Criado com Sucesso!</h1>
            <p class="mensagem">Seu serviço foi cadastrado e já está disponível para os usuários da plataforma!</p>
            
            <div class="detalhes-servico">
                <h3>📋 Detalhes do Serviço</h3>
                <div class="detalhe-item">
                    <span><strong>Serviço:</strong></span>
                    <span><%= tipoServico %></span>
                </div>
                <div class="detalhe-item">
                    <span><strong>Preço:</strong></span>
                    <span>R$ <%= String.format("%.2f", precoEstimado) %></span>
                </div>
                <div class="detalhe-item">
                    <span><strong>Tempo:</strong></span>
                    <span><%= tempoEstimado %></span>
                </div>
                <div class="detalhe-item">
                    <span><strong>Status:</strong></span>
                    <span style="color: #28a745;">Ativo</span>
                </div>
            </div>
            
            <div>
                <a href="prestador_dashboard.jsp" class="btn-dashboard">Ver Dashboard</a>
                <a href="criar_servico.jsp" class="btn-novo">Criar Outro Serviço</a>
            </div>
        </div>
    </div>
</body>
</html>

<%
    } else {
        throw new Exception("Erro ao criar o serviço. Tente novamente.");
    }
    
} catch(Exception e) {
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"
        integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
    <title>Erro - Mão Amiga</title>
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
            position: sticky;
            top: 0;
            z-index: 1000;
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
            padding-bottom: 5px;
            transition: all 0.3s;
            position: relative;
        }

        .nav-links a:hover,
        .nav-links a.active {
            color: #16a5a8;
        }

        .nav-links a.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: #16a5a8;
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

        .user-icon:hover {
            color: #16a5a8;
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

        .dropdown-content a:first-child {
            border-radius: 10px 10px 0 0;
        }

        .dropdown-content a:last-child {
            border-radius: 0 0 10px 10px;
            color: #dc3545;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        /* Error Box */
        .page-content {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 60px 20px;
            min-height: calc(100vh - 80px);
        }

        .erro-box {
            background: white;
            padding: 50px;
            border-radius: 25px;
            text-align: center;
            max-width: 500px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        .erro-icon {
            font-size: 80px;
            margin-bottom: 20px;
            animation: shake 0.5s ease-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }

        h1 {
            color: #dc3545;
            margin-bottom: 15px;
            font-size: 28px;
        }

        p {
            color: #666;
            line-height: 1.6;
            margin-bottom: 25px;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 30px;
            background: #16a5a8;
            color: white;
            text-decoration: none;
            border-radius: 20px;
            transition: all 0.3s;
        }

        a:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(22, 165, 168, 0.4);
        }

        @media (max-width: 768px) {
            .nav-links {
                display: none;
            }

            .erro-box {
                padding: 40px 30px;
            }
        }
    </style>
</head>
<body>
    <header>
        <nav>
            <a href="index.jsp" class="logo">
                <i class="fa-solid fa-people-robbery logo-icon">Mao Amiga</i>
                
            </a>

            <ul class="nav-links">
                <li><a href="index.jsp">Inicio</a></li>
                <li><a href="servicos_lista.jsp">Contratar Serviços</a></li>
                <li><a href="prestador_dashboard.jsp" class="active">Prestadores de Serviços</a></li>
            </ul>

            <div class="user-menu">
                <% if (nomeUsuario != null) { %>
                    <span class="user-info">Olá, <%= nomeUsuario %></span>
                    <div class="dropdown">
                        <a href="#" class="user-icon">👤</a>
                        <div class="dropdown-content">
                            <a href="minhas_contratacoes.jsp">Minhas Contratações</a>
                            <a href="perfil.jsp">Meu Perfil</a>
                            <a href="prestador_dashboard.jsp">Área do Prestador</a>
                            <a href="logout.jsp">Sair</a>
                        </div>
                    </div>
                <% } %>
            </div>
        </nav>
    </header>

    <div class="page-content">
        <div class="erro-box">
            <div class="erro-icon">❌</div>
            <h1>Erro ao Criar Serviço</h1>
            <p><%= e.getMessage() %></p>
            <a href="criar_servico.jsp">Tentar Novamente</a>
        </div>
    </div>
</body>
</html>

<%
    e.printStackTrace();
}
%>