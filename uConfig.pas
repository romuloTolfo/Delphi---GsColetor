unit uConfig;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, uLogin, uDm, uConsulta,
  uPrincipal;
type
  TfrmConfig = class(TForm)
    rctRctTop: TRectangle;
    lblGsSmart: TLabel;
    rctFooter: TRectangle;
    CircleStatus: TCircle;
    edtUrlServ: TEdit;
    lblUrlServer: TLabel;
    edtUnid: TEdit;
    lblUnid: TLabel;
    btnSave: TSpeedButton;
    img_fechar: TImage;
    SpeedButton1: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure img_fecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfig: TfrmConfig;

implementation

{$R *.fmx}

procedure TfrmConfig.btnSaveClick(Sender: TObject);
var
cm : string;
begin
  cm := 'delete from config;';
  dm.conn.ExecSQL(cm);
  cm := 'insert into config(cfg_unid, cfg_url) VALUES (' +
  QuotedStr(edtUnid.Text) + ',' + QuotedStr(edtUrlServ.Text) + ')';
  dm.conn.ExecSQL(cm);

  ShowMessage('Configuração salva com sucesso.');
  frmConfig.Close;
  frmMenu.Show;
end;

procedure TfrmConfig.FormShow(Sender: TObject);
var
  unid, url : string;

begin
  dm.GetDadosConfig(url, 'cfg_url');
  dm.GetDadosConfig(unid, 'cfg_unid');
  edtUrlServ.Text := url;
  edtUnid.Text := unid;
  edtUrlServ.SetFocus;
end;

procedure TfrmConfig.img_fecharClick(Sender: TObject);
begin
  frmMenu.Show;
  Close;
end;

end.
