unit uMsg;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, System.ImageList,
  FMX.ImgList;

type
  TfrmMsg = class(TForm)
    rctRctTop: TRectangle;
    btnOk: TSpeedButton;
    btnNao: TSpeedButton;
    rctBtn: TRectangle;
    rctBottom: TRectangle;
    btnSim: TSpeedButton;
    rctbot: TRectangle;
    rctMsg: TRectangle;
    MENSAGEM: TLabel;
    lblTituloMSG: TLabel;
    stylbk: TStyleBook;
    imgMessage: TImage;
    imgErro: TImage;
    imgWrng: TImage;
    imgPergunta: TImage;
    imgSucesso: TImage;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNaoClick(Sender: TObject);
    procedure btnSimClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMsg: TfrmMsg;

implementation

{$R *.fmx}

procedure TfrmMsg.btnSimClick(Sender: TObject);
begin
  frmMsg.ModalResult:=mrYes;
  frmMsg.CloseModal;
end;

procedure TfrmMsg.btnNaoClick(Sender: TObject);
begin
  frmMsg.ModalResult:=mrNo;
  frmMsg.CloseModal;
end;

procedure TfrmMsg.btnOkClick(Sender: TObject);
begin
  frmMsg.Tag:=0;
  Close;
end;

procedure TfrmMsg.FormCreate(Sender: TObject);
begin
  imgErro.Visible:=false;
  imgWrng.Visible:=False;
  imgMessage.Visible:=false;
  imgPergunta.Visible:=False;
end;

end.
