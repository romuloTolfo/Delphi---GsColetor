unit UPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView, uFancyDialog;

type
  TfrmMenu = class(TForm)
    lvmenu: TListView;
    rctRctTop: TRectangle;
    lblGsSmart: TLabel;
    imgLogo: TImage;
    rctFooter: TRectangle;
    imgMenu1: TImage;
    imgMenu2: TImage;
    imgMenu3: TImage;
    imgMenu4: TImage;
    imgLogin: TImage;
    imgClose: TImage;
    procedure FormShow(Sender: TObject);
    procedure lvmenuItemClick(const Sender: TObject;
                        const AItem: TListViewItem);
    procedure imgCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
     { Private declarations }
    fancy: TFancyDialog;
    procedure ListarDados;
  public
    { Public declarations }
  end;

  var
  frmMenu: TfrmMenu;

implementation

uses
  uListview, uLogin, uConsulta, uColetas, uSincronizar, uAudt;

{$R *.fmx}

procedure TfrmMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   fancy.DisposeOf;
end;

procedure TfrmMenu.FormCreate(Sender: TObject);
begin
  fancy:=TFancyDialog.Create(frmMenu);
end;

procedure TfrmMenu.FormShow(Sender: TObject);
  var
  cod_usuario : Integer;
begin
  ListarDados;
end;

procedure TfrmMenu.imgCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMenu.ListarDados;
// associa listagem de dados
begin
    //TMyListview.AddItem(lvMenu, '001', 'LOGIN', imgLogin.Bitmap);
    TMyListview.LimpaLista(lvmenu);
    TMyListview.AddItem(lvMenu, '002', 'COLETAS', imgMenu1.Bitmap);
    TMyListview.AddItem(lvMenu, '003', 'CONSULTA PRODUTOS', imgMenu3.Bitmap);
    TMyListview.AddItem(lvMenu, '004', 'SINCRONIZAR', imgMenu4.Bitmap);
    //TMyListview.AddItem(lvMenu, '005', 'AUDITORIA', imgMenu2.Bitmap);
end;

procedure TfrmMenu.lvmenuItemClick(const Sender: TObject;
const AItem: TListViewItem);
  //associa menu item ao devido next.form
begin
  //if lvmenu.Items[lvmenu.ItemIndex].TagString= '001' then
    //frmLogin.Show;
  if lvmenu.Items[lvmenu.ItemIndex].TagString= '002' then
    frmColetas.Show;
  if lvmenu.Items[lvmenu.ItemIndex].TagString= '003' then
    frmConsulta.Show;
  if lvmenu.Items[lvmenu.ItemIndex].TagString= '004' then
    frmSinc.Show;
 // if lvmenu.Items[lvmenu.ItemIndex].TagString= '005' then
   // frmAud.Show;
end;


end.
