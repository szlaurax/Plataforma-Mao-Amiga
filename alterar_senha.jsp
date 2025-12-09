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
    String senhaAtual = request.getParameter("senhaAtual");
    String novaSenha = request.getParameter("novaSenha");
    String confirmarSenha = request.getParameter("confirmarSenha");
    
    // Validar dados
    if(senhaAtual == null || novaSenha == null || confirmarSenha == null ||
       senhaAtual.trim().isEmpty() || novaSenha.trim().isEmpty() || confirmarSenha.trim().isEmpty()) {
        throw new Exception("Todos os campos são obrigatórios!");
    }
    
    // Verificar se nova senha e confirmação são iguais
    if(!novaSenha.equals(confirmarSenha)) {
        throw new Exception("A nova senha e a confirmação não coincidem!");
    }
    
    // Verificar tamanho da senha
    if(novaSenha.length() < 6) {
        throw new Exception("A nova senha deve ter no mínimo 6 caracteres!");
    }
    
    // Conectar ao banco
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/maoamiga", "root", "");
    
    // Verificar senha atual
    String sqlVerifica = "SELECT senha FROM usuario WHERE idUsuario = ?";
    PreparedStatement stmVerifica = conn.prepareStatement(sqlVerifica);
    stmVerifica.setInt(1, idUsuario);
    ResultSet rsVerifica = stmVerifica.executeQuery();
    
    if(!rsVerifica.next()) {
        rsVerifica.close();
        stmVerifica.close();
        conn.close();
        throw new Exception("Usuário não encontrado!");
    }
    
    String senhaAtualBanco = rsVerifica.getString("senha");
    rsVerifica.close();
    stmVerifica.close();
    
    // Comparar senha atual
    if(!senhaAtual.equals(senhaAtualBanco)) {
        conn.close();
        throw new Exception("Senha atual incorreta!");
    }
    
    // Atualizar senha
    String sqlUpdate = "UPDATE usuario SET senha = ? WHERE idUsuario = ?";
    PreparedStatement stmUpdate = conn.prepareStatement(sqlUpdate);
    stmUpdate.setString(1, novaSenha);
    stmUpdate.setInt(2, idUsuario);
    
    int resultado = stmUpdate.executeUpdate();
    
    stmUpdate.close();
    conn.close();
    
    if(resultado > 0) {
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Senha Alterada - Mão Amiga</title>
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

        .alerta-seguranca {
            background: #fff3cd;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 30px;
            color: #856404;
            font-size: 14px;
            line-height: 1.6;
        }

        .btn-perfil {
            display: inline-block;
            padding: 15px 40px;
            background: linear-gradient(135deg, #16a5a8 0%, #91d96f 100%);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s;
            margin: 5px;
        }

        .btn-perfil:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(22, 165, 168, 0.4);
        }

        .btn-login {
            display: inline-block;
            padding: 15px 40px;
            background: white;
            color: #16a5a8;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            border: 2px solid #16a5a8;
            transition: all 0.3s;
            margin: 5px;
        }

        .btn-login:hover {
            background: #16a5a8;
            color: white;
        }
    </style>
</head>
<body>
    <div class="sucesso-box">
        <div class="sucesso-icon">🔒</div>
        <h1>Senha Alterada!</h1>
        <p class="mensagem">Sua senha foi alterada com sucesso.</p>
        
        <div class="alerta-seguranca">
            <strong>⚠️ Importante:</strong><br>
            Por segurança, recomendamos que você faça login novamente com sua nova senha.
        </div>
        
        <div>
            <a href="perfil.jsp" class="btn-perfil">Voltar ao Perfil</a>
            <a href="logout.jsp" class="btn-login">Fazer Login Novamente</a>
        </div>
    </div>
</body>
</html>

<%
    } else {
        throw new Exception("Não foi possível alterar a senha. Tente novamente.");
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
        p {
            color: #666;
            margin-bottom: 20px;
            line-height: 1.6;
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
        <h1>Erro ao Alterar Senha</h1>
        <p><%= e.getMessage() %></p>
        <a href="perfil.jsp">Voltar ao Perfil</a>
    </div>
</body>
</html>

<%
    e.printStackTrace();
}
%>