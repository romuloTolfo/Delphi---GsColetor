unit uColetas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
    TfrmColetas = class(TForm)
    rctFooter: TRectangle;
    lvTarefas: TListView;
    rctRctTop: TRectangle;
    lblGsSmart: TLabel;
    img_fechar: TImage;
    imgSinc: TImage;
    imgNotSinc: TImage;
  procedure img_fecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
   // procedure FormCreate(Sender: TObject);
  private
   procedure AddTarefas(Tipo, data, fornecedor, controle, sincronizado,
                          status: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmColetas: TfrmColetas;

implementation

{$R *.fmx}
{ TfrmColetas }

procedure TfrmColetas.AddTarefas(Tipo, data, fornecedor, controle,
                                sincronizado, status: string);
var
  item: TListViewItem;
  txt: TListItemText;
  img: TListItemImage;

begin
  try
    item := lvTarefas.Items.Add;

    with item do
    begin
        //controle
      txt := TListItemText(objects.FindDrawable('txtControle'));
      txt.Text := 'Controle: ' + controle;

       // fornecedor
      txt := TListItemText(objects.FindDrawable('txtForn'));
      txt.Text := 'Forn: ' + fornecedor;

      // texto sinc
      txt := TListItemText(objects.FindDrawable('txtSinc'));
      txt.Text := 'Sinc: ';

      //imagem sinc
      img:= TListItemImage(Objects.FindDrawable('imgSinc'));
      if sincronizado = 'S' then
        img.Bitmap := imgSinc.Bitmap
      else
        img.Bitmap := imgNotSinc.Bitmap;

      //  status coletas texto
      txt := TListItemText(objects.FindDrawable('txtStatus'));
      txt.Text := 'Status: ';

      // status coleta imagem
      img:= TListItemImage(Objects.FindDrawable('imgStatus'));
      if status = 'C' then
       img.Bitmap := imgSinc.Bitmap
      else
       img.Bitmap := imgNotSinc.Bitmap;

    end;
    except on ex:Exception do
      ShowMessage('Erro' + ex.Message);
    end;

end;

procedure TfrmColetas.FormCreate(Sender: TObject);
begin
  AddTarefas('01', '22112022', '12516', '121545', 'N', 'C');
  AddTarefas('02', '26265644', '13181', '151515', 'S', 'C');
end;

procedure TfrmColetas.img_fecharClick(Sender: TObject);
begin
  Close;
end;

end.
