unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, System.Json,
    Datasnap.DSServer, Datasnap.DSAuth, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.UI, FireDAC.Phys.IBBase;

type
{$METHODINFO ON}
  TServerMethods1 = class(TDataModule)
    FDConnection1: TFDConnection;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDQ_Login: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function ValidaUsuario(const Usuario,Clave: string): boolean;
  public
    function Usuario(const Usuario,Clave: string): TJSONObject;
  end;
{$METHODINFO OFF}

implementation

{$R *.dfm}

uses System.StrUtils;

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TServerMethods1.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

function TServerMethods1.ValidaUsuario(const Usuario, Clave: string): boolean;
var
  FDQry: TFDQuery;
begin
  Result:=false;
  FDQry:=TFDQuery.Create(nil);
  FDQry.Connection:=FDConnection1;
  FDQ_Login.Active:=false;
  FDQ_Login.Params[0].Value:=Usuario;
  FDQ_Login.Params[1].Value:=Clave;
  FDQ_Login.Prepare;
  FDQ_Login.Open;
  Result:=not FDQ_Login.IsEmpty;
  {if not FDQ_Login.IsEmpty then
    Result:=true;}
end;

function TServerMethods1.Usuario(const Usuario,Clave: string): TJSONObject;
var
  FDQry: TFDQuery;
begin

end;

end.
