unit uSincronizar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, REST.Types, REST.Client,
  REST.Authenticator.Basic, Data.Bind.Components, Data.Bind.ObjectScope,
  FMX.Layouts, uDm, ws_SincProd, uFuncoesBasicas, System.Json, REST.Json,
  REST.Json.Types, uConfig, uFancyDialog, uLoading, FMX.VirtualKeyboard,
  FMX.platform, Androidapi.JNI.PowerManager;


type
  TfrmSinc = class(TForm)
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
    lbl_dwnProd: TLabel;
    edtUnidUrl: TEdit;
    btnSinc: TSpeedButton;
    stylbk: TStyleBook;
    btnDwnProd: TSpeedButton;
    lblNome: TLabel;
    lblEnv: TLabel;
    procedure FormShow(Sender: TObject);
    procedure img_voltarClick(Sender: TObject);
    procedure btnDwnProdClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    var
    processando : Boolean;
    fancy : TFancyDialog;
    procedure downloadProdutos;
    procedure ThreadTerminate(Sender: TObject);
   { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSinc: TfrmSinc;

implementation


  {$IFDEF IOS}
  iOSAPI.UIKit
  {$ENDIF}

  {$R *.fmx}

procedure TfrmSinc.btnDwnProdClick(Sender: TObject);

 var
  t: tthread;
  totprod: Integer;
begin
   if processando then Exit;

   processando:=true;

    TLoading.Show(Frmsinc, 'Obtendo dados...');

    t := TThread.CreateAnonymousThread(procedure
  begin
      sleep(1000);
       TThread.Synchronize(nil, procedure
      begin
          TLoading.ChangeText('Download produtos...');
      end);

      DownloadProdutos;

  end);
   t.Start;
   t.FreeOnTerminate:=false;
   t.OnTerminate := ThreadTerminate;
end;

procedure tfrmSinc.downloadProdutos;

  var
  json, retorno, erro: string;

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

  Pag,QtdeProd : integer;
  TotProd:Integer;
  iCodResp:integer;
  XCodResp:string;

  ListaComandos:TStringList;

  RetQuery:string;
  Comando:string;
  thread: TThread;
  i:integer;
  t:TThread;

 begin
    if erro <> '' then
    begin
      raise Exception.Create(erro);
      exit;
    end;

    try
      iCodResp:=0;
      xCodResp:='';
      Pag:=0;
      TotProd:=0;

      ListaComandos:=TStringList.Create;
      ListaComandos.Clear;
      ListaComandos.Add('delete from produtos;');

      ExecutaQuery(ListaComandos.Text, RetQuery);
      if RetQuery<>'OK' then
      begin
        ShowMessage(RetQuery + 'ok');
        Exit;
      end;

      while (iCodResp<>201)  do
      begin
        ListaComandos.Clear;
        inc(Pag);
        RequestProdGeral.Params.Clear;
        frmSinc.RequestProdGeral.AddParameter('gs_unidade', frmSinc.edtUnidAud.Text);
        frmSinc.RequestProdGeral.AddParameter('gs_pagina', IntToStr(pag));

        Sleep(0001);
        TThread.Current.Synchronize(nil, procedure
        begin
          lbl_dwnProd.Text:=IntToStr(TotProd);
        end);

        begin
          frmSinc.RequestProdGeral.Execute;
          json := frmSinc.RequestProdGeral.Response.JSONValue.ToString;
          xws_SincProd:= TJson.JsonToObject<ws_SincProd.TRootClass>(json);

          iCodResp:=xws_SincProd.RESULT.RetCodigo;
          xcodResp:=xws_SincProd.RESULT.RetMensagem;

          if XCodResp='NL' then
          begin
            xws_SincProd.DisposeOf;
            Exit;
          end

          else

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
        end
       end;
     finally
      FreeAndNil(ListaComandos);
      xws_SincProd.DisposeOf;
      processando:=false;
    end;
 end;

 procedure TfrmSinc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fancy.DisposeOf;
  TelaLigada(False);
end;

procedure TfrmSinc.FormDestroy(Sender: TObject);
begin
  fancy.DisposeOf;
end;

procedure TfrmSinc.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  {$IFDEF ANDROID}
  var
          FService : IFMXVirtualKeyboardService;
  {$ENDIF}

begin
        {$IFDEF ANDROID}
        if (Key = vkHardwareBack) then
        begin
          TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));

          if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
          begin
                  // Botao back pressionado e teclado visivel...
                  // (apenas fecha o teclado)
          end
          else
          begin
                  // Botao back pressionado e teclado NAO visivel...
                  Key := 0;
          end;
        end;
        {$ENDIF}
end;
end;

  procedure tfrmSinc.FormShow(Sender: TObject);
  var
  urlAcesso, unidAcesso : string;
begin
  fancy:=TFancyDialog.Create(frmSinc);
  TelaLigada(true);
  processando:=False;
  dm.GetDadosConfig(urlAcesso, 'cfg_url');
  dm.GetDadosConfig(unidAcesso, 'cfg_unid');
  edtUnidAud.text := unidAcesso;
  edtUnidUrl.Text := UrlAcesso;
  frmSinc.RESTClientProdGeral.BaseURL := UrlAcesso;
 end;

procedure tfrmSinc.img_voltarClick(Sender: TObject);
begin
  if processando then
  begin
    Exit;
  end
  else
  begin
    close;
  end;
end;

procedure TfrmSinc.ThreadTerminate(Sender: TObject);

var
    erro : string;
    TotProd: Integer;
begin
  if Assigned(TThread(Sender).FatalException) then
  begin
    fancy.Show(TIconDialog.Error, 'Erro na sincronização', Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;
  tloading.Hide;
  fancy.Show(TIconDialog.Success, 'Sucesso', 'Sincronização concluída', 'OK');
  processando:=false;
end;
end.
