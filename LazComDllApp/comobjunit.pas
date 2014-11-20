unit ComObjUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazComLib_1_0_TLB;

procedure UseComObj();

implementation

procedure UseComObj();
var
   LazCom: ILazCom;
begin
  WriteLn('creating the com object');
  LazCom := CoLazComCoClass.Create();
  WriteLn('calling the com method:');
  LazCom.LazComMethod();
  WriteLn('done');
end;

end.

