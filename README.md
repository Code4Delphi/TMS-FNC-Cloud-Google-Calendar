# Google Calendar com Delphi VCL e TMS FNC Cloud Pack

Exemplo didático de consulta, criação, alteração e exclusão de compromissos.
As credenciais são digitadas na tela. Não existe importação de JSON.

## Requisitos

- Delphi 12, projeto VCL para Windows 32 bits.
- TMS FNC Core e TMS FNC Cloud Pack instalados no Delphi.
- Google Calendar API ativada no seu projeto Google Cloud.
- Cliente OAuth do tipo **Aplicativo para computador**.
- Sua conta adicionada aos usuários de teste quando o aplicativo estiver em modo de teste.
- Permissão `https://www.googleapis.com/auth/calendar` configurada no Google Auth Platform.

## Abrir e compilar

1. Abra `GoogleCalendarDemo.dproj` no Delphi.
2. Selecione **Debug / Windows 32-bit**.
3. Compile com **Build** e execute com **Run**.
4. O executável é gerado em `bin\Win32\Debug\GoogleCalendarDemo.exe`.

O projeto usa vínculo estático, sem exigir BPLs do TMS ao lado do executável.
O caminho padrão das dependências é:
`%LOCALAPPDATA%\TMS Setup\Products\tms.fnc.cloudpack\source` e
`%LOCALAPPDATA%\TMS Setup\Products\tms.fnc.core\source`.
Se a instalação estiver em outro lugar, ajuste a propriedade MSBuild
`TMSProductsDir` do projeto ou os caminhos de pesquisa na IDE.

No terminal de comandos do RAD Studio:

```bat
msbuild GoogleCalendarDemo.dproj /t:Build /p:Config=Debug /p:Platform=Win32
```

## Conectar

1. Preencha **Client ID** e **Client Secret**. O segredo fica mascarado.
2. Clique em **Conectar**.
3. Se o navegador abrir, selecione a conta e autorize o acesso.
4. Aguarde a indicação de conexão e a primeira consulta automática.

O callback é `http://127.0.0.1:8000`, configurado no código. O componente
inicia um servidor de callback local para receber a autorização. Para um cliente
OAuth Desktop, você não precisa cadastrar um domínio de site para esse fluxo.

O botão **Cancelar autenticação** interrompe a tentativa local; feche também a
página de autorização do navegador. Ele não cancela operações de gravação já enviadas.

## Consultar

- `primary` identifica a agenda principal da conta autenticada.
- Para outra agenda, informe seu ID em **ID da agenda**.
- As datas inicial e final são inclusivas na tela.
- Clique em **Consultar** para carregar os compromissos.
- A consulta retorna até 2.500 registros. Ao atingir esse limite, reduza o período.
- Ao mudar o ID da agenda, a lista e a seleção são limpas; consulte novamente.
- **Conectar** também pode ser usado novamente para testar ou renovar a sessão.
  Se receber HTTP 401, reconecte antes de repetir a operação.

## Criar, alterar e excluir

### Criar

1. Clique em **Novo**.
2. Informe título, início e término. Local e descrição são opcionais.
3. Para um compromisso de dia inteiro, marque **Dia todo** e informe o primeiro e
   o último dia. Um evento de um dia usa a mesma data nos dois campos.
4. Clique em **Criar** e aguarde o retorno do Google.

### Alterar

1. Selecione um compromisso na lista.
2. Altere os campos no editor.
3. Clique em **Salvar alterações**.
4. A identificação original é preservada; a operação não cria uma cópia do evento.

### Excluir

1. Selecione um compromisso simples.
2. Clique em **Excluir**.
3. Confirme a exclusão na caixa de diálogo.
4. Aguarde a confirmação da API e a atualização da lista.

A lista só é atualizada após a conclusão da operação. Um evento criado fora do
período consultado continuará no Google, mas só aparecerá ao ajustar o período.

## Horários e dia inteiro

Os horários exibidos e digitados são locais ao Windows. O conector TMS converte
os horários para UTC ao montar as requisições. Configure corretamente o fuso do
Windows na máquina que executa o exemplo.

O Google usa uma data de término **exclusiva** nos eventos de dia inteiro. O
exemplo soma um dia ao enviar e subtrai um dia ao preencher o último dia na tela.
Por exemplo, 10/11/2026 a 10/11/2026 na tela é enviado como início 10/11/2026 e
término exclusivo 11/11/2026.

## Credenciais e sessão

- Client ID e Client Secret não são gravados pelo exemplo e devem ser preenchidos
  a cada execução.
- Os tokens são persistidos pelo mecanismo `PersistTokens` da TMS em
  `%LOCALAPPDATA%\Code4D\GoogleCalendarDemo\Tokens.ini`.
