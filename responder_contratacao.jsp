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
        out.print("erro: não autorizado");
        return;
    }

    // Pegar parâmetros
    String idContratacao = request.getParameter("id");
    String novoStatus = request.getParameter("status");

    if (idContratacao == null || novoStatus == null) {
        out.print("erro: parâmetros inválidos");
        return;
    }

    // Validar status
    if (!novoStatus.equals("confirmado") && !novoStatus.equals("cancelado")) {
        out.print("erro: status inválido");
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

    // Verificar se a contratação pertence a um serviço do prestador logado
    String sqlVerifica = "SELECT c.idContratacao FROM contratacoes c " +
                         "INNER JOIN servicos s ON c.idServico = s.idServico " +
                         "WHERE c.idContratacao = ? AND s.idPrestador = ?";
    
    PreparedStatement stmVerifica = conexao.prepareStatement(sqlVerifica);
    stmVerifica.setInt(1, Integer.parseInt(idContratacao));
    stmVerifica.setInt(2, idUsuarioLogado);
    ResultSet rsVerifica = stmVerifica.executeQuery();

    if (!rsVerifica.next()) {
        rsVerifica.close();
        stmVerifica.close();
        conexao.close();
        out.print("erro: não autorizado para esta contratação");
        return;
    }

    rsVerifica.close();
    stmVerifica.close();

    // Atualizar status da contratação
    String sqlUpdate = "UPDATE contratacoes SET status = ? WHERE idContratacao = ?";
    PreparedStatement stmUpdate = conexao.prepareStatement(sqlUpdate);
    stmUpdate.setString(1, novoStatus);
    stmUpdate.setInt(2, Integer.parseInt(idContratacao));
    
    int resultado = stmUpdate.executeUpdate();
    
    stmUpdate.close();
    conexao.close();

    if (resultado > 0) {
        out.print("sucesso: status atualizado para " + novoStatus);
    } else {
        out.print("erro: não foi possível atualizar");
    }

} catch (Exception e) {
    out.print("erro: " + e.getMessage());
    e.printStackTrace();
}
%>