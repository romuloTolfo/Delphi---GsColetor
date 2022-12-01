unit uFuncoesBasicas;


interface
uses
  uDm,FireDAC.Comp.DataSet,FireDAC.Comp.Client,System.SysUtils, FMX.Clipboard,
  FMX.Platform, Fmx.dialogs, Fmx.forms, System.UITypes, system.classes,
  Androidapi.JNI.PowerManager;


var User_Codigo:Integer;
    User_Acessos:string;
    UrlAcesso   :string;
    UnidAcesso  :string;

    RetFrm :integer;

const
    ChavesA=#123;
    ChavesF=#125;



procedure CopyToClipBoard(const s:String);
procedure ExecutaQuery(ComandoSql:string;var Ret:String);
function Numero(Str:String):String;
function LeftStr(const s:string;const p:integer):string;
function RightStr(const s:string;const p:integer):string;
function StrZero2(Valor: String;tam:Integer):String;
function Inteiro(const S:String):Int64;
function If_v(const cond:boolean;const v1,v2:variant):variant;
function If_s(const cond:boolean;const v1,v2:string):string;
function If_i(const cond:boolean;const v1,v2:integer):integer;
function If_r(const cond:boolean;const v1,v2:real):real;
function If_b(const cond:boolean;const v1,v2:boolean):boolean;
function If_c(const cond:boolean;const v1,v2:currency):currency;
function GetDigito(n,tp:string):string;
function SubStr(const Str:String;const i,n:integer):String;
function TextToValor(Text:string):Extended;
function LocalizaCampoSQL(Tabela,Campo1,Campo2,Valor1,Valor2,CampoRetorno:String;var Retorno:string ):Boolean;
function LocalizaCodBarras(CodEan:String;var Fator:Extended;DigBal,QtdeDigBal:Integer;AdicionarVerificador:boolean):Integer;
function ValorToSql(Vl:Extended; Dec:Integer = 0):String;
function DateToJson(Date:TDate):string;
function TextToDate(Text:string):TDate;
function DateToStrSql(const Dt:TDateTime):String;
procedure TelaLigada(ligado : Boolean);
//procedure TelaMensagem(Titulo,Mensagem:string;tipo:Integer);


implementation

uses
  uMsg;

procedure CopyToClipBoard(const s:String);
  var
  uClipBoard : IFMXClipboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, uClipBoard)then
    uClipBoard.SetClipboard(s);
end;

procedure ExecutaQuery(ComandoSql:string;var Ret:String);
var QExec:TFDQuery;
begin
  QExec:=TFDQuery.Create(nil);
  QExec.Connection:=dm.conn;

  Ret:='OK';

  try
    QExec.SQL.Text:=ComandoSql;

    TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
        QExec.ExecSQL;
        end);
  except

    on e:Exception do
    begin
      ret:=e.Message;
      CopyToClipBoard(ComandoSql);
    end;
  end;

  FreeAndNil(QExec);
end;




function Numero(Str:String):String;
Var Aux:Integer;
    Aux2:String;
begin
  Aux2:='';
  for Aux:=1 to length (Str) do
    if Str[Aux] in ['0'..'9'] then
      Aux2:=Aux2+Str[Aux];
  Result:=(Aux2);
end;

function LeftStr(const s:string;const p:integer):string;
var i:Integer;
    ss:string;
begin
  ss:='';
  if s<>'' then begin
     for i:=1 to p do
         if i<=Length(s) then ss:=ss+s[i];
  end;
  Result:=ss;
end;

function RightStr(const s:string;const p:integer):string;
var i:integer;
    ss:string;
begin
  ss:='';
  if s<>'' then begin
     for i:=Length(s)-p+1 to Length(s) do
      ss:=ss+s[i];
  end;
  Result:=ss;
end;


function StrZero2(Valor: String;tam:Integer):String;
begin
  while length(Valor)<tam do
    valor:='0'+Valor;
  if Length(Valor)>tam then valor:=LeftStr(valor,tam);
  result:=Valor;
end;

function Inteiro(const S:String):Int64;
var c:integer;
    ss:String;
