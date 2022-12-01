unit uAud;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation, uDm, REST.Json, uPrincipal,
  REST.Types, REST.Client, REST.Authenticator.Basic, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.Edit, System.JSON;

type
  TfrmAud = class(TForm)
    rctRctTop: TRectangle;
    lblGsSmart: TLabel;
    img_voltar: TImage;
    rctFooter: TRectangle;
    lyt: TLayout;
    lyt1: TLayout;
    lbl_cliente: TLabel;
    lyt2: TLayout;
    lbl_produto: TLabel;
    img: TImage;
    lyt3: TLayout;
    img2: TImage;
    lbl_pedido: TLabel;
    btnSinc: TSpeedButton;
    RESTClientProdGeral: TRESTClient;
    RequestProdGeral: TRESTRequest;
    TRestResponseProd: TRESTResponse;
    HTTPBasicAuthenticator1: THTTPBasicAuthenticator;
    edtUnidAud: TEdit;
    procedure img_voltarClick(Sender: TObject);
    procedure btnSincClick(Sender: TObject);
    procedure processaAudConsulta;
   // procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAud: TfrmAud;
  dm: Tdm;

implementation

uses
  ws_SincProd, uConfig, uFuncoesBasicas;

{$R *.fmx}

procedure TfrmAud.btnSincClick(Sender: TObject);
begin
 RequestProdGeral.Params.Clear;
 //RequestProdGeral.AddParameter('gs_usuario', edtUser.Text);
 //RequestProdGeral.AddParameter('gs_senha', edtSenha.Text);
end;

{procedure TfrmAud.FormCreate(Sender: TObject);
var
url, unid : string;
begin
  dm.GetDadosConfig(url, 'cfg_url');
  RESTClientProdGeral.BaseURL := url;
  dm.GetDadosConfig(unid, 'cfg_unid');
  edtUnidAud.text := unid;
end;
             }

procedure TfrmAud.img_voltarClick(Sender: TObject);
begin
  close;
end;

procedure TfrmAud.processaAudConsulta;
 var
  json, retorno: string;

  pr_codInterno:Integer;
  pr_Uni, pr_codBar, pr_gruCod, pr_dptoCod:string;
  pr_est1,pr_est2, pr_est3, pr_est4, pr_est5:Extended;
  pr_vdOnl, pr_precoNormal, pr_prVend, pr_preVen3, pr_fatEst3: Extended;

  pr_descricao, pr_complemento, pr_marca, pr_dptoDes, pr_ativo, pr_bloq,
  pr_gruDesc, pr_oferta:string;

  pr_dataIniOf, pr_dataFinOf, pr_dataPreVen: TDate;

  statusWS: Integer;

  xws_SincProd: ws_SincProd.TRootClass;

  produtos: TProdutosClass;

  Pag,QtdeProd,i : integer;
  TotProd:Integer;
  iCodResp:integer;
  XCodResp:string;

  ListaComandos:TStringList;

  RetQuery:string;
  Comando:string;


