<%@page language="java" import="java.sql.*, java.util.*, java.text.*"%> 
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%
// Verificar se está logado
Integer idUsuarioLogado = (Integer) session.getAttribute("idUsuario");
if (idUsuarioLogado == null) {
    response.sendRedirect("login.html?redirect=contratar_servico.jsp?id=" + request.getParameter("id"));
    return;
}

String idServicoParam = request.getParameter("id");
if (idServicoParam == null) {
    response.sendRedirect("servicos_lista.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contratar Serviço - Mão Amiga</title>
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

        .container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            max-width: 1100px;
            width: 100%;
        }

        .card-formulario {
            background: white;
            border-radius: 25px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        .card-formulario h2 {
            font-size: 22px;
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 25px;
        }

        .tab {
            flex: 1;
            padding: 12px;
            background: #E8E8E8;
            border: none;
            border-radius: 15px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .tab.active {
            background: #16a5a8;
            color: white;
        }

        .prestador-mini {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
            padding: 15px;
            background: #f5f5f5;
            border-radius: 15px;
        }

        .avatar-mini {
            width: 60px;
            height: 60px;
            background: #d0d0d0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
        }

        .prestador-mini-info h3 {
            font-size: 16px;
            margin-bottom: 3px;
            color: #333;
        }

        .prestador-mini-info p {
            font-size: 12px;
            color: #666;
        }

        .form-section {
            margin-bottom: 25px;
        }

        .form-section h3 {
            font-size: 16px;
            margin-bottom: 15px;
            color: #333;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }

        .calendario {
            background: #f5f5f5;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
        }

        .calendario-header {
            background: black;
            color: white;
            padding: 8px;
            border-radius: 8px;
            font-size: 14px;
            margin-bottom: 15px;
        }

        .calendario-dias {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 8px;
            margin-bottom: 10px;
        }

        .dia-semana {
            font-size: 12px;
            font-weight: 600;
            color: #666;
            padding: 5px;
        }

        .dia {
            padding: 10px;
            background: white;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }

        .dia:hover:not(.disabled) {
            background: #16a5a8;
            color: white;
        }

        .dia.selected {
            background: #16a5a8 !important;
            color: white;
            font-weight: bold;
        }

        .dia.disabled {
            background: #e0e0e0;
            color: #999;
            cursor: not-allowed;
        }

        .horario-section {
            background: #f5f5f5;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
        }

        .horario-section h3 {
            font-size: 14px;
            margin-bottom: 15px;
        }

        .horario-display {
            background: black;
            color: white;
            padding: 15px 30px;
            border-radius: 10px;
            font-size: 32px;
            font-weight: bold;
            letter-spacing: 2px;
            display: inline-block;
            font-family: 'Courier New', monospace;
        }

        .btn-contratar {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #16a5a8 0%, #91d96f 100%);
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 20px;
        }

        .btn-contratar:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(22, 165, 168, 0.4);
        }

        .btn-contratar:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .card-info {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .aviso-box {
            background: #dc3545;
            color: white;
            padding: 20px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(220, 53, 69, 0.3);
        }

        .detalhes-prestador {
            background: white;
            border-radius: 25px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        .prestador-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 25px;
        }

        .avatar-grande {
            width: 90px;
            height: 90px;
            background: #d0d0d0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 45px;
        }

        .prestador-header-info h2 {
            font-size: 24px;
            margin-bottom: 5px;
            color: #333;
        }

        .prestador-header-info p {
            font-size: 14px;
            color: #666;
        }

        .descricao-servico {
            background: #f5f5f5;
            padding: 20px;
            border-radius: 15px;
        }

        .descricao-servico h3 {
            font-size: 18px;
            margin-bottom: 10px;
            color: #333;
        }

        .descricao-servico p {
            font-size: 14px;
            color: #666;
            line-height: 1.6;
        }

        @media (max-width: 900px) {
            .container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%
    try {
        String database = "maoamiga";
        String endereco = "jdbc:mysql://localhost:3306/" + database;
        String usuario = "root";
        String senha = "";
        String driver = "com.mysql.jdbc.Driver";

        Class.forName(driver);
        Connection conexao = DriverManager.getConnection(endereco, usuario, senha);

        String sql = "SELECT s.*, u.nome, u.sobrenome, u.telefone, u.email " +
                     "FROM servicos s " +
                     "INNER JOIN usuario u ON s.idPrestador = u.idUsuario " +
                     "WHERE s.idServico = ?";
        
        PreparedStatement stm = conexao.prepareStatement(sql);
        stm.setInt(1, Integer.parseInt(idServicoParam));
        ResultSet rs = stm.executeQuery();

        if (rs.next()) {
            String tipoServico = rs.getString("tipoServico");
            String descricao = rs.getString("descricao");
            double precoEstimado = rs.getDouble("precoEstimado");
            String tempoEstimado = rs.getString("tempoEstimado");
            String nomePrestador = rs.getString("nome") + " " + rs.getString("sobrenome");
            String telefonePrestador = rs.getString("telefone");
            
            // Gerar calendário do mês atual
            Calendar cal = Calendar.getInstance();
            int mesAtual = cal.get(Calendar.MONTH);
            int anoAtual = cal.get(Calendar.YEAR);
            int diaAtual = cal.get(Calendar.DAY_OF_MONTH);
            
            SimpleDateFormat sdf = new SimpleDateFormat("MMMM yyyy", new Locale("pt", "BR"));
            String mesAno = sdf.format(cal.getTime()).toUpperCase();
    %>
    
    <div class="container">
        <div class="card-formulario">
            <h2>Detalhe suas informações</h2>

            <div class="tabs">
                <button class="tab active">Endereço</button>
            </div>

            <div class="prestador-mini">
                <div class="avatar-mini">👤</div>
                <div class="prestador-mini-info">
                    <h3><%= nomePrestador %></h3>
                    <p>R$ <%= String.format("%.2f", precoEstimado) %> • <%= tempoEstimado %></p>
                </div>
            </div>

            <form method="POST" action="processar_contratacao.jsp" id="formContratar">
                <input type="hidden" name="idServico" value="<%= idServicoParam %>">
                <input type="hidden" name="idSolicitante" value="<%= idUsuarioLogado %>">
                <input type="hidden" name="dataSelecionada" id="dataSelecionada">
                <input type="hidden" name="horarioSelecionado" id="horarioSelecionado">
                
                <div class="form-section">
                    <h3>Endereço para o serviço</h3>
                    <div class="form-group">
                        <label>Rua / Avenida *</label>
                        <input type="text" name="endereco" required>
                    </div>
                    <div class="form-group">
                        <label>Número *</label>
                        <input type="text" name="numero" required>
                    </div>
                    <div class="form-group">
                        <label>Complemento</label>
                        <input type="text" name="complemento">
                    </div>
                </div>

                <div class="form-section">
                    <h3>Data escolhida</h3>
                    <div class="calendario">
                        <div class="calendario-header"><%= mesAno %></div>
                        <div class="calendario-dias">
                            <div class="dia-semana">D</div>
                            <div class="dia-semana">S</div>
                            <div class="dia-semana">T</div>
                            <div class="dia-semana">Q</div>
                            <div class="dia-semana">Q</div>
                            <div class="dia-semana">S</div>
                            <div class="dia-semana">S</div>
                            
                            <%
                            cal.set(Calendar.DAY_OF_MONTH, 1);
                            int primeiroDiaSemana = cal.get(Calendar.DAY_OF_WEEK) - 1;
                            int diasNoMes = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
                            
                            // Dias vazios antes do primeiro dia
                            for (int i = 0; i < primeiroDiaSemana; i++) {
                                out.print("<div class='dia disabled'></div>");
                            }
                            
                            // Dias do mês
                            for (int dia = 1; dia <= diasNoMes; dia++) {
                                String classe = dia < diaAtual ? "dia disabled" : "dia";
                                String dataCompleta = anoAtual + "-" + String.format("%02d", mesAtual + 1) + "-" + String.format("%02d", dia);
                                out.print("<div class='" + classe + "' data-data='" + dataCompleta + "'>" + dia + "</div>");
                            }
                            %>
                        </div>
                    </div>
                </div>

                <div class="horario-section">
                    <h3>Horário</h3>
                    <div class="horario-display" id="horario">06:00</div>
                </div>

                <button type="submit" class="btn-contratar" id="btnContratar" disabled>Contratar este serviço</button>
            </form>
        </div>

        <div class="card-info">
            <div class="aviso-box">
                <p><strong>Depois de escolher o prestador, o usuário escolhe a data, hora e especifica o endereço de sua casa</strong></p>
            </div>

            <div class="detalhes-prestador">
                <div class="prestador-header">
                    <div class="avatar-grande">👤</div>
                    <div class="prestador-header-info">
                        <h2><%= nomePrestador %></h2>
                        <p><%= telefonePrestador != null ? "Tel: " + telefonePrestador : "Prestador de serviços" %></p>
                    </div>
                </div>

                <div class="descricao-servico">
                    <h3>Descrição do serviço</h3>
                    <p><strong><%= tipoServico %></strong></p>
                    <p><%= descricao %></p>
                    <p><strong>Tempo estimado:</strong> <%= tempoEstimado %></p>
                    <p><strong>Valor:</strong> R$ <%= String.format("%.2f", precoEstimado) %></p>
                </div>
            </div>
        </div>
    </div>

    <script>
        let dataSelecionada = null;
        let horaSelecionada = 6;
        let minutoSelecionado = 0;

        // Selecionar dia
        document.querySelectorAll('.dia:not(.disabled)').forEach(dia => {
            dia.addEventListener('click', function() {
                document.querySelectorAll('.dia').forEach(d => d.classList.remove('selected'));
                this.classList.add('selected');
                dataSelecionada = this.dataset.data;
                document.getElementById('dataSelecionada').value = dataSelecionada;
                verificarFormulario();
            });
        });

        // Selecionar horário
        document.getElementById('horario').addEventListener('click', function() {
            minutoSelecionado += 30;
            if (minutoSelecionado >= 60) {
                minutoSelecionado = 0;
                horaSelecionada++;
                if (horaSelecionada >= 24) horaSelecionada = 0;
            }
            atualizarHorario();
        });

        function atualizarHorario() {
            const horaStr = String(horaSelecionada).padStart(2, '0');
            const minutoStr = String(minutoSelecionado).padStart(2, '0');
            document.getElementById('horario').textContent = horaStr + ':' + minutoStr;
            document.getElementById('horarioSelecionado').value = horaStr + ':' + minutoStr;
        }

        function verificarFormulario() {
            const btnContratar = document.getElementById('btnContratar');
            if (dataSelecionada) {
                btnContratar.disabled = false;
            }
        }

        // Inicializar horário
        atualizarHorario();
    </script>

    <%
        } else {
            out.print("<div style='color:white; text-align:center; padding:50px;'>");
            out.print("<h2>Serviço não encontrado</h2>");
            out.print("<br><a href='servicos_lista.jsp' style='color:white;'>Voltar</a>");
            out.print("</div>");
        }

        rs.close();
        stm.close();
        conexao.close();

    } catch (Exception e) {
        out.print("<div style='color:white; text-align:center; padding:50px;'>");
        out.print("<h2>Erro: " + e.getMessage() + "</h2>");
        out.print("</div>");
        e.printStackTrace();
    }
    %>
</body>
</html>