begin
  Result:=0;
  ss:='';
  if S<>'' then begin
     for c:=1 to Length(s) do begin
         if s[c]='.' then Break;
         if (s[c]='-') and (ss='') then ss:=ss+s[c];
         if s[c] in ['0'..'9'] then ss:=ss+s[c];
     end;
     try
       if ss<>'' then Result:=StrToInt64(ss);
     except
     end;
  end;
end;

function If_v(const cond:boolean;const v1,v2:variant):variant;
begin
  if cond then result:=v1 else result:=v2;
end;

function If_s(const cond:boolean;const v1,v2:string):string;
begin
  if cond then result:=v1 else result:=v2;
end;

function If_i(const cond:boolean;const v1,v2:integer):integer;
begin
  if cond then result:=v1 else result:=v2;
end;

function If_r(const cond:boolean;const v1,v2:real):real;
begin
  if cond then result:=v1 else result:=v2;
end;

function If_b(const cond:boolean;const v1,v2:boolean):boolean;
begin
  if cond then result:=v1 else result:=v2;
end;

function If_c(const cond:boolean;const v1,v2:currency):currency;
begin
  if cond then result:=v1 else result:=v2;
end;

function GetDigito(n,tp:string):string;
var h,t,dig,d:integer;
    r,tt,t1,t2,d1,d2:real;
    dd1,dd2:string;
begin
  if tp='MOD' then begin
     {modulo 11}
     t:=0;h:=9;
     for dig:=Length(n) downto 1 do begin
        t:=t+(Inteiro(Copy(n,dig,1))*h);
         h:=If_i(h<2,9,h-1);
     end;
     d:=t mod 11;
     d:=If_i(d=10,0,d);
     result:=IntToStr(d);
  end
  else if tp='EAN' then begin
     {Ean8 e Ean13}
      h:=2;tt:=0;
      while h<=12 do begin
        tt:=tt+Inteiro(Copy(n,h,1));
        Inc(h,2);
      end;
      tt:=tt*3;h:=1;
      while h<=11 do begin
        tt:=tt+Inteiro(Copy(n,h,1));
        Inc(h,2);
      end;
      r:=((Int(tt/10)*10)+10)-tt;
      result:=RightStr(FloatToStr(r),1);
  end
  else if tp='CPF' then begin
      {cpf}
      t1:=0;h:=9;
      for dig:=1 to 9 do begin
          dec(h);
          t1:=t1+(Inteiro(Copy(n,dig,1))*h);
      end;
      t1:=t1*10;
      t2:=INT(t1/11);
      d1:=t1-(t2*11);
      dd1:=FloatToStr(If_r(d1=10,0,d1));
      n:=n+dd1;
      h:=12;
      t1:=0;
      for dig:=1 to 10 do begin
          dec(h);
          t1:=t1+(Inteiro(Copy(n,dig,1))*h);
      end;
      t1:=t1*10;
      t2:=INT(t1/11);
      d2:=t1-(t2*11);
      dd2:=FloatToStr(If_r(d2=10,0,d2));
      result:=dd1+dd2;
  end;
end;

function SubStr(const Str:String;const i,n:integer):String;
begin
  Result:='';
  if Length(Str)>=(i+n-1) then
    Result:=Copy(Str,i,n);
end;

function TextToValor(Text:string):Extended;
var p,e:integer;
    Texto:string;
    Ponto:Boolean;
begin
  Ponto:=False;
  Texto:='';
  repeat
    p:=Pos(',',Text);
    if p>0 then Text[p]:='.';
  until p=0;
  for e:=Length(Text) downto 1 do begin
      if (Text[e]='.') and (not Ponto) then begin
         Texto:='.'+Texto;
         Ponto:=True;
      end else if Text[e] in ['0'..'9','-'] then begin
         Texto:=Text[e]+Texto;
      end;
  end;
  if Texto='' then Texto:='0';
  try
    Val(Texto,Result,e);
  except
    Result:=0;
  end;
end;


function LocalizaCampoSQL(Tabela,Campo1,Campo2,Valor1,Valor2,CampoRetorno:String;var Retorno:string ):Boolean;
var cm:String;
   Query:TFDQuery;

