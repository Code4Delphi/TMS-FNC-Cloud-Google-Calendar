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


