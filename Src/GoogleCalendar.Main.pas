unit GoogleCalendar.Main;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  System.DateUtils,
  System.IOUtils,
  System.Hash,
  System.JSON,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  VCL.TMSFNCCloudBase,
  VCL.TMSFNCCloudOAuth,
  VCL.TMSFNCCloudGoogleCalendar,
  VCL.TMSFNCCustomComponent,
  VCL.TMSFNCCloudGoogle;

type
  TGoogleCalendarMain = class(TForm)
    gBoxConexao: TGroupBox;
    lbClientID: TLabel;
    lbClientSecret: TLabel;
    lbCallback: TLabel;
    lbStatus: TLabel;
    edtClientID: TEdit;
    edtClientSecret: TEdit;
    btnConectar: TButton;
    btnCancelar: TButton;
    btnSair: TButton;
    gBoxConsulta: TGroupBox;
    lbCalendarID: TLabel;
    lbDataIni: TLabel;
    lbDataFim: TLabel;
    edtCalendarID: TEdit;
    edtDataIni: TDateTimePicker;
    edtDataFim: TDateTimePicker;
    btnConsultar: TButton;
    listEventos: TListView;
    gBoxCompromisso: TGroupBox;
    lbTitulo: TLabel;
    lbLocal: TLabel;
    lbInicio: TLabel;
    lbFim: TLabel;
    lbDescricao: TLabel;
    lbSelecionado: TLabel;
    lbHorario: TLabel;
    edtTitulo: TEdit;
    edtLocal: TEdit;
    edtInicio: TDateTimePicker;
    edtHoraInicio: TDateTimePicker;
    edtFim: TDateTimePicker;
    edtHoraFim: TDateTimePicker;
    ckDiaTodo: TCheckBox;
    mmDescricao: TMemo;
    btnNovo: TButton;
    btnCriar: TButton;
    btnSalvar: TButton;
    btnExcluir: TButton;
    gBoxMensagens: TGroupBox;
    mmLog: TMemo;
    CloudCalendar: TTMSFNCCloudGoogleCalendar;
    pnCorpo: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CredenciaisChange(Sender: TObject);
    procedure edtCalendarIDChange(Sender: TObject);
    procedure ckDiaTodoClick(Sender: TObject);
    procedure btnConectarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnCriarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure listEventosSelectItem(Sender: TObject; Item: TListItem;Selected: Boolean);
    procedure CloudCalendarConnected(Sender: TObject);
    procedure CloudCalendarAccessDenied(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure CloudCalendarGetCalendar(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure CloudCalendarAddCalendarItem(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
      const ACalendarItem: TTMSFNCCloudGoogleCalendarItem);
    procedure CloudCalendarUpdateCalendarItem(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
      const ACalendarItem: TTMSFNCCloudGoogleCalendarItem);
    procedure CloudCalendarDeleteCalendarItem(Sender: TObject; const ARequestResult: TTMSFNCCloudBaseRequestResult;
      const ACalendarItem: TTMSFNCCloudGoogleCalendarItem);
  private
    FConectado: Boolean;
    FOcupado: Boolean;
    FAutenticando: Boolean;
    FEncerrando: Boolean;
    FEventoSelecionado: TTMSFNCCloudGoogleCalendarItem;
    FOperacoes: TTMSFNCCloudGoogleCalendarItems;
    procedure AtualizarControles;
    procedure DefinirOcupado(const AOcupado: Boolean);
    procedure LimparEditor;
    procedure LimparLista;
    procedure Registrar(const AMensagem: string);
    procedure RegistrarFalha(const AOperacao: string; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure CarregarEventos;
    procedure ValidarConexao;
    procedure ValidarCompromisso;
    procedure ValidarSelecao;
    procedure PreencherEvento(const AEvento: TTMSFNCCloudGoogleCalendarItem);
    procedure ConcluirOperacao(const AOperacao: string; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    function CalendarID: string;
    function EventoRecorrente: Boolean;
    function Sanitizar(const ATexto: string): string;
    function PrepararEvento(const AExistente: Boolean): TTMSFNCCloudGoogleCalendarItem;
  end;

var
  GoogleCalendarMain: TGoogleCalendarMain;

implementation

{$R *.dfm}

procedure TGoogleCalendarMain.FormCreate(Sender: TObject);
begin
  // Colecao separada: erros HTTP nao alteram o evento exibido na lista.
  FOperacoes := TTMSFNCCloudGoogleCalendarItems.Create(CloudCalendar);
  edtDataIni.Date := Date;
  edtDataFim.Date := IncDay(Date, 30);
  Self.LimparEditor;
  Self.AtualizarControles;
  Self.Registrar('Preencha Client ID e Client Secret e clique em Conectar.');
end;

procedure TGoogleCalendarMain.FormDestroy(Sender: TObject);
begin
  FEncerrando := True;
  CloudCalendar.OnConnected := nil;
  CloudCalendar.OnAccessDenied := nil;
  CloudCalendar.OnGetCalendar := nil;
  CloudCalendar.OnAddCalendarItem := nil;
  CloudCalendar.OnUpdateCalendarItem := nil;
  CloudCalendar.OnDeleteCalendarItem := nil;
  CloudCalendar.CancelRequests;
  CloudCalendar.DestroyHTTPServer;
  FOperacoes.Free;
end;

procedure TGoogleCalendarMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not FOcupado or FAutenticando;

  if not CanClose then
    MessageDlg('Aguarde a operacao com o Google terminar antes de fechar.',
      mtInformation, [mbOK], 0);
end;

procedure TGoogleCalendarMain.AtualizarControles;
begin
  edtClientID.Enabled := not FOcupado;
  edtClientSecret.Enabled := not FOcupado;
  btnConectar.Enabled := not FOcupado;
  btnCancelar.Enabled := FAutenticando;
  btnSair.Enabled := FConectado and not FOcupado;
  gBoxConsulta.Enabled := FConectado and not FOcupado;
  gBoxCompromisso.Enabled := FConectado and not FOcupado;
  btnSalvar.Enabled := Assigned(FEventoSelecionado) and not Self.EventoRecorrente;
  btnExcluir.Enabled := btnSalvar.Enabled;
  btnCriar.Enabled := not Assigned(FEventoSelecionado);
  edtHoraInicio.Enabled := not ckDiaTodo.Checked;
  edtHoraFim.Enabled := not ckDiaTodo.Checked;

  if FOcupado then
    lbStatus.Caption := 'Aguarde...'
  else if FConectado then
    lbStatus.Caption := 'Conectado ao Google Calendar'
  else
    lbStatus.Caption := 'Desconectado';
end;

procedure TGoogleCalendarMain.DefinirOcupado(const AOcupado: Boolean);
begin
  FOcupado := AOcupado;
  Self.AtualizarControles;
end;

function TGoogleCalendarMain.Sanitizar(const ATexto: string): string;
begin
  Result := ATexto;

  for var LSegredo in TArray<string>.Create(
    Trim(edtClientID.Text), Trim(edtClientSecret.Text),
    CloudCalendar.Authentication.AccessToken,
    CloudCalendar.Authentication.AccessTokenRefresh,
    CloudCalendar.Authentication.AuthenticationToken) do
    if not LSegredo.IsEmpty then
      Result := StringReplace(Result, LSegredo, '[oculto]', [rfReplaceAll]);
end;

procedure TGoogleCalendarMain.Registrar(const AMensagem: string);
begin
  mmLog.Lines.Add(FormatDateTime('hh:nn:ss', Now) + '  ' + Self.Sanitizar(AMensagem));
end;

procedure TGoogleCalendarMain.RegistrarFalha(const AOperacao: string;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  var LMensagem := 'Verifique a conexao e as permissoes da conta.';
  var LJSON := TJSONObject.ParseJSONValue(ARequestResult.ResultString);
  try
    if LJSON is TJSONObject then
    begin
      var LErro := (LJSON as TJSONObject).GetValue('error');

      if LErro is TJSONObject then
        LMensagem := (LErro as TJSONObject).GetValue<string>('message', LMensagem)
      else if Assigned(LErro) then
        LMensagem := LErro.Value;

      LMensagem := (LJSON as TJSONObject).GetValue<string>(
        'error_description', LMensagem);
    end;
  finally
    LJSON.Free;
  end;

  if ARequestResult.ResponseCode = 401 then
    FConectado := False;

  Self.Registrar(Format('%s: HTTP %d. %s',
    [AOperacao, ARequestResult.ResponseCode, LMensagem]));
end;

procedure TGoogleCalendarMain.CredenciaisChange(Sender: TObject);
begin
  FConectado := False;
  Self.LimparLista;
  Self.AtualizarControles;
end;

procedure TGoogleCalendarMain.edtCalendarIDChange(Sender: TObject);
begin
  Self.LimparLista;
end;

procedure TGoogleCalendarMain.ckDiaTodoClick(Sender: TObject);
begin
  Self.AtualizarControles;
end;

procedure TGoogleCalendarMain.btnConectarClick(Sender: TObject);
begin
  if FOcupado then
    Exit;

  if Trim(edtClientID.Text).IsEmpty then
    raise Exception.Create('Informe o Client ID.');

  if Trim(edtClientSecret.Text).IsEmpty then
    raise Exception.Create('Informe o Client Secret.');

  if CloudCalendar.RunningRequests.Count > 0 then
    raise Exception.Create('Aguarde o encerramento da requisicao anterior.');

  CloudCalendar.DestroyHTTPServer;
  CloudCalendar.Authentication.ClearTokens;
  CloudCalendar.Authentication.ClientID := Trim(edtClientID.Text);
  CloudCalendar.Authentication.Secret := Trim(edtClientSecret.Text);
  CloudCalendar.Authentication.CallBackURL := 'http://127.0.0.1:8000';
  CloudCalendar.Authentication.Locale := 'pt-BR';

  // Remove escopos padrao de outros servicos Google.
  CloudCalendar.Scopes.Clear;
  CloudCalendar.Scopes.Add('https://www.googleapis.com/auth/calendar');

  var LPasta := TPath.Combine(
    GetEnvironmentVariable('LOCALAPPDATA'), 'Code4D\GoogleCalendarDemo');
  if not ForceDirectories(LPasta) then
    raise Exception.Create('Nao foi possivel criar a pasta de tokens.');

  CloudCalendar.PersistTokens.Location := plIniFile;
  CloudCalendar.PersistTokens.Key := TPath.Combine(LPasta, 'Tokens.ini');
  CloudCalendar.PersistTokens.Section := THashSHA2.GetHashString(
    CloudCalendar.Authentication.ClientID);
  CloudCalendar.PersistTokens.SaveClientID := False;
  CloudCalendar.PersistTokens.SaveSecret := False;

  FConectado := False;
  FAutenticando := True;
  Self.LimparLista;
  Self.DefinirOcupado(True);
  Self.Registrar('Conectando. Autorize o acesso no navegador, se solicitado.');

  try
    // Connect carrega, testa e renova os tokens persistidos.
    CloudCalendar.Connect;
  except
    on E: Exception do
    begin
      FAutenticando := False;
      Self.Registrar('Falha ao conectar: ' + E.Message);
      Self.DefinirOcupado(False);
    end;
  end;
end;

procedure TGoogleCalendarMain.btnCancelarClick(Sender: TObject);
begin
  if not FAutenticando then
    Exit;

  FAutenticando := False;
  CloudCalendar.CancelRequests;
  CloudCalendar.DestroyHTTPServer;
  FConectado := False;
  Self.DefinirOcupado(False);
  Self.Registrar('Autenticacao cancelada. Feche a pagina de autorizacao.');
end;

procedure TGoogleCalendarMain.btnSairClick(Sender: TObject);
begin
  if FOcupado then
    Exit;

  CloudCalendar.DestroyHTTPServer;
  CloudCalendar.ClearTokens;
  FConectado := False;
  Self.LimparLista;
  Self.AtualizarControles;
  Self.Registrar('Sessao encerrada e tokens locais removidos.');
end;

procedure TGoogleCalendarMain.CloudCalendarConnected(Sender: TObject);
begin
  if FEncerrando or not FAutenticando then
    Exit;

  FAutenticando := False;
  FConectado := True;
  Self.DefinirOcupado(False);
  Self.Registrar('Conta autorizada. Consultando os compromissos...');
  Self.CarregarEventos;
end;

procedure TGoogleCalendarMain.CloudCalendarAccessDenied(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if FEncerrando or not FAutenticando then
    Exit;

  FAutenticando := False;
  FConectado := False;
  Self.RegistrarFalha('Autenticacao', ARequestResult);
  Self.DefinirOcupado(False);
end;

function TGoogleCalendarMain.CalendarID: string;
begin
  Result := Trim(edtCalendarID.Text);

  if Result.IsEmpty then
    raise Exception.Create('Informe o ID da agenda. Use primary para a agenda principal.');
end;

procedure TGoogleCalendarMain.ValidarConexao;
begin
  if not FConectado then
    raise Exception.Create('Conecte sua conta Google primeiro.');

  if FOcupado then
    raise Exception.Create('Aguarde a operacao atual terminar.');
end;

procedure TGoogleCalendarMain.btnConsultarClick(Sender: TObject);
begin
  Self.CarregarEventos;
end;

procedure TGoogleCalendarMain.CarregarEventos;
begin
  if DateOf(edtDataFim.Date) < DateOf(edtDataIni.Date) then
    raise Exception.Create('A data final da consulta deve ser igual ou posterior a inicial.');

  var LCalendarID := Self.CalendarID;
  Self.ValidarConexao;
  Self.LimparLista;
  Self.DefinirOcupado(True);
  Self.Registrar('Consultando a agenda ' + LCalendarID + '...');

  try
    // timeMax e exclusivo: inclui todo o dia final escolhido.
    CloudCalendar.GetCalendar(LCalendarID,
      DateOf(edtDataIni.Date), IncDay(DateOf(edtDataFim.Date)), 2500);
  except
    on E: Exception do
    begin
      Self.Registrar('Falha ao consultar: ' + E.Message);
      Self.DefinirOcupado(False);
    end;
  end;
end;

procedure TGoogleCalendarMain.CloudCalendarGetCalendar(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if FEncerrando then
    Exit;

  try
    if not ARequestResult.Success then
    begin
      Self.RegistrarFalha('Consulta', ARequestResult);
      Exit;
    end;

    listEventos.Items.BeginUpdate;
    try
      listEventos.Items.Clear;
      for var I := 0 to Pred(CloudCalendar.Items.Count) do
      begin
        var LEvento := CloudCalendar.Items[I];
        var LLinha := listEventos.Items.Add;
        LLinha.Data := LEvento;

        if LEvento.IsAllDay then
        begin
          LLinha.Caption := FormatDateTime('dd/mm/yyyy', LEvento.StartTime);
          LLinha.SubItems.Add(FormatDateTime('dd/mm/yyyy', IncDay(LEvento.EndTime, -1)));
        end
        else
        begin
          LLinha.Caption := FormatDateTime('dd/mm/yyyy hh:nn', LEvento.StartTime);
          LLinha.SubItems.Add(FormatDateTime('dd/mm/yyyy hh:nn', LEvento.EndTime));
        end;

        LLinha.SubItems.Add(LEvento.Summary);
        LLinha.SubItems.Add(LEvento.Location);

        if not LEvento.RecurringID.IsEmpty or not LEvento.Recurrence.IsEmpty then
          LLinha.SubItems.Add('Recorrente')
        else if LEvento.IsAllDay then
          LLinha.SubItems.Add('Dia todo')
        else
          LLinha.SubItems.Add('Simples');
      end;
    finally
      listEventos.Items.EndUpdate;
    end;

    Self.Registrar(Format('%d compromisso(s) recebido(s).', [CloudCalendar.Items.Count]));

    if CloudCalendar.Items.Count >= 2500 then
      Self.Registrar('Limite de 2.500 registros atingido. Reduza o periodo da consulta.');
  finally
    Self.DefinirOcupado(False);
  end;
end;

procedure TGoogleCalendarMain.LimparEditor;
begin
  FEventoSelecionado := nil;
  lbSelecionado.Caption := 'Novo compromisso';
  edtTitulo.Clear;
  edtLocal.Clear;
  mmDescricao.Clear;
  edtInicio.Date := IncDay(Date);
  edtFim.Date := edtInicio.Date;
  edtHoraInicio.Time := EncodeTime(10, 0, 0, 0);
  edtHoraFim.Time := EncodeTime(10, 30, 0, 0);
  ckDiaTodo.Checked := False;
  Self.AtualizarControles;
end;

procedure TGoogleCalendarMain.LimparLista;
begin
  FEventoSelecionado := nil;
  listEventos.Items.Clear;
  Self.LimparEditor;
end;

procedure TGoogleCalendarMain.btnNovoClick(Sender: TObject);
begin
  Self.ValidarConexao;
  listEventos.Selected := nil;
  Self.LimparEditor;
  edtTitulo.SetFocus;
end;

function TGoogleCalendarMain.EventoRecorrente: Boolean;
begin
  Result := Assigned(FEventoSelecionado) and
    (not FEventoSelecionado.RecurringID.IsEmpty or
     not FEventoSelecionado.Recurrence.IsEmpty);
end;

procedure TGoogleCalendarMain.listEventosSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if FOcupado then
    Exit;

  if not Selected then
  begin
    if Assigned(FEventoSelecionado) and (Item.Data = Pointer(FEventoSelecionado)) then
      Self.LimparEditor;
    Exit;
  end;

  FEventoSelecionado := TTMSFNCCloudGoogleCalendarItem(Item.Data);
  if not Assigned(FEventoSelecionado) then
    Exit;

  edtTitulo.Text := FEventoSelecionado.Summary;
  edtLocal.Text := FEventoSelecionado.Location;
  mmDescricao.Text := FEventoSelecionado.Description;
  edtInicio.Date := DateOf(FEventoSelecionado.StartTime);
  edtHoraInicio.Time := TimeOf(FEventoSelecionado.StartTime);
  edtHoraFim.Time := TimeOf(FEventoSelecionado.EndTime);
  ckDiaTodo.Checked := FEventoSelecionado.IsAllDay;

  if ckDiaTodo.Checked then
    edtFim.Date := IncDay(DateOf(FEventoSelecionado.EndTime), -1)
  else
    edtFim.Date := DateOf(FEventoSelecionado.EndTime);

  if Self.EventoRecorrente then
    lbSelecionado.Caption := 'Evento recorrente: somente consulta'
  else
    lbSelecionado.Caption := 'Selecionado: ' + FEventoSelecionado.ID;

  Self.AtualizarControles;
end;

procedure TGoogleCalendarMain.ValidarCompromisso;
begin
  if Trim(edtTitulo.Text).IsEmpty then
    raise Exception.Create('Informe o titulo do compromisso.');

  if ckDiaTodo.Checked then
  begin
    if DateOf(edtFim.Date) < DateOf(edtInicio.Date) then
      raise Exception.Create('A data final deve ser igual ou posterior a inicial.');
  end
  else if DateOf(edtFim.Date) + TimeOf(edtHoraFim.Time) <=
    DateOf(edtInicio.Date) + TimeOf(edtHoraInicio.Time) then
    raise Exception.Create('O termino deve ser posterior ao inicio do compromisso.');
end;

procedure TGoogleCalendarMain.ValidarSelecao;
begin
  if not Assigned(FEventoSelecionado) then
    raise Exception.Create('Selecione um compromisso na lista.');

  if Self.EventoRecorrente then
    raise Exception.Create('Este exemplo permite apenas consultar eventos recorrentes.');
end;

procedure TGoogleCalendarMain.PreencherEvento(
  const AEvento: TTMSFNCCloudGoogleCalendarItem);
begin
  AEvento.Summary := Trim(edtTitulo.Text);
  AEvento.Location := Trim(edtLocal.Text);
  AEvento.Description := mmDescricao.Text;
  AEvento.IsAllDay := ckDiaTodo.Checked;

  if AEvento.IsAllDay then
  begin
    AEvento.StartTime := DateOf(edtInicio.Date);
    // Na tela o ultimo dia e inclusivo; na API o termino e exclusivo.
    AEvento.EndTime := IncDay(DateOf(edtFim.Date));
  end
  else
  begin
    // O conector TMS converte estes horarios locais para UTC na requisicao.
    AEvento.StartTime := DateOf(edtInicio.Date) + TimeOf(edtHoraInicio.Time);
    AEvento.EndTime := DateOf(edtFim.Date) + TimeOf(edtHoraFim.Time);
  end;
end;

function TGoogleCalendarMain.PrepararEvento(
  const AExistente: Boolean): TTMSFNCCloudGoogleCalendarItem;
begin
  FOperacoes.Clear;
  Result := FOperacoes.Add;

  if AExistente then
  begin
    Result.ID := FEventoSelecionado.ID;
    Result.CalendarID := FEventoSelecionado.CalendarID;
    Result.Sequence := FEventoSelecionado.Sequence;
    Result.Visibility := FEventoSelecionado.Visibility;
    Result.Color := FEventoSelecionado.Color;
    Result.TimeZone := FEventoSelecionado.TimeZone;
    Result.UseDefaultReminders := FEventoSelecionado.UseDefaultReminders;

    // Evita Assign do item: na versao instalada ele compartilha subcolecoes.
    for var I := 0 to Pred(FEventoSelecionado.Attendees.Count) do
      Result.Attendees.Add.Assign(FEventoSelecionado.Attendees[I]);

    for var I := 0 to Pred(FEventoSelecionado.Reminders.Count) do
      Result.Reminders.Add.Assign(FEventoSelecionado.Reminders[I]);
  end
  else
  begin
    // O conector sempre envia id; UUID hexadecimal e um ID valido no Google.
    Result.ID := TGUID.NewGuid.ToString.Replace('{', '').Replace('}', '')
      .Replace('-', '').ToLower;
    Result.CalendarID := Self.CalendarID;
    Result.Visibility := viDefault;
  end;

  Self.PreencherEvento(Result);
end;

procedure TGoogleCalendarMain.btnCriarClick(Sender: TObject);
begin
  Self.ValidarCompromisso;
  Self.ValidarConexao;

  if Assigned(FEventoSelecionado) then
    raise Exception.Create('Clique em Novo antes de criar outro compromisso.');

  var LEvento := Self.PrepararEvento(False);
  Self.DefinirOcupado(True);
  Self.Registrar('Criando o compromisso...');

  try
    CloudCalendar.Add(LEvento);
  except
    on E: Exception do
    begin
      FOperacoes.Clear;
      Self.Registrar('Falha ao criar: ' + E.Message);
      Self.DefinirOcupado(False);
    end;
  end;
end;

procedure TGoogleCalendarMain.btnSalvarClick(Sender: TObject);
begin
  Self.ValidarSelecao;
  Self.ValidarCompromisso;
  Self.ValidarConexao;
  var LEvento := Self.PrepararEvento(True);
  Self.DefinirOcupado(True);
  Self.Registrar('Salvando as alteracoes...');

  try
    CloudCalendar.Update(LEvento);
  except
    on E: Exception do
    begin
      FOperacoes.Clear;
      Self.Registrar('Falha ao alterar: ' + E.Message);
      Self.DefinirOcupado(False);
    end;
  end;
end;

procedure TGoogleCalendarMain.btnExcluirClick(Sender: TObject);
begin
  Self.ValidarSelecao;
  Self.ValidarConexao;

  if MessageDlg('Excluir o compromisso "' + FEventoSelecionado.Summary + '"?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  FOperacoes.Clear;
  var LEvento := FOperacoes.Add;
  LEvento.ID := FEventoSelecionado.ID;
  LEvento.CalendarID := FEventoSelecionado.CalendarID;
  Self.DefinirOcupado(True);
  Self.Registrar('Excluindo o compromisso...');

  try
    CloudCalendar.Delete(LEvento);
  except
    on E: Exception do
    begin
      FOperacoes.Clear;
      Self.Registrar('Falha ao excluir: ' + E.Message);
      Self.DefinirOcupado(False);
    end;
  end;
end;

procedure TGoogleCalendarMain.ConcluirOperacao(const AOperacao: string;
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  FOperacoes.Clear;
  if not ARequestResult.Success then
  begin
    Self.RegistrarFalha(AOperacao, ARequestResult);
    Self.DefinirOcupado(False);
    Exit;
  end;

  Self.Registrar(AOperacao + ' concluida. Atualizando a consulta.');
  Self.DefinirOcupado(False);
  Self.CarregarEventos;
end;

procedure TGoogleCalendarMain.CloudCalendarAddCalendarItem(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult;
  const ACalendarItem: TTMSFNCCloudGoogleCalendarItem);
begin
  if FEncerrando then
    Exit;

  if ARequestResult.Success and Assigned(ACalendarItem) then
    Self.Registrar('ID criado: ' + ACalendarItem.ID);

  Self.ConcluirOperacao('Criacao', ARequestResult);
end;

procedure TGoogleCalendarMain.CloudCalendarUpdateCalendarItem(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult;
  const ACalendarItem: TTMSFNCCloudGoogleCalendarItem);
begin
  if not FEncerrando then
    Self.ConcluirOperacao('Alteracao', ARequestResult);
end;

procedure TGoogleCalendarMain.CloudCalendarDeleteCalendarItem(Sender: TObject;
  const ARequestResult: TTMSFNCCloudBaseRequestResult;
  const ACalendarItem: TTMSFNCCloudGoogleCalendarItem);
begin
  if not FEncerrando then
    Self.ConcluirOperacao('Exclusao', ARequestResult);
end;

end.
