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
    <link rel="stylesheet" href="cadastro.css">
    <title>Criar Serviço - Mão Amiga</title>
</head>
<body>
    <main id="form-container">
        <div id="form-header">
            <h1 id="form-title">Criar Novo Serviço</h1>
            <a href="prestador_dashboard.jsp">
                <button class="btn-default" type="button" title="Voltar">
                    <i class="fa-solid fa-arrow-left"></i>
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