begin
    try
      iCodResp:=0;
      xCodResp:='';
      Pag:=0;
      TotProd:=0;

      ListaComandos:=TStringList.Create;

      ListaComandos.Add('delete * from produtos;');

      ExecutaQuery(ListaComandos.Text,RetQuery);

      if RetQuery<>'OK' then
      begin
        ShowMessage(RetQuery);
        Exit;
      end;


      while (iCodResp<>201)  do
      begin
        inc(Pag);
        frmAud.RequestProdGeral.Resource := 'prod_geral';
        frmAud.RequestProdGeral.Params.Clear;
        frmAud.RequestProdGeral.AddParameter('gs_unidade', frmAud.edtUnidAud.Text);
        frmAud.RequestProdGeral.AddParameter('gs_pagina', IntToStr(pag));
        frmAud.RequestProdGeral.Execute;

        json := frmAud.RequestProdGeral.Response.JSONValue.ToString;
        xws_SincProd :=TJson.JsonToObject<ws_SincProd.TRootClass>(json);

        iCodResp:=xws_SincProd.RESULT.RetCodigo;
        xcodResp:=xws_SincProd.RESULT.RetMensagem;

        if XCodResp='NL' then
          Break;

        QtdeProd:=Length(xws_SincProd.RESULT.Produtos);

        ListaComandos.Clear;

        for I := 0 to QtdeProd-1 do
        begin
          inc(TotProd);
          pr_codInterno :=xws_SincProd.RESULT.Produtos[i].gs_codigo;
          pr_codBar := xws_SincProd.RESULT.Produtos[i].gs_CodBarras;
          pr_Uni := xws_SincProd.RESULT.Produtos[i].gs_Unidade;
          pr_descricao  :=xws_SincProd.RESULT.Produtos[i].gs_Descsricao;
          pr_complemento := xws_SincProd.RESULT.Produtos[i].gs_Complemento;
          pr_marca := xws_SincProd.RESULT.Produtos[i].gs_Marca;
          pr_ativo := xws_SincProd.RESULT.Produtos[i].gs_Ativo;
          pr_bloq := xws_SincProd.RESULT.Produtos[i].gs_Bloqueado;
          pr_prVend := xws_SincProd.RESULT.Produtos[i].gs_PrVenda;
          pr_fatEst3 := xws_SincProd.RESULT.Produtos[i].gs_FatorEst3;
          pr_preVen3 := xws_SincProd.RESULT.Produtos[i].gs_PrVenda3;
          pr_gruCod := xws_SincProd.RESULT.Produtos[i].gs_GrupoCodgigo;
          pr_gruDesc := xws_SincProd.RESULT.Produtos[i].gs_GrupoDescricao;
          pr_dptoCod := xws_SincProd.RESULT.Produtos[i].gs_DptoCodigo;
          pr_dptoDes := xws_SincProd.RESULT.Produtos[i].gs_DptoDescricao;
          pr_est1 := xws_SincProd.RESULT.Produtos[i].gs_Estoque1;
          pr_est2 := xws_SincProd.RESULT.Produtos[i].gs_Estoque2;
          pr_est3 := xws_SincProd.RESULT.Produtos[i].gs_Estoque3;
          pr_est4 := xws_SincProd.RESULT.Produtos[i].gs_Estoque4;
          pr_est5 := xws_SincProd.RESULT.Produtos[i].gs_Estoque5;
          pr_vdOnl := xws_SincProd.RESULT.Produtos[i].gs_vdonline;
          pr_oferta := xws_SincProd.RESULT.Produtos[i].gs_Oferta;
          pr_dataIniOf := TextToDate(xws_SincProd.RESULT.Produtos[i].gs_DataIniOF);
          pr_dataFinOf := TextToDate(xws_SincProd.RESULT.Produtos[i].gs_DataFinOf);
          pr_precoNormal := xws_SincProd.RESULT.Produtos[i].gs_PrNormal;
          pr_dataPreVen  := TextToDate(xws_SincProd.RESULT.Produtos[i].gs_DataPrVenda);


          comando := 'insert into produtos('+
                    ' prod_codigo, prod_codbarras, prun_unid_codigo, prod_descricao,'+
                    ' prod_complemento, prod_marca, prun_ativo, prun_bloqueado, '+
                    ' prun_prvenda, prun_fatorpr3, prun_prvenda3, prod_grup_codigo, '+
                    ' prod_grup_nome, prod_dpto_codigo, dpto_descricao, prun_estoque1, '+
                    ' prun_estoque2, prun_estoque3, prun_estoque4, prun_estoque5, '+
                    ' prun_oferta, prun_dtinioferta, prun_dtoferta, prun_prnormal,'+
                    ' prun_dtprvenda) '+
                    ' VALUES ( '+
                    ValorToSql(pr_codInterno,0)+','+QuotedStr(pr_codBar)+','+QuotedStr(pr_Uni)+','+QuotedStr(pr_descricao)+','+

                    DateToStrSql(pr_dataPreVen);
          ListaComandos.Add(Comando);

        end;


        ExecutaQuery(ListaComandos.Text,RetQuery);
       end;

    finally
      FreeAndNil(ListaComandos);
      xws_SincProd.DisposeOf;
      ShowMessage('Total de Produtos Importados: '+IntToStr(TotProd));
    end;

end;

end.
