unit uAudt;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, REST.Types, REST.Client,
  REST.Authenticator.Basic, Data.Bind.Components, Data.Bind.ObjectScope,
  FMX.Layouts, uDm, ws_SincProd, uFuncoesBasicas, System.Json, REST.Json,
  REST.Json.Types, uConfig;

type
  TfrmAud = class(TForm)
    rctFooter: TRectangle;
    edtUnidAud: TEdit;
    rctRctTop: TRectangle;
    lblGsSmart: TLabel;
    img_voltar: TImage;
    RequestProdGeral: TRESTRequest;
    RESTClientProdGeral: TRESTClient;
    HTTPBasicAuthenticator1: THTTPBasicAuthenticator;
    lyt: TLayout;
    lyt1: TLayout;
    lbl_cliente: TLabel;
    lyt2: TLayout;
    lbl_produto: TLabel;
    img: TImage;
    lyt3: TLayout;
    img2: TImage;
    lbl_pedido: TLabel;
    edtUnidUrl: TEdit;
    btnSinc: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure img_voltarClick(Sender: TObject);
    procedure btnSincClick(Sender: TObject);
  private
   { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAud: TfrmAud;

implementation

{$R *.fmx}


procedure TfrmAud.btnSincClick(Sender: TObject);
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
      Pag:=98;
      TotProd:=0;

      ListaComandos:=TStringList.Create;
      ListaComandos.Clear;
      ListaComandos.Add('delete from produtos;');

      ExecutaQuery (ListaComandos.Text, RetQuery);

      {if RetQuery<>'OK' then
      begin
        ShowMessage(RetQuery + 'not ok');
        Exit;
      end;  }


      while (iCodResp<>201)  do
      begin
        ListaComandos.Clear;
        inc(Pag);
        lbl_pedido.Text:=IntToStr(Pag);
        Application.ProcessMessages;

        RequestProdGeral.Params.Clear;
        frmAud.RequestProdGeral.AddParameter('gs_unidade', frmAud.edtUnidAud.Text);
        frmAud.RequestProdGeral.AddParameter('gs_pagina', IntToStr(pag));

        try
          frmAud.RequestProdGeral.Execute;

        except
          on e:exception do
            CopyToClipBoard(e.Message);

        end;

        try
          json := frmAud.RequestProdGeral.Response.JSONValue.ToString;
        except
          on e:exception do
            CopyToClipBoard(frmAud.RequestProdGeral.Response.JSONValue.ToString);

        end;

        xws_SincProd:= TJson.JsonToObject<ws_SincProd.TRootClass>(json);

        iCodResp:=xws_SincProd.RESULT.RetCodigo;
        xcodResp:=xws_SincProd.RESULT.RetMensagem;

        if XCodResp='NL' then
          Break;

        QtdeProd:=Length(xws_SincProd.RESULT.Produtos);


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
                    ' prun_dtprvenda) VALUES ( '
                    +ValorToSql(pr_codInterno,0)+','+QuotedStr(pr_codBar)+','
                    +QuotedStr(pr_Uni)+','+QuotedStr(pr_descricao)+','
                    +QuotedStr(pr_complemento)+',' +QuotedStr(pr_marca)+','
                    +QuotedStr(pr_ativo)+',' +QuotedStr(pr_bloq)+',' + ValorToSql(pr_prVend,0)+','
                    +ValorToSql(pr_fatEst3,0)+',' +ValorToSql(pr_preVen3,0)+',' + QuotedStr(pr_gruCod)+','
                    +QuotedStr(pr_gruDesc)+',' +QuotedStr(pr_dptoCod)+',' +QuotedStr(pr_dptoDes)+','
                    +ValorToSql(pr_est1,0)+',' +ValorToSql(pr_est2,0)+',' +ValorToSql(pr_est3,0)+','
                    +ValorToSql(pr_est4,0)+',' +ValorToSql(pr_est5,0)+',' +QuotedStr(pr_oferta)+','
                    +DateToStrSql(pr_dataPreVen)+',' +DateToStrSql(pr_dataIniOf)+',' +DateToStrSql(pr_dataFinOf)+','
                    +ValorToSql(pr_precoNormal) + ');';

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

procedure TfrmAud.FormShow(Sender: TObject);
  var
  urlAcesso, unidAcesso : string;
begin
  begin
    dm.GetDadosConfig(urlAcesso, 'cfg_url');
    dm.GetDadosConfig(unidAcesso, 'cfg_unid');
    edtUnidAud.text := unidAcesso;
    edtUnidUrl.Text := UrlAcesso;
    frmAud.RESTClientProdGeral.BaseURL := UrlAcesso;
  end;
end;

procedure TfrmAud.img_voltarClick(Sender: TObject);
begin
  close;
end;
end.
