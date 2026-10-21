object GoogleCalendarMain: TGoogleCalendarMain
  Left = 0
  Top = 0
  Caption = 'Google Calendar - TMS FNC Cloud Pack'
  ClientHeight = 780
  ClientWidth = 1100
  Color = clBtnFace
  Constraints.MinHeight = 819
  Constraints.MinWidth = 1116
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnCorpo: TPanel
    Left = 0
    Top = 150
    Width = 1100
    Height = 456
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 4
    object gBoxConsulta: TGroupBox
      Left = 0
      Top = 0
      Width = 688
      Height = 456
      Align = alClient
      Caption = ' Consultar compromissos '
      Enabled = False
      TabOrder = 0
      DesignSize = (
        688
        456)
      object lbCalendarID: TLabel
        Left = 16
        Top = 24
        Width = 169
        Height = 15
        AutoSize = False
        Caption = 'ID da agenda (edtCalendarID)'
      end
      object lbDataIni: TLabel
        Left = 16
        Top = 80
        Width = 100
        Height = 15
        AutoSize = False
        Caption = 'Data inicial'
      end
      object lbDataFim: TLabel
        Left = 174
        Top = 80
        Width = 100
        Height = 15
        AutoSize = False
        Caption = 'Data final'
      end
      object edtCalendarID: TEdit
        Left = 16
        Top = 44
        Width = 390
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = 'primary'
        OnChange = edtCalendarIDChange
      end
      object edtDataIni: TDateTimePicker
        Left = 16
        Top = 99
        Width = 140
        Height = 23
        Date = 46315.000000000000000000
        Format = 'dd/MM/yyyy'
        Time = 46315.000000000000000000
        TabOrder = 1
      end
      object edtDataFim: TDateTimePicker
        Left = 174
        Top = 99
        Width = 140
        Height = 23
        Date = 46315.000000000000000000
        Format = 'dd/MM/yyyy'
        Time = 46315.000000000000000000
        TabOrder = 2
      end
      object btnConsultar: TButton
        Left = 562
        Top = 97
        Width = 110
        Height = 28
        Anchors = [akTop, akRight]
        Caption = 'Consultar'
        TabOrder = 3
        OnClick = btnConsultarClick
      end
      object listEventos: TListView
        Left = 16
        Top = 131
        Width = 656
        Height = 302
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'In'#237'cio'
            Width = 125
          end
          item
            Caption = 'T'#233'rmino'
            Width = 125
          end
          item
            Caption = 'T'#237'tulo'
            Width = 170
          end
          item
            Caption = 'Local'
            Width = 110
          end
          item
            Caption = 'Tipo'
            Width = 80
          end>
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 4
        ViewStyle = vsReport
        OnSelectItem = listEventosSelectItem
      end
    end
    object gBoxCompromisso: TGroupBox
      Left = 688
      Top = 0
      Width = 412
      Height = 456
      Align = alRight
      Caption = ' Compromisso '
      Enabled = False
      TabOrder = 1
      DesignSize = (
        412
        456)
      object lbSelecionado: TLabel
        Left = 16
        Top = 23
        Width = 380
        Height = 15
        AutoSize = False
        Caption = 'Novo compromisso'
      end
      object lbTitulo: TLabel
        Left = 16
        Top = 47
        Width = 120
        Height = 15
        AutoSize = False
        Caption = 'T'#237'tulo'
      end
      object lbLocal: TLabel
        Left = 16
        Top = 95
        Width = 100
        Height = 15
        AutoSize = False
        Caption = 'Local'
      end
      object lbInicio: TLabel
        Left = 16
        Top = 144
        Width = 170
        Height = 15
        AutoSize = False
        Caption = 'In'#237'cio'
      end
      object lbFim: TLabel
        Left = 16
        Top = 195
        Width = 200
        Height = 15
        AutoSize = False
        Caption = #218'ltimo dia / t'#233'rmino'
      end
      object lbHorario: TLabel
        Left = 16
        Top = 243
        Width = 380
        Height = 15
        AutoSize = False
        Caption = 'Hor'#225'rios no fuso local do Windows.'
      end
      object lbDescricao: TLabel
        Left = 16
        Top = 265
        Width = 120
        Height = 15
        AutoSize = False
        Caption = 'Descri'#231#227'o'
      end
      object edtTitulo: TEdit
        Left = 16
        Top = 64
        Width = 380
        Height = 23
        TabOrder = 0
      end
      object edtLocal: TEdit
        Left = 16
        Top = 112
        Width = 380
        Height = 23
        TabOrder = 1
      end
      object edtInicio: TDateTimePicker
        Left = 16
        Top = 162
        Width = 140
        Height = 23
        Date = 46315.000000000000000000
        Format = 'dd/MM/yyyy'
        Time = 46315.000000000000000000
        TabOrder = 2
      end
      object edtHoraInicio: TDateTimePicker
        Left = 164
        Top = 162
        Width = 90
        Height = 23
        Date = 46315.000000000000000000
        Format = 'HH:mm'
        Time = 46315.000000000000000000
        DateMode = dmUpDown
        Kind = dtkTime
        TabOrder = 3
      end
      object ckDiaTodo: TCheckBox
        Left = 278
        Top = 164
        Width = 118
        Height = 17
        Caption = 'Dia todo'
        TabOrder = 6
        OnClick = ckDiaTodoClick
      end
      object edtFim: TDateTimePicker
        Left = 16
        Top = 213
        Width = 140
        Height = 23
        Date = 46315.000000000000000000
        Format = 'dd/MM/yyyy'
        Time = 46315.000000000000000000
        TabOrder = 4
      end
      object edtHoraFim: TDateTimePicker
        Left = 164
        Top = 213
        Width = 90
        Height = 23
        Date = 46315.000000000000000000
        Format = 'HH:mm'
        Time = 46315.000000000000000000
        DateMode = dmUpDown
        Kind = dtkTime
        TabOrder = 5
      end
      object mmDescricao: TMemo
        Left = 16
        Top = 284
        Width = 380
        Height = 108
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssVertical
        TabOrder = 7
      end
      object btnNovo: TButton
        Left = 16
        Top = 412
        Width = 65
        Height = 28
        Anchors = [akLeft, akBottom]
        Caption = 'Novo'
        TabOrder = 8
        OnClick = btnNovoClick
      end
      object btnCriar: TButton
        Left = 89
        Top = 412
        Width = 65
        Height = 28
        Anchors = [akLeft, akBottom]
        Caption = 'Criar'
        TabOrder = 9
        OnClick = btnCriarClick
      end
      object btnSalvar: TButton
        Left = 162
        Top = 412
        Width = 151
        Height = 28
        Anchors = [akLeft, akBottom]
        Caption = 'Salvar altera'#231#245'es'
        Enabled = False
        TabOrder = 10
        OnClick = btnSalvarClick
      end
      object btnExcluir: TButton
        Left = 321
        Top = 412
        Width = 75
        Height = 28
        Anchors = [akLeft, akBottom]
        Caption = 'Excluir'
        Enabled = False
        TabOrder = 11
        OnClick = btnExcluirClick
      end
    end
  end
  object gBoxConexao: TGroupBox
    Left = 0
    Top = 0
    Width = 1100
    Height = 150
    Align = alTop
    Caption = ' Conex'#227'o com o Google '
    TabOrder = 0
    DesignSize = (
      1100
      150)
    object lbClientID: TLabel
      Left = 16
      Top = 22
      Width = 120
      Height = 15
      AutoSize = False
      Caption = 'Client ID'
    end
    object lbClientSecret: TLabel
      Left = 16
      Top = 72
      Width = 150
      Height = 15
      AutoSize = False
      Caption = 'Client Secret'
    end
    object lbStatus: TLabel
      Left = 16
      Top = 122
      Width = 340
      Height = 15
      AutoSize = False
      Caption = 'Desconectado'
    end
    object lbCallback: TLabel
      Left = 450
      Top = 122
      Width = 610
      Height = 15
      AutoSize = False
      Caption = 'Callback local: http://127.0.0.1:8000'
    end
    object edtClientID: TEdit
      Left = 16
      Top = 40
      Width = 824
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      TextHint = 'Seu cliente OAuth do tipo Aplicativo para computador'
      OnChange = CredenciaisChange
    end
    object edtClientSecret: TEdit
      Left = 16
      Top = 90
      Width = 824
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      PasswordChar = '*'
      TabOrder = 1
      OnChange = CredenciaisChange
    end
    object btnConectar: TButton
      Left = 860
      Top = 37
      Width = 224
      Height = 28
      Anchors = [akTop, akRight]
      Caption = 'Conectar'
      TabOrder = 2
      OnClick = btnConectarClick
    end
    object btnCancelar: TButton
      Left = 860
      Top = 87
      Width = 132
      Height = 28
      Anchors = [akTop, akRight]
      Caption = 'Cancelar autentica'#231#227'o'
      Enabled = False
      TabOrder = 3
      OnClick = btnCancelarClick
    end
    object btnSair: TButton
      Left = 1000
      Top = 87
      Width = 84
      Height = 28
      Anchors = [akTop, akRight]
      Caption = 'Sair'
      Enabled = False
      TabOrder = 4
      OnClick = btnSairClick
    end
  end
  object gBoxMensagens: TGroupBox
    Left = 0
    Top = 606
    Width = 1100
    Height = 174
    Align = alBottom
    Caption = ' Mensagens '
    TabOrder = 1
    object mmLog: TMemo
      Left = 2
      Top = 17
      Width = 1096
      Height = 155
      Align = alClient
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object CloudGoogleCalendar: TTMSFNCCloudGoogleCalendar
    Left = 778
    Top = 22
    Width = 26
    Height = 26
    Visible = True
    OnAccessDenied = CloudGoogleCalendarAccessDenied
    OnConnected = CloudGoogleCalendarConnected
    OnGetCalendar = CloudGoogleCalendarGetCalendar
    OnAddCalendarItem = CloudGoogleCalendarAddCalendarItem
    OnDeleteCalendarItem = CloudGoogleCalendarDeleteCalendarItem
    OnUpdateCalendarItem = CloudGoogleCalendarUpdateCalendarItem
    Calendars = <>
    Items = <>
  end
end
