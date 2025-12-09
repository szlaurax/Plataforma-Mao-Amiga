<%@page language="java" import="java.sql.*"%> 
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
Integer idUsuario = (Integer) session.getAttribute("idUsuario");
String nomeUsuario = (String) session.getAttribute("nomeUsuario");
if(idUsuario == null) {
    response.sendRedirect("login.html?redirect=index.jsp");
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
    <title>Mão Amiga - Conectando Comunidades</title>
   <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: #f8f9fa;
        }

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

        .hero {
            padding: 80px 8%;
            background: linear-gradient(135deg, rgba(22, 165, 168, 0.05) 0%, rgba(145, 217, 111, 0.05) 100%);
        }

        .hero h1 {
            font-size: 48px;
            color: #333;
            margin-bottom: 20px;
            line-height: 1.2;
        }

        .hero h1 span {
            color: #16a5a8;
        }

        .hero p {
            font-size: 18px;
            color: #666;
            line-height: 1.8;
            max-width: 800px;
        }

        .hero p span {
            color: #16a5a8;
            font-weight: 600;
        }

        .servicos-section {
            padding: 80px 8%;
            background: white;
        }

        .section-header {
            text-align: center;
            margin-bottom: 60px;
        }

        .section-header h2 {
            font-size: 36px;
            color: #333;
            margin-bottom: 10px;
        }

        .section-header p {
            color: #666;
            font-size: 18px;
        }

        .servicos-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
        }

        .servico-card {
            background: #f5f5f3;
            padding: 40px 30px;
            border-radius: 20px;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
            position: relative;
        }

        .servico-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .servico-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }

        .servico-card h3 {
            font-size: 20px;
            color: #333;
            margin-bottom: 15px;
        }

        .servico-card p {
            font-size: 14px;
            color: #666;
            line-height: 1.6;
        }

        .servico-count {
            display: inline-block;
            background: #16a5a8;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            margin-top: 10px;
        }

        @media (max-width: 768px) {
            .nav-links {
                display: none;
            }

            .hero h1 {
                font-size: 32px;
            }

            .hero p {
                font-size: 16px;
            }

            .servicos-grid {
                grid-template-columns: 1fr;
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
                <li><a href="index.jsp" class="active">Inicio</a></li>
                <li><a href="servicos_lista.jsp">Contratar Serviços</a></li>
                <li><a href="prestador_dashboard.jsp">Prestadores de Serviços</a></li>
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

    <section class="hero">
        <h1>Plataforma Conecta Comunidade: <span>Seu vizinho resolve.</span></h1>
        <p>A <span>Plataforma</span> é o seu ponto de encontro digital para <span>solicitar e prestar micro-serviços</span> e ajuda voluntária na sua região. Criada para eliminar a dificuldade de encontrar auxílio local, nossa plataforma conecta diretamente Solicitantes (moradores que precisam de ajuda) a <span>Prestadores e Voluntários</span> da mesma vizinhança.</p>
    </section>

    <section class="servicos-section" id="servicos">
        <div class="section-header">
            <h2>Contratar Serviços</h2>
            <p>Escolha a categoria de serviço que você precisa</p>
        </div>

        <div class="servicos-grid">
            <%
            try {
                String database = "maoamiga";
                String endereco = "jdbc:mysql://localhost:3306/" + database;
                String usuario = "root";
                String senha = "";
                String driver = "com.mysql.jdbc.Driver";

                Class.forName(driver);
                Connection conexao = DriverManager.getConnection(endereco, usuario, senha);

                String sql = "SELECT c.idCategoria, c.nomeCategoria, c.icone, c.descricao, " +
                             "COUNT(sc.idServico) as totalServicos " +
                             "FROM categorias c " +
                             "LEFT JOIN servico_categoria sc ON c.idCategoria = sc.idCategoria " +
                             "LEFT JOIN servicos s ON sc.idServico = s.idServico AND s.status = 'ativo' " +
                             "GROUP BY c.idCategoria " +
                             "ORDER BY c.idCategoria";

                Statement stm = conexao.createStatement();
                ResultSet rs = stm.executeQuery(sql);

                while (rs.next()) {
                    int idCategoria = rs.getInt("idCategoria");
                    String nomeCategoria = rs.getString("nomeCategoria");
                    String icone = rs.getString("icone");
                    String descricao = rs.getString("descricao");
                    int totalServicos = rs.getInt("totalServicos");
            %>
            
            <div class="servico-card" onclick="window.location.href='servicos_lista.jsp?categoria=<%= idCategoria %>'">
                <div class="servico-icon"><%= icone != null ? icone : "🔧" %></div>
                <h3><%= nomeCategoria %></h3>
                <p><%= descricao %></p>
                <span class="servico-count"><%= totalServicos %> serviços disponíveis</span>
            </div>

            <%
                }

                rs.close();
                stm.close();
                conexao.close();

            } catch (Exception e) {
                out.print("<div style='grid-column: 1/-1; text-align:center; color:#dc3545; padding:40px;'>");
                out.print("<h3>Erro ao carregar categorias</h3>");
                out.print("<p>" + e.getMessage() + "</p>");
                out.print("</div>");
                e.printStackTrace();
            }
            %>
        </div>
    </section>

    <script>
        // Smooth scroll
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth' });
                }
            });
        });
    </script>
</body>
</html>