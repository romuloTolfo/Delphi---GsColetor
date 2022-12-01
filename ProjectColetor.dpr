program ProjectColetor;

uses
  System.StartUpCopy,
  FMX.Forms,
  uLogin in 'uLogin.pas' {frmLogin},
  uDm in 'uDm.pas' {dm: TDataModule},
  ws_login in 'ws_login.pas',
  uConfig in 'uConfig.pas' {frmConfig},
  uListView in 'uListView.pas',
  uConsulta in 'uConsulta.pas' {frmConsulta},
  ws_consulta in 'ws_consulta.pas',
  frame.produto in 'frame.produto.pas' {FrameProduto: TFrame},
  uPrincipal in 'uPrincipal.pas' {frmMenu},
  uColetas in 'uColetas.pas' {frmColetas},
  ws_SincProd in 'ws_SincProd.pas',
  uSincronizar in 'uSincronizar.pas' {frmSinc},
  uFuncoesBasicas in 'uFuncoesBasicas.pas',
  uFancyDialog in 'uFancyDialog.pas',
  uLoading in 'uLoading.pas',
  Androidapi.JNI.PowerManager in 'Androidapi.JNI.PowerManager.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmConfig, frmConfig);
  Application.CreateForm(TfrmConsulta, frmConsulta);
  Application.CreateForm(TfrmMenu, frmMenu);
  Application.CreateForm(TfrmColetas, frmColetas);
  Application.CreateForm(TfrmSinc, frmSinc);
  Application.Run;
end.
