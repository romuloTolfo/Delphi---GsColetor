unit uConsulta;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Edit, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls,
  REST.Json, REST.Types, REST.Client, REST.Authenticator.Basic,
  Data.Bind.Components, Data.Bind.ObjectScope, System.JSON, uDm, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  FMX.Layouts, System.Generics.Collections, frame.produto;

type
  TfrmConsulta = class(TForm)
    rctFooter: TRectangle;
    CircleStatus: TCircle;
    lblCodBarras: TLabel;
    edtCodBar: TEdit;
    lvConsulta: TListView;
    btnConsulta: TButton;
    rctTop: TRectangle;
    RESTClient1: TRESTClient;
    RequestProd: TRESTRequest;
    TRestResponseProd: TRESTResponse;
    HTTPBasicAuthenticator1: THTTPBasicAuthenticator;
    edtUnidCons: TEdit;
    bndngslst: TBindingsList;
    VertScrollBox1: TVertScrollBox;
    rctRctTop: TRectangle;
    lblGsSmart: TLabel;
    img_fechar: TImage;
    procedure btnConsultaClick(Sender: TObject);
  //procedure consultaProd(descricao, codInt, precoVenda, ultAltPreco : string);
    procedure ProcessaConsultaErro(Sender: TObject);
    procedure edtCodBarKeyDown(Sender: TObject; var Key: Word;var KeyChar: Char; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure edtCodBarTyping(Sender: TObject);
    procedure img_fecharClick(Sender: TObject);
    private
      FListaFrame: TList<TFrameProduto>;
    //procedure processaConsulta(descricao, codInt, precoVenda,ultAltPreco: string);

    procedure ConsultarProduto;
    procedure processaWsConsulta;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConsulta: TfrmConsulta;

implementation

uses
  ws_consulta, uConfig, uPrincipal, uFuncoesBasicas;
{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}

{ TfrmConsulta }

procedure TfrmConsulta.processaWsConsulta;
var
  json, webService, descricaoProd, ultAlteracao, consultaSucesso, estoqueProd : string;
  //estoqueProd : Extended;
  codInterno:Integer ;
  erro: Integer;
  xWsconsulta: ws_consulta.TRootClass;
  descricao, codInt, precoVenda, ultAltPreco,oferta : string;
  //txt: TListItemText;
  //item: TListViewItem;
  Ljo, LJson: TJSONObject;
  Lja: TJSONArray;
  LFrame: TFrameProduto;
  I: Integer;

begin
    try
        begin
        if frmConsulta.RequestProd.Response.JSONValue = nil then
       begin
        ShowMessage('Erro ao validar consulta (Cod. Barras inválido)');
        exit;
       end

       else

       json := frmConsulta.RequestProd.Response.JSONValue.ToString;
      //xWsconsulta :=TJson.JsonToObject<ws_consulta.TRootClass>(json);

        Ljo := TJSONObject.ParseJSONValue(json) as TJSONObject;
        LJson :=  Ljo.GetValue<TJSonOBject>('RESULT');


        //CopyToClipBoard(LJson.ToString);

        if LJson.GetValue<string>('RetMensagem') = 'NL' then
        begin
          ShowMessage('Produto não encontrado');
          edtCodBar.Text := '';
          edtCodBar.SetFocus;
          exit;
        end

      else
          TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          if Assigned(FListaFrame) then
          begin
            for var i := 0 to Pred(FListaFrame.Count) do
            FListaFrame.Items[i].Free;
            FListaFrame.Free;
          end;
          FListaFrame := TList<TFrameProduto>.create;
        end);

        TThread.Synchronize(TThread.CurrentThread,
          procedure
          begin
            VertScrollBox1.BeginUpdate;
          end);

        LFrame := TFrameProduto.Create(self);
        LFrame.Align := TAlignLayout.Top;
        LFrame.Name := 'Frame' + FListaFrame.Count.ToString + FormatDateTime('ddmmyyyyhhmmsszzz', now);
        LFrame.lblCodBar.Text := LJson.getValue<string>('gs_CodBarras');
        LFrame.lblCod.Text := LJson.getValue<string>('gs_codigo');
        LFrame.lblEstoque.Text := LJson.getValue<string>('gs_Estoque1');
        LFrame.lblDescricao.Text := LJson.getValue<string>('gs_Descsricao');
        LFrame.lblPreco.Text := 'R$ ' + LJson.getValue<string>('gs_PrVenda');
        LFrame.lbldata.Text := LJson.getValue<string>('gs_DataPrVenda');
        LFrame.lblOferta.Text := LJson.getValue<string>('gs_Oferta');
        LFrame.Tag := LJson.GetValue<integer>('gs_codigo');

        LFrame.lblOfeIni.Text := LJson.getValue<string>('gs_DataIniOF');
        LFrame.lblOfeFin.Text := LJson.getValue<string>('gs_DataFinOf');

        FListaFrame.Add(LFrame);
        VertScrollBox1.AddObject(LFrame);

        TThread.Synchronize(TThread.CurrentThread,
        procedure
          begin
            VertScrollBox1.EndUpdate;
          end);


        CopyToClipBoard(LJson.ToString);

        if LJson.GetValue<string>('gs_Oferta') = 'S' then
        begin
          LFrame.lblPreco.FontColor := $FFE03333;
