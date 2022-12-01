program SmartColetor;

uses
  System.StartUpCopy,
  FMX.Forms,
  frame.produto in 'frame.produto.pas' {FrameProduto: TFrame},
  Androidapi.JNI.PowerManager in 'Androidapi.JNI.PowerManager.pas',
  ws_consulta in 'ws_consulta.pas',
  ws_login in 'ws_login.pas',
  ws_SincProd in 'ws_SincProd.pas',
  uColetas in 'uColetas.pas' {frmColetas},
  uConfig in 'uConfig.pas' {frmConfig},
  uConsulta in 'uConsulta.pas' {frmConsulta},
  uDm in 'uDm.pas' {dm: TDataModule},
  uFancyDialog in 'uFancyDialog.pas',
  uFuncoesBasicas in 'uFuncoesBasicas.pas',
  uListView in 'uListView.pas',
  uLoading in 'uLoading.pas',
  uMsg in 'uMsg.pas' {frmMsg},
  uPrincipal in 'uPrincipal.pas' {frmMenu},
  uSincronizar in 'uSincronizar.pas' {frmSinc},
  uAudt in 'uAudt.pas' {frmAud},
  uLogin in 'uLogin.pas' {frmLogin};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmColetas, frmColetas);
  Application.CreateForm(TfrmConfig, frmConfig);
  Application.CreateForm(TfrmConsulta, frmConsulta);
  Application.CreateForm(TfrmMsg, frmMsg);
  Application.CreateForm(TfrmMenu, frmMenu);
  Application.CreateForm(TfrmSinc, frmSinc);
  Application.CreateForm(TfrmAud, frmAud);
  Application.Run;
end.