begin

  Query:=TFDQuery.Create(nil);
  Query.Connection:=dm.conn;


  cm:='select '+CampoRetorno+ ' from '+Tabela+
    ' where '+Campo1+' = '+QuotedStr(Valor1)+
    If_s(Campo2<>'', ' and '+Campo2+' ='+QuotedStr(Valor2),'');

  Query.SQL.Text:=cm;

  Result:=True;
  try
    Query.Open;
  except
    on e:Exception do
    begin
      Retorno:=e.Message;
      Result:=False;
    end;
  end;

  if (not Query.IsEmpty) and (Result=true)then
    Retorno:=Query.FieldByName(CampoRetorno).AsString;

  FreeAndNil(Query);
end;

function LocalizaCodBarras(CodEan:String;var Fator:Extended;DigBal,QtdeDigBal:Integer;AdicionarVerificador:boolean):Integer;
var aCod:integer;
    cPesquisa:String;
    Ret:string;

begin
  Result:=0;
  CodEan:=Numero(CodEan);
  aCod:=0;

  if (LeftStr(CodEan,1)=IntToStr(DigBal)) and (Length(CodEan)=13) then
    CodEan:=SubStr(CodEan,2,QtdeDigBal);


  if (Length(CodEan)<7) and (AdicionarVerificador) then
  begin
    CodEan:=StrZero2(CodEan,12);
    CodEan:=CodEan+GetDigito(CodEan,'EAN');
  end else
    if Length(CodEan)<13 then
      CodEan:=StrZero2(CodEan,13);

  cPesquisa:=CodEan;

  Fator:=1;

  if LocalizaCampoSQL('produtos','prod_codbarras','',cPesquisa,'','prod_codigo',ret) then
    aCod:=Inteiro(Ret);

  if aCod>0 then
  begin
    Result:=aCod;
    exit;
  end;

  if aCod=0 then
  begin

    if LocalizaCampoSQL('cbalt','cbal_prod_codbarras','',cPesquisa,'','cbal_prod_codigo',ret) then
      aCod:=Inteiro(Ret);

    if aCod>0 then
    begin
      if LocalizaCampoSQL('cbalt','cbal_prod_codbarras','',cPesquisa,'','cbal_fatoremb',ret) then
        Fator:=TextToValor(ret);

      if Fator=0 then
        Fator:=1;

      Result:=aCod;
      exit;
    end;

  end;

  if aCod=0 then
  begin
    cPesquisa:=StrZero2(numero(CodEan),14);

    if LocalizaCampoSQL('produtos','prod_codcaixa','',cPesquisa,'','prod_codigo',ret) then
       aCod:=Inteiro(Ret);

    if aCod>0 then
    begin
      if LocalizaCampoSQL('produtos','prod_codigo','',IntToStr(aCod),'','prod_qemb', ret) then
        Fator:=TextToValor(Ret);

      if Fator=0 then
        Fator:=1;

      Result:=aCod;
      exit;
    end;

  end;

  if aCod=0 then
  begin

    if LocalizaCampoSQL('cbalt','cbal_prod_codbarras','',cPesquisa,'','cbal_prod_codigo',ret) then
      aCod:=Inteiro(Ret);

    if aCod>0 then
    begin
      if LocalizaCampoSQL('cbalt','cbal_prod_codbarras','',cPesquisa,'','cbal_fatoremb', ret) then
        Fator:=TextToValor(Ret);

      if Fator=0 then
        Fator:=1;

      Result:=aCod;
      exit;
    end;
  end;

  if aCod>0 then
    Result:=aCod;
end;

function ValorToSql(Vl:Extended; Dec:Integer = 0):String;
var s:String;
begin
  if Dec=0 then begin
     try
       s:=FloatToStr(Vl);
       if Pos(FormatSettings.DecimalSeparator,s)>0 then begin
          Delete(s,1,Pos(FormatSettings.DecimalSeparator,s));
          Dec:=Length(s);
       end;
     except
     end;
  end;
  if Frac(Vl)=0 then Dec:=0;
  Str(Vl:20:Dec,s);
  Result := Trim(s);
