<%@page language="java" import="java.sql.*"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
Integer idUsuario = (Integer) session.getAttribute("idUsuario");
String nomeUsuario = (String) session.getAttribute("nomeUsuario");
if(idUsuario == null) {
    response.sendRedirect("login.html?redirect=perfil.jsp");
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
    <title>Meu Perfil - Mão Amiga</title>
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
        }

        header {
            background: white;
            padding: 20px 8%;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
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
            transition: all 0.3s;
        }

        .nav-links a:hover {
            color: #16a5a8;
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

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .user-icon {
            font-size: 24px;
            cursor: pointer;
            color: #333;
            text-decoration: none;
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .page-header {
            text-align: center;
            color: white;
            margin-bottom: 40px;
        }

        .page-header h1 {
            font-size: 36px;
            margin-bottom: 10px;
        }

        .page-header p {
            font-size: 16px;
            opacity: 0.9;
        }

        .perfil-grid {
            display: grid;
            grid-template-columns: 350px 1fr;
            gap: 30px;
        }

        /* Card do Perfil */
        .perfil-card {
            background: white;
            border-radius: 25px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            text-align: center;
            height: fit-content;
        }

        .perfil-avatar {
            width: 150px;
            height: 150px;
            background: linear-gradient(135deg, #16a5a8 0%, #91d96f 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 70px;
            margin: 0 auto 20px;
            position: relative;
            cursor: pointer;
            transition: all 0.3s;
        }

        .perfil-avatar:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 30px rgba(22, 165, 168, 0.3);
        }

        .perfil-avatar-overlay {
            position: absolute;
            bottom: 10px;
            right: 10px;
            width: 40px;
            height: 40px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        }

        .perfil-nome {
            font-size: 26px;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }

        .perfil-email {
            color: #666;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .perfil-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-top: 30px;
        }

        .stat-item {
            background: #f5f5f5;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
        }

        .stat-number {
            font-size: 32px;
            font-weight: bold;
            color: #16a5a8;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
        }

        /* Card de Informações */
        .info-card {
            background: white;
            border-radius: 25px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            border-bottom: 2px solid #f0f0f0;
        }

        .tab {
            padding: 15px 30px;
            background: none;
            border: none;
            border-bottom: 3px solid transparent;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            color: #666;
            transition: all 0.3s;
        }

        .tab.active {
            color: #16a5a8;
            border-bottom-color: #16a5a8;
        }

        .tab:hover {
            color: #16a5a8;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
            animation: fadeIn 0.3s;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .section-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #16a5a8;
        }

        .form-group input:disabled {
            background: #f5f5f5;
            cursor: not-allowed;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .btn-editar,
        .btn-salvar,
        .btn-cancelar {
            padding: 12px 30px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-right: 10px;
        }

        .btn-editar {
            background: #16a5a8;
            color: white;
        }

        .btn-editar:hover {
            background: #138b8e;
            transform: translateY(-2px);
        }

        .btn-salvar {
            background: #28a745;
            color: white;
        }

        .btn-salvar:hover {
            background: #218838;
        }

        .btn-cancelar {
            background: #6c757d;
            color: white;
        }

        .btn-cancelar:hover {
            background: #5a6268;
        }

        .atividade-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px;
            background: #f5f5f5;
            border-radius: 10px;
            margin-bottom: 10px;
        }

        .atividade-icon {
            width: 40px;
            height: 40px;
            background: #16a5a8;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: white;
            flex-shrink: 0;
        }

        .atividade-info {
            flex: 1;
        }

        .atividade-titulo {
            font-weight: 600;
            color: #333;
            margin-bottom: 3px;
        }

        .atividade-data {
            font-size: 12px;
            color: #999;
        }

        .badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-success {
            background: #d4edda;
            color: #155724;
        }

        .badge-warning {
            background: #fff3cd;
            color: #856404;
        }

        .badge-info {
            background: #d1ecf1;
            color: #0c5460;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-state-icon {
            font-size: 60px;
            margin-bottom: 15px;
        }

        @media (max-width: 968px) {
            .perfil-grid {
                grid-template-columns: 1fr;
            }
            .form-row {
                grid-template-columns: 1fr;
            }
            .nav-links {
                display: none;
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
                <li><a href="index.jsp">Inicio</a></li>
                <li><a href="servicos_lista.jsp">Contratar Serviços</a></li>
                <li><a href="prestador_dashboard.jsp">Prestadores</a></li>
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

    <div class="container">
        <div class="page-header">
            <h1>Meu Perfil</h1>
            <p>Gerencie suas informações pessoais e acompanhe sua atividade</p>
        </div>

        <%
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/maoamiga", "root", "");
            
            // Buscar dados do usuário
            String sql = "SELECT * FROM usuario WHERE idUsuario = ?";
            PreparedStatement stm = conn.prepareStatement(sql);
            stm.setInt(1, idUsuario);
            ResultSet rs = stm.executeQuery();
            
            if(rs.next()) {
                String nome = rs.getString("nome");
                String sobrenome = rs.getString("sobrenome");
                String email = rs.getString("email");
                String telefone = rs.getString("telefone");
                String cidade = rs.getString("cidade");
                String estado = rs.getString("estado");
                String dataCadastro = rs.getString("dataCadastro");
                
                // Contar contratações
                String sqlContratacoes = "SELECT COUNT(*) as total FROM contratacoes WHERE idSolicitante = ?";
                PreparedStatement stmContratacoes = conn.prepareStatement(sqlContratacoes);
                stmContratacoes.setInt(1, idUsuario);
                ResultSet rsContratacoes = stmContratacoes.executeQuery();
                int totalContratacoes = 0;
                if(rsContratacoes.next()) {
                    totalContratacoes = rsContratacoes.getInt("total");
                }
                rsContratacoes.close();
                stmContratacoes.close();
                
                // Contar serviços oferecidos
                String sqlServicos = "SELECT COUNT(*) as total FROM servicos WHERE idPrestador = ? AND status = 'ativo'";
                PreparedStatement stmServicos = conn.prepareStatement(sqlServicos);
                stmServicos.setInt(1, idUsuario);
                ResultSet rsServicos = stmServicos.executeQuery();
                int totalServicos = 0;
                if(rsServicos.next()) {
                    totalServicos = rsServicos.getInt("total");
                }
                rsServicos.close();
                stmServicos.close();
        %>

        <div class="perfil-grid">
            <!-- Card do Perfil -->
            <div class="perfil-card">
                <div class="perfil-avatar" onclick="alert('Funcionalidade de upload de foto em breve!')">
                    👤
                    <div class="perfil-avatar-overlay">📷</div>
                </div>
                
                <h2 class="perfil-nome"><%= nome %> <%= sobrenome %></h2>
                <p class="perfil-email"><%= email %></p>
                
                <div class="perfil-stats">
                    <div class="stat-item">
                        <div class="stat-number"><%= totalContratacoes %></div>
                        <div class="stat-label">Contratações</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number"><%= totalServicos %></div>
                        <div class="stat-label">Serviços Oferecidos</div>
                    </div>
                </div>
            </div>

            <!-- Card de Informações -->
            <div class="info-card">
                <div class="tabs">
                    <button class="tab active" onclick="showTab('dados')">📝 Dados Pessoais</button>
                    <button class="tab" onclick="showTab('atividades')">📊 Atividades</button>
                    <button class="tab" onclick="showTab('seguranca')">🔒 Segurança</button>
                </div>

                <!-- Tab Dados Pessoais -->
                <div id="dados-tab" class="tab-content active">
                    <h3 class="section-title">📝 Informações Pessoais</h3>
                    
                    <form id="form-perfil" method="POST" action="atualizar_perfil.jsp">
                        <div class="form-row">
                            <div class="form-group">
                                <label>Nome *</label>
                                <input type="text" name="nome" value="<%= nome %>" id="input-nome" disabled required>
                            </div>
                            <div class="form-group">
                                <label>Sobrenome *</label>
                                <input type="text" name="sobrenome" value="<%= sobrenome %>" id="input-sobrenome" disabled required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>E-mail *</label>
                            <input type="email" name="email" value="<%= email %>" id="input-email" disabled required>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Telefone</label>
                                <input type="tel" name="telefone" value="<%= telefone != null ? telefone : "" %>" id="input-telefone" disabled>
                            </div>
                            <div class="form-group">
                                <label>Cidade</label>
                                <input type="text" name="cidade" value="<%= cidade != null ? cidade : "" %>" id="input-cidade" disabled>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Estado</label>
                            <select name="estado" id="input-estado" disabled>
                                <option value="">Selecione...</option>
                                <option value="SP" <%= "SP".equals(estado) ? "selected" : "" %>>São Paulo</option>
                                <option value="RJ" <%= "RJ".equals(estado) ? "selected" : "" %>>Rio de Janeiro</option>
                                <option value="MG" <%= "MG".equals(estado) ? "selected" : "" %>>Minas Gerais</option>
                                <option value="ES" <%= "ES".equals(estado) ? "selected" : "" %>>Espírito Santo</option>
                                <option value="BA" <%= "BA".equals(estado) ? "selected" : "" %>>Bahia</option>
                                <option value="PR" <%= "PR".equals(estado) ? "selected" : "" %>>Paraná</option>
                                <option value="SC" <%= "SC".equals(estado) ? "selected" : "" %>>Santa Catarina</option>
                                <option value="RS" <%= "RS".equals(estado) ? "selected" : "" %>>Rio Grande do Sul</option>
                            </select>
                        </div>

                        <div style="margin-top: 30px;">
                            <button type="button" class="btn-editar" id="btn-editar" onclick="habilitarEdicao()">
                                ✏️ Editar Perfil
                            </button>
                            <button type="submit" class="btn-salvar" id="btn-salvar" style="display:none;">
                                ✓ Salvar Alterações
                            </button>
                            <button type="button" class="btn-cancelar" id="btn-cancelar" style="display:none;" onclick="cancelarEdicao()">
                                ✗ Cancelar
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Tab Atividades -->
                <div id="atividades-tab" class="tab-content">
                    <h3 class="section-title">📊 Atividades Recentes</h3>
                    
                    <%
                    // Buscar atividades recentes
                    String sqlAtividades = "SELECT 'contratacao' as tipo, c.dataContratacao as data, " +
                                          "s.tipoServico as descricao, c.status " +
                                          "FROM contratacoes c " +
                                          "INNER JOIN servicos s ON c.idServico = s.idServico " +
                                          "WHERE c.idSolicitante = ? " +
                                          "UNION ALL " +
                                          "SELECT 'servico' as tipo, s.dataCriacao as data, " +
                                          "s.tipoServico as descricao, s.status " +
                                          "FROM servicos s " +
                                          "WHERE s.idPrestador = ? " +
                                          "ORDER BY data DESC LIMIT 10";
                    
                    PreparedStatement stmAtividades = conn.prepareStatement(sqlAtividades);
                    stmAtividades.setInt(1, idUsuario);
                    stmAtividades.setInt(2, idUsuario);
                    ResultSet rsAtividades = stmAtividades.executeQuery();
                    
                    boolean temAtividades = false;
                    while(rsAtividades.next()) {
                        temAtividades = true;
                        String tipo = rsAtividades.getString("tipo");
                        String data = rsAtividades.getString("data");
                        String descricao = rsAtividades.getString("descricao");
                        String status = rsAtividades.getString("status");
                        
                        String icone = tipo.equals("contratacao") ? "🛒" : "🔧";
                        String titulo = tipo.equals("contratacao") ? 
                            "Contratou serviço: " + descricao : 
                            "Ofereceu serviço: " + descricao;
                        
                        String badgeClass = "";
                        String badgeText = "";
                        if("concluido".equals(status) || "ativo".equals(status)) {
                            badgeClass = "badge-success";
                            badgeText = tipo.equals("contratacao") ? "Concluído" : "Ativo";
                        } else if("pendente".equals(status)) {
                            badgeClass = "badge-warning";
                            badgeText = "Pendente";
                        } else if("confirmado".equals(status)) {
                            badgeClass = "badge-info";
                            badgeText = "Confirmado";
                        }
                    %>
                    
                    <div class="atividade-item">
                        <div class="atividade-icon"><%= icone %></div>
                        <div class="atividade-info">
                            <div class="atividade-titulo"><%= titulo %></div>
                            <div class="atividade-data"><%= data %></div>
                        </div>
                        <span class="badge <%= badgeClass %>"><%= badgeText %></span>
                    </div>
                    
                    <%
                    }
                    
                    if(!temAtividades) {
                    %>
                    <div class="empty-state">
                        <div class="empty-state-icon">📊</div>
                        <h3>Nenhuma atividade ainda</h3>
                        <p>Suas atividades aparecerão aqui</p>
                    </div>
                    <%
                    }
                    
                    rsAtividades.close();
                    stmAtividades.close();
                    %>
                </div>

                <!-- Tab Segurança -->
                <div id="seguranca-tab" class="tab-content">
                    <h3 class="section-title">🔒 Segurança da Conta</h3>
                    
                    <form method="POST" action="alterar_senha.jsp">
                        <div class="form-group">
                            <label>Senha Atual *</label>
                            <input type="password" name="senhaAtual" required>
                        </div>

                        <div class="form-group">
                            <label>Nova Senha *</label>
                            <input type="password" name="novaSenha" required minlength="6">
                        </div>

                        <div class="form-group">
                            <label>Confirmar Nova Senha *</label>
                            <input type="password" name="confirmarSenha" required minlength="6">
                        </div>

                        <button type="submit" class="btn-salvar">🔒 Alterar Senha</button>
                    </form>

                    <div style="margin-top: 40px; padding: 20px; background: #fff3cd; border-radius: 10px;">
                        <h4 style="color: #856404; margin-bottom: 10px;">⚠️ Informações Importantes</h4>
                        <ul style="color: #856404; line-height: 1.8; margin-left: 20px;">
                            <li>Membro desde: <%= dataCadastro %></li>
                            <li>Última atualização do perfil: Hoje</li>
                            <li>Sua conta está verificada ✓</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <%
            } else {
                out.print("<div style='color:white; text-align:center;'>Usuário não encontrado</div>");
            }
            
            rs.close();
            stm.close();
            conn.close();
            
        } catch(Exception e) {
            out.print("<div style='color:white; text-align:center;'>Erro: " + e.getMessage() + "</div>");
            e.printStackTrace();
        }
        %>
    </div>

    <script>
        function showTab(tabName) {
            // Ocultar todas as tabs
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });
            
            // Remover active de todos os botões
            document.querySelectorAll('.tab').forEach(btn => {
                btn.classList.remove('active');
            });
            
            // Mostrar tab selecionada
            document.getElementById(tabName + '-tab').classList.add('active');
            event.target.classList.add('active');
        }

        function habilitarEdicao() {
            // Habilitar campos
            document.querySelectorAll('#form-perfil input, #form-perfil select').forEach(input => {
                if(input.name !== 'email') { // Email não pode ser editado
                    input.disabled = false;
                }
            });
            
            // Trocar botões
            document.getElementById('btn-editar').style.display = 'none';
            document.getElementById('btn-salvar').style.display = 'inline-block';
            document.getElementById('btn-cancelar').style.display = 'inline-block';
        }

        function cancelarEdicao() {
            // Desabilitar campos
            document.querySelectorAll('#form-perfil input, #form-perfil select').forEach(input => {
                input.disabled = true;
            });
            
            // Trocar botões
            document.getElementById('btn-editar').style.display = 'inline-block';
            document.getElementById('btn-salvar').style.display = 'none';
            document.getElementById('btn-cancelar').style.display = 'none';
            
            // Recarregar página para restaurar valores originais
            location.reload();
        }
    </script>
</body>
</html>