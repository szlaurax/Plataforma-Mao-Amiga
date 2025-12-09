<%@page language="java" import="java.sql.*"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
try {
    // Validação inicial
    if(request.getParameter("email") == null || request.getParameter("senha") == null) {
        response.sendRedirect("login.html?erro=acesso_invalido");
        return;
    }

    // Pegar parâmetros
    String vemail = request.getParameter("email");
    String vsenha = request.getParameter("senha");

    // Validações
    if(vemail == null || vemail.trim().isEmpty()) {
        response.sendRedirect("login.html?erro=email_vazio");
        return;
    }

    if(vsenha == null || vsenha.trim().isEmpty()) {
        response.sendRedirect("login.html?erro=senha_vazia");
        return;
    }

    // Conectar ao banco
    String database = "maoamiga";
    String endereco = "jdbc:mysql://localhost:3306/" + database;
    String usuario = "root";
    String senha = "";
    String driver = "com.mysql.jdbc.Driver";

    Class.forName(driver);
    Connection conexao = DriverManager.getConnection(endereco, usuario, senha);

    // Consultar usuário
    String sql = "SELECT idUsuario, nome, sobrenome, email FROM usuario WHERE email = ? AND senha = ?";
    PreparedStatement stm = conexao.prepareStatement(sql);
    stm.setString(1, vemail);
    stm.setString(2, vsenha);

    ResultSet resultado = stm.executeQuery();

    if(resultado.next()) {
        // Login bem-sucedido
        int idUsuario = resultado.getInt("idUsuario");
        String nome = resultado.getString("nome");
        String sobrenome = resultado.getString("sobrenome");
        String email = resultado.getString("email");
        
        // Criar sessão
        session.setAttribute("idUsuario", idUsuario);
        session.setAttribute("nomeUsuario", nome);
        session.setAttribute("emailUsuario", email);
        
        resultado.close();
        stm.close();
        conexao.close();

        // Verificar se há URL de redirecionamento
        String redirect = request.getParameter("redirect");
        if(redirect != null && !redirect.trim().isEmpty()) {
            response.sendRedirect(redirect);
        } else {
            response.sendRedirect("index.jsp");
        }
        
    } else {
        // Login falhou
        resultado.close();
        stm.close();
        conexao.close();
        
        response.sendRedirect("login.html?erro=credenciais_invalidas");
    }
    
} catch(ClassNotFoundException e) {
    response.sendRedirect("login.html?erro=driver_mysql");
} catch(SQLException e) {
    response.sendRedirect("login.html?erro=banco_dados");
} catch(Exception e) {
    response.sendRedirect("login.html?erro=erro_inesperado");
}
%>