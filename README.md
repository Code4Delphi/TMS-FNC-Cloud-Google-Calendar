# Google Calendar com Delphi VCL e TMS FNC Cloud Pack
Exemplo didático de consulta, criação, alteração e exclusão de compromissos. As credenciais são digitadas na tela.


## Conectar
1. Preencha **Client ID** e **Client Secret**.
2. Clique em **Conectar**.
3. Se o navegador abrir, selecione a conta e autorize o acesso.
4. Aguarde a indicação de conexão e a primeira consulta automática.

O callback é `http://127.0.0.1:8000`, configurado no código. O componente inicia um servidor de callback local para receber a autorização. Para um cliente OAuth Desktop, você não precisa cadastrar um domínio de site para esse fluxo.

O botão **Cancelar autenticação** interrompe a tentativa local; feche também a
página de autorização do navegador. Ele não cancela operações de gravação já enviadas.

## Consultar
- `primary` identifica a agenda principal da conta autenticada.
- Para outra agenda, informe seu ID em **ID da agenda**.
- As datas inicial e final são inclusivas na tela.
- Clique em **Consultar** para carregar os compromissos.
- A consulta retorna até 1.500 registros. Ao atingir esse limite, reduza o período.
- Ao mudar o ID da agenda, a lista e a seleção são limpas; consulte novamente.
- **Conectar** também pode ser usado novamente para testar ou renovar a sessão.
  Se receber HTTP 401, reconecte antes de repetir a operação.

## Criar, alterar e excluir
- É possível adicionar alterar e excluir compromissos pelo form

## Como gerar as credenciais do Google Calendar
1. Acesse o [Google Cloud Console](https://console.cloud.google.com/).
2. Crie um projeto e mantenha-o selecionado durante toda a configuração.
3. Ative a API em **APIs e serviços → Biblioteca → Google Calendar API → Ativar**.
4. Acesse **Tela de permissão OAuth** e clique em **Vamos começar**.
5. Preencha as informações do aplicativo:
   - **Nome:** nome do seu sistema.
   - **E-mail de suporte:** seu e-mail.
   - **Público:** Externo, para permitir o acesso com contas Gmail.
   - **Dados de contato:** seu e-mail.
   Avance, aceite os termos apresentados e clique em **Criar**.
   
7. Clique em **Criar um cliente OAuth** e preencha:
   - **Tipo de aplicativo:** Aplicativo para computador.
   - **Nome:** um nome para identificar sua aplicação, como `Agenda Delphi Windows`.
   Clique em **Criar**.

8. Copie o **ID do cliente (Client ID)** e a **Chave secreta do cliente (Client Secret)**. Esses valores serão informados na tela do exemplo Delphi.
9. Acesse **Público-alvo → Usuários de teste → Adicionar usuários**. Informe o e-mail da conta cuja agenda será acessada e clique em **Salvar**.

Confira o passo a passo completo no vídeo de demonstração abaixo. 

## Credenciais e sessão
- Client ID e Client Secret não são gravados pelo exemplo e devem ser preenchidos  a cada execução.
- Os tokens são persistidos pelo mecanismo `PersistTokens` da TMS em `%LOCALAPPDATA%\Code4D\GoogleCalendarDemo\Tokens.ini`.
- Cada Client ID utiliza uma seção diferente, identificada por seu hash SHA-256.
  O exemplo trabalha com uma conta por Client ID de cada vez.
- **Sair** limpa os valores dos tokens locais, permitindo uma nova conexão.
  Isso não revoga a autorização do aplicativo na conta Google.
- Alterar as credenciais desabilita as operações até uma nova conexão.
- Mensagens de erro não exibem Client ID, Client Secret ou tokens.
- O log HTTP detalhado do componente permanece desativado.
- Aplicativos externos em modo de teste podem exigir nova autorização após a
  expiração do refresh token de teste do Google.

Chamadas e eventos principais:

| Operação | Método | Evento de conclusão |
|---|---|---|
| Conectar | `Connect` | `OnConnected` |
| Consultar | `GetCalendar` | `OnGetCalendar` |
| Criar | `Add` | `OnAddCalendarItem` |
| Alterar | `Update` | `OnUpdateCalendarItem` |
| Excluir | `Delete` | `OnDeleteCalendarItem` |


## 🏷️ Cupom de desconto
- Use este cupom exclusivo e tenha 30% de desconto em qualquer produto da TMS:
```
2026Code4Delphi30
```

## Links úteis
|[Site oficial](https://www.tmssoftware.com/site/tmsfnccloudpack.asp)|[Documentação](https://doc.tmssoftware.com/fnc/cloudpack/googlecalendar/index.html)|
|--|--|


## Vídeos de demonstração
- [Delphi + Google Calendário: Integrando e Gerenciando Eventos + Criando Credenciais Google Calendar](https://www.youtube.com/watch?v=aQe0Lhvea4c)


## Multiplataforma
<img width="524" height="124" alt="VCL-FMX-Web-FNC" src="https://github.com/user-attachments/assets/17b23899-0e26-4901-810e-f9a03e38deae" />

<br>

## 📞 Contatos
[![Telegram](https://img.shields.io/badge/Telegram-Join-blue?logo=telegram)](https://t.me/Code4Delphi)
[![YouTube](https://img.shields.io/badge/YouTube-Join-red?logo=youtube&logoColor=red)](https://www.youtube.com/@code4delphi)
[![Instagram](https://img.shields.io/badge/Intagram-Follow-red?logo=instagram&logoColor=pink)](https://www.instagram.com/code4delphi/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://www.linkedin.com/in/cesar-cardoso-dev)
[![Blog](https://img.shields.io/badge/Blog-Code4Delphi-F00?logo=delphi)](https://code4delphi.com.br/blog/)
[![Course](https://img.shields.io/badge/Course-Delphi-F00?logo=delphi)](https://code4delphi.github.io/ia-devs-delphi-lazarus/)
[![E-mail](https://img.shields.io/badge/E--mail-Send-yellowgreen?logo=maildotru&logoColor=yellowgreen)](mailto:contato@code4delphi.com.br)
