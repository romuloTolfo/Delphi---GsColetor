unit uDm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.IOUtils,
  FireDAC.Phys.SQLiteWrapper.Stat;
type
    Tdm = class(TDataModule)
    conn: TFDConnection;
    qry: TFDQuery;
    procedure connBeforeConnect(Sender: TObject);
    procedure connAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GetDadosConfig(var dado: string; campo: string);
    procedure conectaBancoDB;
  end;
var
  dm: Tdm;


implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}


procedure Tdm.conectaBancoDB;
begin
  try
      conn.connected := True;
      except on e:exception do
      raise Exception.Create('Erro de conexão com o banco de dados:' + e.message);
    end;;
end;

procedure Tdm.connAfterConnect(Sender: TObject);

 begin
    Conn.ExecSQL('CREATE TABLE IF NOT EXISTS config ( ' +
                            'cfg_unid      varchar(3), ' +
                            'cfg_url              VARCHAR(100));'

                       +

                        ('CREATE TABLE IF NOT EXISTS coletas ( ' +

                          'clta_unid_codigo varchar(3), ' +
                          'clta_status varchar(20), ' +
                          'clta_prod_codigo numeric(7,0), ' +
                          'clta_prod_codbarras varchar(14), ' +
                          'clta_qtde numeric(15,5), '  +
                          'clta_data date, ' +
                          'clta_validade date, ' +
                          'clta_time varchar(8), ' +
                          'clta_qtdeusada numeric(15,5), ' +
                          'clta_user varchar(50), ' +
                          'clta_forn_codigo numeric(6,0), ' +
                          'clta_tipo varchar(10) , ' +
                          'clta_tipo_processo char(3) , ' +
                          'clta_nomearquivo varchar(200) , ' +
                          'clta_prod_vinculado numeric(7,0), ' +
                          'clta_fator numeric(10,3), ' +
                          'clta_temperatura numeric(8,3), ' +
                          'clta_controle varchar(20) , ' +
                          'clta_lote varchar(10) , ' +
                          'clta_motivo varchar(1) , ' +
                          'clta_documento varchar(15) , ' +
                          'clta_user_cracha varchar(50));'
      +
        ('CREATE TABLE IF NOT EXISTS produtos ( ' +
                          'prod_codigo varchar(8) , ' +
                          'prod_codbarras numeric(14), ' +
                          'prun_unid_codigo numeric(3), ' +
                          'prod_descricao varchar(60), ' +
                          'prod_complemento varchar(20), ' +
                          'prod_marca varchar(20), ' +
                          'prun_ativo varchar(10), ' +
                          'prun_bloqueado varchar(10), ' +
		                      'prun_prvenda varchar(7), ' +
                          'prun_fatorpr3 varchar(20), ' +
                          'prun_prvenda3 varchar(20), ' +
                          'prod_grup_codigo numeric (6), ' +
                          'prod_grup_nome varchar(20), ' +
                          'prod_dpto_codigo numeric(7), ' +
                          'dpto_descricao varchar(20), ' +
                          'prun_estoque1 varchar(20), ' +
                          'prun_estoque2 varchar(20), ' +
                          'prun_estoque3 varchar(20), ' +
                          'prun_estoque4 varchar(20), ' +
                          'prun_estoque5 varchar(20), ' +
                          'prun_oferta varchar(20), ' +
                          'prun_dtinioferta date, ' +
                          'prun_dtoferta date, ' +
                          'prun_prnormal varchar(20), ' +
                          'prun_dtprvenda date);'
        )));


 end;

procedure Tdm.connBeforeConnect(Sender: TObject);
begin
    conn.DriverName := 'SQLite';

    {$IFDEF MSWINDOWS}
    conn.Params.Values['Database'] := 'B:\DB\coletor.db';
    {$ELSE}
    conn.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'coletor.db');
    {$ENDIF}
end;
procedure Tdm.GetDadosConfig(var dado: string; campo: string);
var
  cm : string;
  qry : TFDQuery;
begin
   qry := TFDQuery.Create(nil);
   qry.Connection := conn;

  cm := 'select ' + campo + ' from config ';
  qry.SQL.Text := cm;

  try
    qry.Active := true;
    dado := qry.FieldByName(campo).AsString;
  finally
    FreeAndNil(qry);
  end;

end;
end.
