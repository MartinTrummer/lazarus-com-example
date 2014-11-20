library LazComDll;

{$mode objfpc}{$H+}

uses
  Classes
  { you can add units after this }
  , LazComLib_1_0_TLB
  , ComServ, LazComUnit;

{$R *.TLB}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

begin

end.

