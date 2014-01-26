program DianetDialer2;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Metropolis UI Blue');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
