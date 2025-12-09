<%@page language="java" import="java.sql.*"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
Integer idUsuario = (Integer) session.getAttribute("idUsuario");
if(idUsuario == null) {
    response.sendRedirect("login.html");
    return;
}

try {
    String idContratacao = request.getParameter("id");
    String nota = request.getParameter("nota");
    String comentario = request.getParameter("comentario");
    
    if(idContratacao == null || nota == null) {
        throw new Exception("Dados incompletos");
    }
    
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/maoamiga", "root", "");
    
    // Verificar se a contratação pertence ao usuário
    String sqlVerifica = "SELECT idContratacao FROM contratacoes WHERE idContratacao = ? AND idSolicitante = ?";
    PreparedStatement stmVerifica = conn.prepareStatement(sqlVerifica);
    stmVerifica.setInt(1, Integer.parseInt(idContratacao));
    stmVerifica.setInt(2, idUsuario);
    ResultSet rsVerifica = stmVerifica.executeQuery();
    
    if(!rsVerifica.next()) {
        rsVerifica.close();
        stmVerifica.close();
        conn.close();
        throw new Exception("Contratação não encontrada");
    }
    rsVerifica.close();
    stmVerifica.close();
    
    // Criar tabela de avaliações se não existir
    String sqlCreateTable = "CREATE TABLE IF NOT EXISTS avaliacoes (" +
                           "idAvaliacao INT PRIMARY KEY AUTO_INCREMENT, " +
                           "idContratacao INT, " +
                           "nota INT, " +
                           "comentario TEXT, " +
                           "dataAvaliacao DATETIME, " +
                           "FOREIGN KEY (idContratacao) REFERENCES contratacoes(idContratacao))";
    Statement stmCreate = conn.createStatement();
    stmCreate.execute(sqlCreateTable);
    stmCreate.close();
    
    // Inserir avaliação
    String sql = "INSERT INTO avaliacoes (idContratacao, nota, comentario, dataAvaliacao) VALUES (?, ?, ?, NOW())";
    PreparedStatement stm = conn.prepareStatement(sql);
    stm.setInt(1, Integer.parseInt(idContratacao));
    stm.setInt(2, Integer.parseInt(nota));
    stm.setString(3, comentario != null ? comentario : "");
    
    int resultado = stm.executeUpdate();
    
    stm.close();
    conn.close();
    
    if(resultado > 0) {
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Avaliação Enviada - Mão Amiga</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .sucesso-box {
            background: white;
            padding: 60px 50px;
            border-radius: 25px;
            text-align: center;
            max-width: 500px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        .sucesso-icon {
            font-size: 100px;
            margin-bottom: 20px;
            animation: scaleIn 0.5s ease-out;
        }

        @keyframes scaleIn {
            from {
                transform: scale(0);
            }
            to {
                transform: scale(1);
            }
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

        .estrelas-enviadas {
            font-size: 40px;
            color: #ffd700;
            margin: 20px 0;
        }

        .btn-voltar {
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

        .btn-voltar:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(22, 165, 168, 0.4);
        }

        .btn-secundario {
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

        .btn-secundario:hover {
            background: #16a5a8;
            color: white;
        }
    </style>
</head>
<body>
    <div class="sucesso-box">
        <div class="sucesso-icon">⭐</div>
        <h1>Avaliação Enviada!</h1>
        <p class="mensagem">Obrigado pelo seu feedback! Sua avaliação ajuda outros usuários a escolherem os melhores prestadores.</p>
        
        <div class="estrelas-enviadas">
            <%
                int notaInt = Integer.parseInt(nota);
                for(int i = 0; i < notaInt; i++) {
                    out.print("★");
                }
                for(int i = notaInt; i < 5; i++) {
                    out.print("☆");
                }
            %>
        </div>
        
        <div style="margin-top: 30px;">
            <a href="minhas_contratacoes.jsp" class="btn-voltar">Ver Minhas Contratações</a>
            <a href="index.jsp" class="btn-secundario">Voltar para Home</a>
        </div>
    </div>
</body>
</html>

<%
    } else {
        throw new Exception("Não foi possível salvar a avaliação");
    }
    
} catch(Exception e) {
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Erro - Mão Amiga</title>
    <style>
        body {
            background: linear-gradient(135deg, #16a5a8 0%, #91d96f 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .erro-box {
            background: white;
            padding: 50px;
            border-radius: 25px;
            text-align: center;
            max-width: 500px;
        }
        .erro-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
        h1 {
            color: #dc3545;
            margin-bottom: 15px;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 30px;
            background: #16a5a8;
            color: white;
            text-decoration: none;
            border-radius: 20px;
        }
    </style>
</head>
<body>
    <div class="erro-box">
        <div class="erro-icon">❌</div>
        <h1>Erro ao Processar Avaliação</h1>
        <p><%= e.getMessage() %></p>
        <a href="minhas_contratacoes.jsp">Voltar</a>
    </div>
</body>
</html>

<%
    e.printStackTrace();
}
%>