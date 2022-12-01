unit frame.produto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects;

type
  TFrameProduto = class(TFrame)
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Rectangle2: TRectangle;
    Layout2: TLayout;
    Label2: TLabel;
    lblCodBar: TLabel;
    Layout3: TLayout;
    Label1: TLabel;
    lblCod: TLabel;
    Layout4: TLayout;
    lblEstoque: TLabel;
    Layout5: TLayout;
    Label6: TLabel;
    lblDescricao: TLabel;
    lyt5: TLayout;
    lbl2: TLabel;
    lblOfeIni: TLabel;
    lbl3: TLabel;
    lblOfeFin: TLabel;
    lblOferta: TLabel;
    lyt6: TLayout;
    lblPreco: TLabel;
    lbl: TLabel;
    lblData: TLabel;
    Label4: TLabel;
    lbl4: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