//          LFrame.lblOfeIni.Text := LJson.getValue<string>('gs_DataIniOF');
//          LFrame.lblOfeFin.Text := LJson.getValue<string>('gs_DataFinOf');
        end else
        begin
          LFrame.lblOfeIni.Visible := false;
          LFrame.lblOfeFin.Visible := false;
        end;



      {consultaSucesso := LJson.getValue<string>('RetMensagem'); //xWsconsulta.RESULT.RetMensagem;
      descricaoProd   := LJson.getValue<string>('gs_Descsricao'); //xWsconsulta.RESULT.gs_Descsricao;
      estoqueProd     := LJson.getValue<string>('gs_Estoque1'); //xWsconsulta.RESULT.gs_Estoque1;
      codInterno      := LJson.getValue<integer>('gs_codigo'); //xWsconsulta.RESULT.gs_codigo;
      precoVenda      := LJson.getValue<string>('gs_PrVenda'); //xWsconsulta.RESULT.gs_PrVenda;
      ultAlteracao    := LJson.getValue<string>('gs_DataPrVenda'); //xWsconsulta.RESULT.gs_DataPrVenda;}

      {  if (consultaSucesso <> 'OK')then
        begin
          ShowMessage('Erro: '+IntToStr(erro));
          exit;
        end
      else
       begin
          ShowMessage('retornou com sucesso' + descricaoProd);
        end; }

      end;
      finally
      FreeAndNil(xWsconsulta);
      Ljo.DisposeOf;
    end;
    end;


    {   item :=  TfrmConsulta.lvConsulta.items.Add;

     with item do
     begin

      txt :=  TListItemText(Objects.FindDrawable('txtDescricao'));
      txt.Text := descricao;

      txt :=  TListItemText(Objects.FindDrawable('txtCodInt'));
      txt.Text := codInt;

      txt :=  TListItemText(Objects.FindDrawable('textoPrecoVen'));
      txt.Text := precoVenda;

      txt :=  TListItemText(Objects.FindDrawable('txtUltAlteraco'));
      txt.Text := ultAltPreco;
      end

  except on ex:exception do
    ShowMessage('Erro ao buscar item' + ex.Message);
  end;
     }

procedure TfrmConsulta.ConsultarProduto;
  var
  url : string;
begin
    dm.GetDadosConfig(url, 'cfg_url');

   if url = '' then
   begin
     ShowMessage('Não configurada conexão com WebService');
     Exit;
   end;

   RESTClient1.BaseURL := url;
   RequestProd.Params.Clear;
   RequestProd.AddParameter('gs_CodBarras', edtCodBar.Text);
   RequestProd.AddParameter('gs_Unidade', edtUnidCons.Text);
   RequestProd.ExecuteAsync(processaWsConsulta, True, True, processaConsultaErro);
   edtCodBar.Text := '';
   edtCodBar.SetFocus;
end;

procedure TfrmConsulta.edtCodBarKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key=vkReturn then //ao pressionar o enter
    processaWsConsulta;
end;

procedure TfrmConsulta.edtCodBarTyping(Sender: TObject);
  begin
     if (Length(edtCodBar.Text)>12) then
     begin
     ConsultarProduto;
     end;
   end;


procedure TfrmConsulta.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FListaFrame.DisposeOf;
end;


procedure TfrmConsulta.FormShow(Sender: TObject);
  var
 unid : string;
begin
   dm.GetDadosConfig(unid, 'cfg_unid');
   edtUnidCons.Text := unid;
   edtCodBar.SetFocus;
end;

procedure TfrmConsulta.img_fecharClick(Sender: TObject);
begin
  Close;
  frmMenu.Show;
end;

procedure TfrmConsulta.ProcessaConsultaErro(Sender: TObject);
 begin
  if Assigned(Sender) and (Sender is Exception) then
  begin
    showmessage(Exception(Sender).Message);
  end;
  end;

procedure TfrmConsulta.btnConsultaClick(Sender: TObject);
begin
  processaWsConsulta;
end;
end.
