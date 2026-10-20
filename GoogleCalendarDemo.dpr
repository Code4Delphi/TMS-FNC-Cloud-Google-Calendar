program GoogleCalendarDemo;

uses
  Vcl.Forms,
  GoogleCalendar.Main in 'Src\GoogleCalendar.Main.pas' {GoogleCalendarMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Google Calendar - TMS FNC Cloud Pack';
  Application.CreateForm(TGoogleCalendarMain, GoogleCalendarMain);
  Application.Run;
end.