end;

function DateToJson(Date:TDate):string;
begin
  Result:='';

  if Date>0 then
    FormatDateTime('dd/mm/yyyy',Date);
end;

function TextToDate(Text:string):TDate;
var Seculo:String;
begin
  Result:=0;
  try
    if (Trim(Text)<>'') and (Text<>'30121899') then begin
       if Copy(Text,5,2)>'40' then Seculo:='19' else Seculo:='20';
       if Length(Trim(Text))=6 then
          Result:=StrToDate(Copy(Text,1,2)+'/'+Copy(Text,3,2)+'/'+Seculo+Copy(Text,5,2))
       else if Length(Trim(Text))=8 then
          Result:=StrToDate(Copy(Text,1,2)+'/'+Copy(Text,3,2)+'/'+Copy(Text,5,4))
       else if Length(Trim(Text))=12 then
          Result:=StrToDateTime(Copy(Text,1,2)+'/'+Copy(Text,3,2)+'/'+Seculo+Copy(Text,5,2)+' '+Copy(Text,7,2)+':'+Copy(Text,9,2)+':'+Copy(Text,11,2))
       else if Length(Trim(Text))=14 then
          Result:=StrToDateTime(Copy(Text,1,2)+'/'+Copy(Text,3,2)+'/'+Copy(Text,5,4)+' '+Copy(Text,9,2)+':'+Copy(Text,11,2)+':'+Copy(Text,13,2));
    end;
  except
     Result:=0;
  end;
end;


function DateToStrSql(const Dt:TDateTime):String;
begin
  Result:='null';
  if Dt>0 then begin
     Result:=QuotedStr(FormatDateTime('yyyy-mm-dd',Dt));
  end;
end;

{procedure TelaMensagem(Titulo,Mensagem:string;tipo:Integer);
  var
     BotaoVerde : String;
begin
  frmMsg.lblTituloMSG.Text:=Titulo;
  frmMsg.MENSAGEM.Text:=Mensagem;

  case tipo of
    0: begin
        //Mensagem de erro

        frmMsg.imgMessage.Bitmap:=frmMsg.imgErro.Bitmap;
        frmMsg.btnSim.Visible:=false;
        frmMsg.btnNao.Visible:=false;
        frmMsg.btnOk.Visible:=True;

      end;
    1: begin
        frmMsg.imgMessage.Bitmap:=frmMsg.imgPergunta.Bitmap;
        frmMsg.btnSim.Visible:=True;
        frmMsg.btnNao.Visible:=True;
        frmMsg.btnOk.Visible:=False;
        frmMsg.lblTituloMSG.Text:='CONFIRMAÇÃO';
      end;
    2:begin
        frmMsg.imgMessage.Bitmap:=frmMsg.imgWrng.Bitmap;
        frmMsg.btnSim.Visible:=False;
        frmMsg.btnNao.Visible:=False;
        frmMsg.btnOk.Visible:=True;
      end;
    3:begin
        frmMsg.imgMessage.Bitmap:=frmMsg.imgSucesso.Bitmap;
        frmMsg.btnSim.Visible:=False;
        frmMsg.btnNao.Visible:=False;
        frmMsg.btnOk.StyleName:=BotaoVerde;
        frmMsg.btnOk.Visible:=True;
      end;
  end;

  frmMsg.ShowModal

    (procedure (ModalResult : TModalResult)
    begin
      Retfrm:= frmMsg.Tag;
    end);
end;     }

procedure TelaLigada(ligado: boolean);
{$IFDEF IOS}
var
    UIApp : UIApplication;
{$ENDIF}
begin
    {$IFDEF ANDROID}
    if ligado then
        Androidapi.JNI.PowerManager.AcquireWakeLock
    else
        Androidapi.JNI.PowerManager.ReleaseWakeLock;
    {$ENDIF}

    {$IFDEF IOS}
    UIApp := TUIApplication.Wrap(TUIApplication.OCClass.sharedApplication);
    UIApp.setIdleTimerDisabled(not ligado);
    {$ENDIF}
end;
end.
