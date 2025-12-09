<%@page language="java" import="java.sql.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
try {
    // Validação inicial
    if(request.getParameter("name") == null) {
        out.print("<h3 style='color:red;'>Acesso inválido! Use o formulário de cadastro.</h3>");
        out.print("<br><a href='cadastro.html'>Ir para o formulário</a>");
        return;
    }

    // Pegar parâmetros
    String vnome = request.getParameter("name");
    String vsobrenome = request.getParameter("last_name");
    String vnascimentoStr = request.getParameter("birthdate");
    String vemail = request.getParameter("email");
    String vsenha = request.getParameter("senha");
    String vtelefone = request.getParameter("telefone");
    String vendereco = request.getParameter("endereco");
    String vcidade = request.getParameter("cidade");
    String vestado = request.getParameter("estado");
    String vcep = request.getParameter("cep");

    // Validações
    if(vnome == null || vnome.trim().isEmpty()) {
        out.print("<h3 style='color:red;'>Erro: Nome é obrigatório!</h3>");
        out.print("<a href='cadastro.html'>Voltar</a>");
        return;
    }

    if(vnascimentoStr == null || vnascimentoStr.isEmpty()) {
        out.print("<h3 style='color:red;'>Erro: Data de nascimento é obrigatória!</h3>");
        out.print("<a href='cadastro.html'>Voltar</a>");
        return;
    }

    // Converter data
    java.sql.Date vnascimento = java.sql.Date.valueOf(vnascimentoStr);

    // Conectar ao banco - CONFIGURAÇÃO PARA MARIADB
    String database = "maoamiga";
    String enderecoDb = "jdbc:mysql://localhost:3306/" + database; 
    String usuario = "root";
    String senhaDb = "";
    String driver = "com.mysql.jdbc.Driver";

    Class.forName(driver);
    Connection conexao = DriverManager.getConnection(enderecoDb, usuario, senhaDb);

    // Inserir dados
    String sql = "INSERT INTO usuario (nome,sobrenome,dataNascimento,email,senha,telefone,endereco,cidade,estado,cep) VALUES (?,?,?,?,?,?,?,?,?,?)";
    PreparedStatement stm = conexao.prepareStatement(sql);
    stm.setString(1, vnome);
    stm.setString(2, vsobrenome);
    stm.setDate(3, vnascimento);
    stm.setString(4, vemail);
    stm.setString(5, vsenha);
    stm.setString(6, vtelefone);
    stm.setString(7, vendereco);
    stm.setString(8, vcidade);
    stm.setString(9, vestado);
    stm.setString(10, vcep);

    stm.executeUpdate();
    stm.close();
    conexao.close();

    response.sendRedirect("index.jsp");
    
} catch(Exception e) {
    out.print("<h3 style='color:red;'>Erro: " + e.getMessage() + "</h3>");
    out.print("<br><a href='cadastro.html'>Voltar</a>");
    e.printStackTrace();
}
%>