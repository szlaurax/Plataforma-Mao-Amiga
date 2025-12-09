<%@page language="java" import="java.sql.*"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
Integer idUsuario = (Integer) session.getAttribute("idUsuario");
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
    </style>
</head>
<body>
 
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
        <h1>Erro ao Criar Serviço</h1>
        <p><%= e.getMessage() %></p>
        <a href="criar_servico.jsp">Tentar Novamente</a>
    </div>
</body>
</html>

<%
    e.printStackTrace();
}
%>