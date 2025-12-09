<%@page language="java"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// Invalida a sessão
session.invalidate();
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Saindo - Mão Amiga</title>
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

        .logout-box {
            background: white;
            padding: 60px 50px;
            border-radius: 25px;
            text-align: center;
            max-width: 500px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        .logout-icon {
            font-size: 100px;
            margin-bottom: 20px;
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        h1 {
            color: #333;
            margin-bottom: 15px;
            font-size: 32px;
        }

        .mensagem {
            color: #666;
            line-height: 1.6;
            margin-bottom: 30px;
            font-size: 16px;
        }

        .btn-login {
            display: inline-block;
            padding: 15px 40px;
            background: linear-gradient(135deg, #16a5a8 0%, #91d96f 100%);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(22, 165, 168, 0.4);
        }

        .redirect-info {
            margin-top: 20px;
            font-size: 14px;
            color: #999;
        }
    </style>
</head>
<body>
    <div class="logout-box">
        <div class="logout-icon">👋</div>
        <h1>Até logo!</h1>
        <p class="mensagem">Você foi desconectado com sucesso. Esperamos vê-lo novamente em breve!</p>
        <a href="login.html" class="btn-login">Fazer Login Novamente</a>
        <p class="redirect-info">Redirecionando em <span id="countdown">3</span> segundos...</p>
    </div>

    <script>
        let count = 3;
        const countdown = document.getElementById('countdown');
        
        const interval = setInterval(() => {
            count--;
            countdown.textContent = count;
            
            if(count <= 0) {
                clearInterval(interval);
                window.location.href = 'login.html';
            }
        }, 1000);
    </script>
</body>
</html>