- Cada Client ID utiliza uma seção diferente, identificada por seu hash SHA-256.
  O exemplo trabalha com uma conta por Client ID de cada vez.
- **Sair** limpa os valores dos tokens locais, permitindo uma nova conexão.
  Isso não revoga a autorização do aplicativo na conta Google.
- Alterar as credenciais desabilita as operações até uma nova conexão.
- Mensagens de erro não exibem Client ID, Client Secret ou tokens.
- O log HTTP detalhado do componente permanece desativado.
- Aplicativos externos em modo de teste podem exigir nova autorização após a
  expiração do refresh token de teste do Google.

## Organização do código

- `GoogleCalendarDemo.dpr` e `GoogleCalendarDemo.dproj`: projeto e referência ao formulário.
- `GoogleCalendar.Main.pas`: autenticação, validações, consulta e CRUD.
- `GoogleCalendar.Main.dfm`: todos os componentes e eventos configurados no designer.
- A lista mantém a referência ao objeto recebido e sua identidade na API.
- Uma coleção temporária mantém os objetos enviados até seus callbacks; erros
  de gravação não alteram os dados originais exibidos na lista.
- A cópia dos dados enviados é explícita: evita o compartilhamento de coleções
  de participantes e lembretes pelo `Assign` da versão TMS instalada.
- Nenhuma unit TMS foi modificada.
- Novos eventos recebem um UUID hexadecimal sem separadores, pois o conector
  instalado sempre envia o campo ID. Esse formato atende aos
  [requisitos de ID do Google](https://developers.google.com/workspace/calendar/api/v3/reference/events#id).

Chamadas e eventos principais:

| Operação | Método | Evento de conclusão |
|---|---|---|
| Conectar | `Connect` | `OnConnected` |
| Consultar | `GetCalendar` | `OnGetCalendar` |
| Criar | `Add` | `OnAddCalendarItem` |
| Alterar | `Update` | `OnUpdateCalendarItem` |
| Excluir | `Delete` | `OnDeleteCalendarItem` |

## Limites do exemplo

O CRUD é voltado a compromissos simples, inclusive de dia inteiro. Eventos
recorrentes são apenas consultados; os botões de alteração e exclusão ficam
bloqueados. Não há interface para regras de recorrência, participantes, Google
Meet, compartilhamento ou gerenciamento de agendas. Este exemplo não implementa
sincronização em segundo plano nem paginação além dos 2.500 registros da consulta.

Use compromissos simples de teste para o roteiro abaixo. Campos avançados não
representados pelo conector instalado não fazem parte da demonstração de edição.

## Teste real com sua conta

1. Conecte a conta e consulte um período que inclua amanhã.
2. Crie um evento chamado **Teste Delphi Google Calendar**, amanhã, das 10:00 às 10:30.
3. Confirme o evento na lista e no Google Calendar.
4. Selecione-o, altere o título e o horário e clique em **Salvar alterações**.
5. Confira que o mesmo evento foi alterado.
6. Selecione-o, clique em **Excluir**, cancele a confirmação e confira que ele permanece.
7. Repita a exclusão e confirme; confira sua remoção na lista e no Google Calendar.
8. Crie um evento de **Dia todo**, com o primeiro e o último dia iguais, e confira
   que ele ocupa apenas esse dia. Altere o último dia, confira e exclua o evento.
9. Consulte um evento recorrente e confira que sua alteração e exclusão estão bloqueadas.
10. Use **Sair**, confira o bloqueio das operações e reconecte a conta.
11. Para testar um erro de permissão, tente consultar uma agenda à qual a conta
    não tenha acesso e confira a mensagem retornada.

## Verificação realizada na criação

- Compilação Debug/Win32 por `dcc32`: concluída.
- Conversão do DFM em cópia temporária com `convert.exe -i`: concluída.
- Carregamento real do formulário e 26 verificações locais: concluídos, sem
  chamadas ao Google. Foram cobertos campos obrigatórios, datas, seleção,
  recorrência, término exclusivo de dia inteiro e ocultação de credenciais.
- O MSBuild deste ambiente encontrou um bloqueio de acesso ao Registro na tarefa
  Embarcadero BRCC32, anterior à compilação. A compilação foi concluída diretamente
  com o compilador e o compilador de recursos do RAD Studio. O projeto permanece
  disponível para abrir e compilar normalmente na IDE.
- A autenticação e o CRUD contra o Google dependem das suas credenciais e não
  foram executados automaticamente.

Documentação:
- [TMS Google Calendar](https://doc.tmssoftware.com/fnc/cloudpack/googlecalendar/)
- [Google Calendar API](https://developers.google.com/workspace/calendar/api)
