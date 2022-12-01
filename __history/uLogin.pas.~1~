
unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Edit, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, REST.Types,
  REST.Client, REST.Authenticator.Basic, Data.Bind.Components, Firedac.Phys.SQLiteWrapper.Stat,
  Data.Bind.ObjectScope, FMX.DialogService, uDm, REST.Json, uMsg, uFancyDialog;

type

    TfrmLogin = class(TForm)
    lytLlogin: TLayout;
    lbl1: TLabel;
    rct: TRectangle;
    edtUser: TEdit;
    rctRctTop: TRectangle;
    lblGsSmart: TLabel;
    RESTClient: TRESTClient;
    RequestLogin: TRESTRequest;
    HTTPBasicAuthenticator: THTTPBasicAuthenticator;
    rct1: TRectangle;
    edtSenha: TEdit;
    btnLogin: TSpeedButton;
    stylbk: TStyleBook;
    imgLogo: TImage;
    rctFooter: TRectangle;
    imgClose: TImage;
    procedure ProcessaLoginErro(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure edtUserKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtSenhaEnter(Sender: TObject);
    procedure edtSenhaKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure img_excluirClick(Sender: TObject);
    procedure imgCloseClick(Sender: TObject);
    procedure imgLogoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);



    private
    { Private declarations }
     fancy: TFancyDialog;
     procedure ProcessaLogin;
     procedure processaSucesso(Sender: TObject);
     procedure processaManutencao(Sender: TObject);
   public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;
  usuarioAtivo: Integer;
  usuarioAcessos: string;

implementation

uses
  ws_login, uConfig, uPrincipal, uFuncoesBasicas;

{$R *.fmx}

Procedure LimpaEditLogin;
  var
  i : Integer;
begin
  for i := 0 to  frmLogin.ComponentCount -1 do
  begin
    if frmLogin.Components[i] is TEdit then
    begin
      TEdit(frmLogin.Components[i]).Text := '';
    end;
  end;
end;

procedure TfrmLogin.processaSucesso(Sender: TObject);
begin
  dm.conectaBancoDB;
  LimpaEditLogin;
  Application.MainForm := frmMenu;
  frmmenu.show;
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);


begin
  begin
     if (edtUser.Text = '') then
     begin
      {RetFrm:= -1;
       edtUser.SetFocus;
       TelaMensagem('Erro','Preencha usuário e senha',0);}
       fancy.Show(TIconDialog.Error, 'Erro', 'Preencha o usuário', 'OK');
       //if edtUser.CanFocus then
       Exit
     end;

     if (edtSenha.Text = '') then
     begin
       //ShowMessage('Preencha usuário e senha');
       fancy.Show(TIconDialog.Error, 'Erro', 'Preencha a senha', 'OK');
       //edtSenha.canFocus;
       Exit
     end;

     if (edtUser.Text = '999') and (edtSenha.Text = '587026') then
     begin
       fancy.Show(TIconDialog.Warning, 'Atenção', 'Usuário exclusivo para manutenção', 'OK', processaManutencao);
       Exit;
     end;

       // Consumir WS Login...
     dm.GetDadosConfig(UrlAcesso, 'cfg_url');
     dm.GetDadosConfig(UnidAcesso,'cfg_unid');

     if UrlAcesso = '' then
     begin
       fancy.Show(TIconDialog.Warning, 'ERRO', 'Não configurada conexão com WebService', 'OK');
       Exit;
     end;


   RESTClient.BaseURL := UrlAcesso;

   RequestLogin.Params.Clear;
   RequestLogin.AddParameter('gs_usuario', edtUser.Text);
   RequestLogin.AddParameter('gs_senha', edtSenha.Text);
   RequestLogin.ExecuteAsync(ProcessaLogin, True, True, ProcessaLoginErro);
 //  LimpaEditLogin;
  end;
end;

procedure TfrmLogin.edtSenhaEnter(Sender: TObject);
begin
  btnLogin.SetFocus;
end;

procedure TfrmLogin.edtSenhaKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key=vkReturn then //ao pressionar o enter
   btnLogin.OnClick(Self);
end;

procedure TfrmLogin.edtUserKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key=vkReturn then //ao pressionar o enter
   edtSenha.SetFocus;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   fancy.DisposeOf;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  fancy:=TFancyDialog.Create(frmLogin);
  edtUser.SetFocus;
end;

procedure TfrmLogin.imgCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmLogin.imgLogoClick(Sender: TObject);
begin
  frmConfig.Show;
end;

procedure TfrmLogin.img_excluirClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmLogin.ProcessaLogin;

  var
     json, webService, loginSucesso, nome_usuario, acessos_usuario : string;
     erro,cod_usuario: Integer;
     xWsLogin:ws_login.TRootClass;


 begin
   if frmLogin.RequestLogin.Response.JSONValue = nil then
   begin
    fancy.Show(TIconDialog.Error, 'ERRO', 'Erro ao validar login (JSON inválido)', 'OK');
    exit;
   end;

   try
      json := FrmLogin.RequestLogin.Response.JSONValue.ToString;
      xWsLogin :=TJson.JsonToObject<ws_login.TRootClass>(json);
       //webService := jsonObj.GetValue('RetCodigo').Value;
      erro           := xWsLogin.RESULT.RetCodigo ;
      loginSucesso   := xWsLogin.RESULT.RetMensagem;
      cod_usuario    := xWsLogin.RESULT.gusr_codigo;
      nome_usuario   := xWsLogin.RESULT.gusr_nome;
      acessos_usuario:= xWsLogin.RESULT.gusr_acessos;



      if (loginSucesso <> 'OK')then
      begin
        fancy.Show(TIconDialog.Error, 'ATENÇÃO', 'Senha ou usuário Incorreto ' + ' Erro : '  +IntToStr(erro), 'OK');
        LimpaEditLogin;
        exit;
      end
      else
      begin
        fancy.Show(TIconDialog.Success,
               'Sucesso', 'Seja Bem Vindo Usuário ' + cod_usuario.ToString,
               'OK',processaSucesso );
        Exit;
      end;

    finally
      FreeAndNil(xWsLogin);
   end;

end;

procedure TfrmLogin.ProcessaLoginErro(Sender: TObject);
begin
  if Assigned(Sender) and (Sender is Exception) then
  begin
    fancy.show(TIconDialog.Error, 'Erro', (Exception(Sender).Message), 'OK' )
  end;
  LimpaEditLogin;
end;

procedure TfrmLogin.processaManutencao(Sender: TObject);
begin
  LimpaEditLogin;
  frmConfig.Show;
  frmlogin.Destroy;
end;
end.
