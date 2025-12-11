<%@page language="java" import="java.sql.*"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
Integer idUsuario = (Integer) session.getAttribute("idUsuario");
String nomeUsuario = (String) session.getAttribute("nomeUsuario");
if(idUsuario == null) {
    response.sendRedirect("login.html?redirect=criar_servico.jsp");
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
    <title>Criar Serviço - Mão Amiga</title>
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

        /* Form Container */
        #form-container {
            max-width: 900px;
            margin: 40px auto;
            background: white;
            padding: 40px;
            border-radius: 25px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        #form-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        #form-title {
            font-size: 28px;
            color: #333;
        }

        .btn-default {
            padding: 12px 30px;
            background: linear-gradient(135deg, #16a5a8 0%, #91d96f 100%);
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .btn-default:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(22, 165, 168, 0.4);
        }

        #input-container {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
            margin-bottom: 30px;
        }

        .input-box {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-label {
            font-size: 14px;
            font-weight: 600;
            color: #333;
        }

        .input-field {
            display: flex;
            align-items: center;
            gap: 10px;
            background: #f5f5f5;
            padding: 12px 15px;
            border-radius: 10px;
            border: 2px solid transparent;
            transition: all 0.3s;
        }

        .input-field:focus-within {
            border-color: #16a5a8;
            background: white;
        }

        .form-control {
            flex: 1;
            border: none;
            background: transparent;
            font-size: 14px;
            outline: none;
        }

        .form-control::placeholder {
            color: #999;
        }

        textarea.form-control {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .radio-box {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px;
            background: #f5f5f5;
            border-radius: 8px;
            transition: all 0.3s;
        }

        .radio-box:hover {
            background: #e8e8e8;
        }

        .radio-box input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .radio-box label {
            font-size: 14px;
            color: #333;
            cursor: pointer;
        }

        button[type="submit"] {
            width: 100%;
            margin-top: 10px;
        }

        @media (max-width: 768px) {
            #input-container {
                grid-template-columns: 1fr;
            }

            .nav-links {
                display: none;
            }

            #form-container {
                margin: 20px;
                padding: 25px;
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

    <main id="form-container">
        <div id="form-header">
            <h1 id="form-title">Criar Novo Serviço</h1>
            <a href="prestador_dashboard.jsp">
                <button class="btn-default" type="button" title="Voltar">
                    <i class="fa-solid fa-arrow-left"></i>
                    Voltar
                </button>
            </a>
        </div>

        <form method="post" action="processar_criar_servico.jsp" id="form">
            <div id="input-container">
                <div class="input-box">
                    <label for="tipoServico" class="form-label">Tipo de Serviço *</label>
                    <div class="input-field">
                        <input type="text" name="tipoServico" id="tipoServico" class="form-control" 
                               placeholder="Ex: Encanador, Eletricista" required>
                        <i class="fa-solid fa-briefcase"></i>
                    </div>
                </div>

                <div class="input-box">
                    <label for="precoEstimado" class="form-label">Preço Estimado (R$) *</label>
                    <div class="input-field">
                        <input type="number" name="precoEstimado" id="precoEstimado" class="form-control" 
                               placeholder="0.00" step="0.01" min="0" required>
                        <i class="fa-solid fa-dollar-sign"></i>
                    </div>
                </div>

                <div class="input-box">
                    <label for="tempoEstimado" class="form-label">Tempo Estimado *</label>
                    <div class="input-field">
                        <input type="text" name="tempoEstimado" id="tempoEstimado" class="form-control" 
                               placeholder="Ex: 2 horas" required>
                        <i class="fa-solid fa-clock"></i>
                    </div>
                </div>

                <div class="input-box">
                    <label for="disponibilidade" class="form-label">Disponibilidade</label>
                    <div class="input-field">
                        <input type="text" name="disponibilidade" id="disponibilidade" class="form-control" 
                               placeholder="Ex: Segunda a Sexta">
                        <i class="fa-solid fa-calendar"></i>
                    </div>
                </div>

                <div class="input-box" style="grid-column: 1 / -1;">
                    <label for="descricao" class="form-label">Descrição do Serviço *</label>
                    <div class="input-field" style="align-items: flex-start;">
                        <textarea name="descricao" id="descricao" class="form-control" 
                                  placeholder="Descreva detalhadamente o serviço que você oferece..." 
                                  rows="4" required style="resize: vertical; min-height: 100px;"></textarea>
                        <i class="fa-solid fa-file-lines" style="margin-top: 10px;"></i>
                    </div>
                </div>

                <div class="input-box" style="grid-column: 1 / -1;">
                    <label class="form-label">Categorias *</label>
                    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 10px;">
                        <%
                        try {
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/maoamiga", "root", "");
                            String sql = "SELECT idCategoria, nomeCategoria FROM categorias ORDER BY nomeCategoria";
                            Statement stm = conn.createStatement();
                            ResultSet rs = stm.executeQuery(sql);
                            
                            while(rs.next()) {
                                int idCategoria = rs.getInt("idCategoria");
                                String nomeCategoria = rs.getString("nomeCategoria");
                        %>
                        <div class="radio-box">
                            <input type="checkbox" name="categorias" value="<%= idCategoria %>" id="cat<%= idCategoria %>" class="form-control" style="width: auto;">
                            <label for="cat<%= idCategoria %>" style="margin: 0; cursor: pointer;"><%= nomeCategoria %></label>
                        </div>
                        <%
                            }
                            rs.close();
                            stm.close();
                            conn.close();
                        } catch(Exception e) {
                            out.print("<p style='color:red;'>Erro ao carregar categorias</p>");
                        }
                        %>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn-default">
                <i class="fa-solid fa-plus"></i>
                Criar Serviço
            </button>
        </form>
    </main>
</body>
</html>