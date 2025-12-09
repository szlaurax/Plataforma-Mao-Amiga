<%@page language="java" import="java.sql.*"%> 
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
Integer idUsuario = (Integer) session.getAttribute("idUsuario");
if(idUsuario == null) {
    response.sendRedirect("login.html?redirect=" + request.getRequestURI());
    return;
}
%>

<%
try {
    // Verificar login
    Integer idUsuarioLogado = (Integer) session.getAttribute("idUsuario");
    if (idUsuarioLogado == null) {
        response.sendRedirect("login.html");
        return;
    }

    // Pegar parâmetros
    String idServico = request.getParameter("idServico");
    String idSolicitante = request.getParameter("idSolicitante");
    String dataSelecionada = request.getParameter("dataSelecionada");
    String horarioSelecionado = request.getParameter("horarioSelecionado");
    String endereco = request.getParameter("endereco");
    String numero = request.getParameter("numero");
    String complemento = request.getParameter("complemento");

    // Validar
    if (idServico == null || dataSelecionada == null || horarioSelecionado == null || 
        endereco == null || numero == null) {
        out.print("<h3 style='color:red;'>Erro: Dados incompletos!</h3>");
        out.print("<br><a href='servicos_lista.jsp'>Voltar</a>");
        return;
    }

    // Montar endereço completo
    String enderecoCompleto = endereco + ", " + numero;
    if (complemento != null && !complemento.trim().isEmpty()) {
        enderecoCompleto += " - " + complemento;
    }

    // Montar data e hora completa
    String dataHoraAgendada = dataSelecionada + " " + horarioSelecionado + ":00";

    // Conectar ao banco
    String database = "maoamiga";
    String enderecoDB = "jdbc:mysql://localhost:3306/" + database;
    String usuario = "root";
    String senha = "";
    String driver = "com.mysql.jdbc.Driver";

    Class.forName(driver);
    Connection conexao = DriverManager.getConnection(enderecoDB, usuario, senha);

    // Buscar preço do serviço
    String sqlPreco = "SELECT precoEstimado, tipoServico FROM servicos WHERE idServico = ?";
    PreparedStatement stmPreco = conexao.prepareStatement(sqlPreco);
    stmPreco.setInt(1, Integer.parseInt(idServico));
    ResultSet rsPreco = stmPreco.executeQuery();
    
    double valorFinal = 0;
    String tipoServico = "";
    if (rsPreco.next()) {
        valorFinal = rsPreco.getDouble("precoEstimado");
        tipoServico = rsPreco.getString("tipoServico");
    }
    rsPreco.close();
    stmPreco.close();

    // Inserir contratação
    String sql = "INSERT INTO contratacoes (idServico, idSolicitante, dataAgendada, " +
                 "valorFinal, observacoes, status) VALUES (?, ?, ?, ?, ?, 'pendente')";
    
    PreparedStatement stm = conexao.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
    stm.setInt(1, Integer.parseInt(idServico));
    stm.setInt(2, Integer.parseInt(idSolicitante));
    stm.setString(3, dataHoraAgendada);
    stm.setDouble(4, valorFinal);
    stm.setString(5, enderecoCompleto);

    int resultado = stm.executeUpdate();
    
    // Pegar ID da contratação
    int idContratacao = 0;
    ResultSet rsKeys = stm.getGeneratedKeys();
    if (rsKeys.next()) {
        idContratacao = rsKeys.getInt(1);
    }
    rsKeys.close();
    
    stm.close();
    conexao.close();

    if (resultado > 0) {
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contratação Realizada - Mão Amiga</title>
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
            padding: 50px;
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
        
        .detalhes {
            background: #f5f5f5;
            padding: 25px;
            border-radius: 15px;
            margin: 25px 0;
            text-align: left;
        }
        
        .detalhes h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 18px;
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

        .detalhe-label {
            font-weight: 600;
            color: #666;
        }

        .detalhe-valor {
            color: #333;
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
        <div class="sucesso-icon">✅</div>
        <h1>Contratação Realizada!</h1>
        <p class="mensagem">Sua solicitação foi enviada ao prestador de serviço. Aguarde a confirmação!</p>
        
        <div class="detalhes">
            <h3>📋 Detalhes da Contratação</h3>
            
            <div class="detalhe-item">
                <span class="detalhe-label">Número:</span>
                <span class="detalhe-valor">#<%= idContratacao %></span>
            </div>
            
            <div class="detalhe-item">
                <span class="detalhe-label">Serviço:</span>
                <span class="detalhe-valor"><%= tipoServico %></span>
            </div>
            
            <div class="detalhe-item">
                <span class="detalhe-label">Data e Hora:</span>
                <span class="detalhe-valor"><%= dataSelecionada %> às <%= horarioSelecionado %></span>
            </div>
            
            <div class="detalhe-item">
                <span class="detalhe-label">Endereço:</span>
                <span class="detalhe-valor"><%= enderecoCompleto %></span>
            </div>
            
            <div class="detalhe-item">
                <span class="detalhe-label">Valor:</span>
                <span class="detalhe-valor">R$ <%= String.format("%.2f", valorFinal) %></span>
            </div>
            
            <div class="detalhe-item">
                <span class="detalhe-label">Status:</span>
                <span class="detalhe-valor" style="color: #f39c12;">⏳ Aguardando confirmação</span>
            </div>
        </div>
        
        <div style="margin-top: 30px;">
            <a href="index.jsp" class="btn-voltar">Voltar para Home</a>
            <a href="minhas_contratacoes.jsp" class="btn-secundario">Ver Minhas Contratações</a>
            <a href="servicos.jsp" class="btn-voltar">Voltar para Serviços</a>
            <a href="minhas_contratacoes.jsp">Ver minhas contratações</a>
        </div>
    </div>
</body>
</html>
<%
    } else {
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
        <h1>Erro ao Processar</h1>
        <p>Não foi possível concluir a contratação. Tente novamente.</p>
        <a href="servicos_lista.jsp">Voltar</a>
    </div>
</body>
</html>
<%
    }

} catch (Exception e) {
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
        h1 {
            color: #dc3545;
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
        <h1>Erro</h1>
        <p><%= e.getMessage() %></p>
        <a href="servicos_lista.jsp">Voltar</a>
    </div>
</body>
</html>
<%
    e.printStackTrace();
}
%>