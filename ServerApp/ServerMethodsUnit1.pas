unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, System.Json, Data.FireDACJSONReflect,
  Datasnap.DSServer, Datasnap.DSAuth, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.UI, FireDAC.Phys.IBBase,
  FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageBin;

type
{$METHODINFO ON}
  TServerMethods1 = class(TDataModule)
    FDConnection1: TFDConnection;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDQ_Login: TFDQuery;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
  private
    { Private declarations }
  public
    { Public declarations }
    function DB2Json(const AData: TFDQuery): TJSONObject;
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function ValidaUsuario(const Usuario,Clave: string): boolean;
  public
    function Usuario(const Usuario,Clave: string): TJSONObject;
    function Habitaciones: TJSONObject;
    function GetUsuario(const Usuario,Clave: string): TFDJSONDataSets;
    function GetHabitaciones: TFDJSONDataSets;
  end;
{$METHODINFO OFF}

const
  SQL_Login='select * from Empleados where Empleados.Usuario=:usr and '+
            'Empleados.Clave=:cve';
  SQL_Rack='select * from Habitaciones order by Habitaciones.Numero';

implementation

{$R *.dfm}

uses System.StrUtils;

function TServerMethods1.DB2Json(const AData: TFDQuery): TJSONObject;
var
  JsonArray: TJsonArray;
  Registro: TJSONObject;
  I: integer;
begin
  Result:=TJsonObject.Create;
  JsonArray:=TJsonArray.Create;
  AData.First;
  Result.AddPair(TJsonPair.Create('DATA',JsonArray));
  while not AData.Eof do
  begin
    Registro:=TJsonObject.Create;
    for I:=0 to AData.Fields.Count-1 do
      Registro.AddPair(AData.Fields[I].FieldName,
                       TJsonString.Create(AData.Fields[I].AsString));
    JsonArray.Add(Registro);
    AData.Next;
  end;
end;

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
  FDQry.SQL.Text:=SQL_Login;
  FDQry.Active:=false;
  FDQry.Params[0].Value:=Usuario;
  FDQry.Params[1].Value:=Clave;
  FDQry.Prepare;
  FDQry.Open;

  Result:=not FDQry.IsEmpty;
  FreeAndNil(FDQry);

  {FDQ_Login.Active:=false;
  FDQ_Login.Params[0].Value:=Usuario;
  FDQ_Login.Params[1].Value:=Clave;
  FDQ_Login.Prepare;
  FDQ_Login.Open;
  Result:=not FDQ_Login.IsEmpty;
  if not FDQ_Login.IsEmpty then
    Result:=true;}
end;

function TServerMethods1.Usuario(const Usuario,Clave: string): TJSONObject;
var
  FDQry: TFDQuery;
begin
  FDQry:=TFDQuery.Create(nil);
  FDQry.Connection:=FDConnection1;
  FDQry.SQL.Text:=SQL_Login;
  FDQry.Active:=false;
  FDQry.Params[0].Value:=Usuario;
  FDQry.Params[1].Value:=Clave;
  FDQry.Prepare;
  FDQry.Open;
  Result:=TJSONObject.Create;
  if not FDQry.IsEmpty then Result:=DB2Json(FDQry)
  else Result.AddPair('ERROR: ','Usuario NO encontrado');
  FreeAndNil(FDQry);
end;

function TServerMethods1.Habitaciones: TJSONObject;
var
  FDQry: TFDQuery;
begin
  FDQry:=TFDQuery.Create(nil);
  FDQry.Connection:=FDConnection1;
  FDQry.SQL.Text:=SQL_Rack;
  FDQry.Active:=false;
  FDQry.Prepare;
  FDQry.Open;
  Result:=TJSONObject.Create;
  if not FDQry.IsEmpty then Result:=DB2Json(FDQry)
  else Result.AddPair('ERROR: ','No existen habitaciones');
  FreeAndNil(FDQry);
end;

function TServerMethods1.GetHabitaciones: TFDJSONDataSets;
var
  FDQry: TFDQuery;
begin
  FDQry:=TFDQuery.Create(nil);
  FDQry.Connection:=FDConnection1;
  FDQry.SQL.Text:=SQL_Rack;
  Result:=TFDJSONDataSets.Create;
  TFDJSONDataSetsWriter.ListAdd(Result,'Habitaciones',FDQry);
end;

function TServerMethods1.GetUsuario(const Usuario,
  Clave: string): TFDJSONDataSets;
var
  FDQry: TFDQuery;
begin
  FDQry:=TFDQuery.Create(nil);
  FDQry.Connection:=FDConnection1;
  FDQry.SQL.Text:=SQL_Login;
  FDQry.Active:=false;
  FDQry.Params[0].Value:=Usuario;
  FDQry.Params[1].Value:=Clave;
  FDQry.Prepare;
  Result:=TFDJSONDataSets.Create;
  TFDJSONDataSetsWriter.ListAdd(Result,'Usuarios',FDQry);
end;

end.
