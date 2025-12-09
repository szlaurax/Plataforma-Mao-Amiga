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
    
    if(idContratacao == null) {
        throw new Exception("ID da contratação não fornecido");
    }
    
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/maoamiga", "root", "");
    
    // Verificar se a contratação pertence ao usuário
    String sqlVerifica = "SELECT idContratacao FROM contratacoes WHERE idContratacao = ? AND idSolicitante = ? AND status = 'pendente'";
    PreparedStatement stmVerifica = conn.prepareStatement(sqlVerifica);
    stmVerifica.setInt(1, Integer.parseInt(idContratacao));
    stmVerifica.setInt(2, idUsuario);
    ResultSet rsVerifica = stmVerifica.executeQuery();
    
    if(!rsVerifica.next()) {
        rsVerifica.close();
        stmVerifica.close();
        conn.close();
        throw new Exception("Contratação não encontrada ou não pode ser cancelada");
    }
    rsVerifica.close();
    stmVerifica.close();
    
    // Cancelar contratação
    String sql = "UPDATE contratacoes SET status = 'cancelado' WHERE idContratacao = ?";
    PreparedStatement stm = conn.prepareStatement(sql);
    stm.setInt(1, Integer.parseInt(idContratacao));
    
    int resultado = stm.executeUpdate();
    
    stm.close();
    conn.close();
    
    if(resultado > 0) {
        response.sendRedirect("minhas_contratacoes.jsp?msg=cancelado");
    } else {
        throw new Exception("Não foi possível cancelar a contratação");
    }
    
} catch(Exception e) {
    out.print("<h3 style='color:red;'>Erro: " + e.getMessage() + "</h3>");
    out.print("<br><a href='minhas_contratacoes.jsp'>Voltar</a>");
    e.printStackTrace();
}
%>