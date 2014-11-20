lazarus-com-example
===================

example project to test COM programming in the Lazarus IDE

# Goal
The goal of this example is to document how you can use the free Lazarus IDE to create a DLL that contains a COM object and its type library. So that you can use the COM object easily: i.e. use regsvr32 to register the COM object, read the type library from the DLL and thus use the COM object in any application.

We will build 2 projects:
1. Dll Project (LazComDll): this project will create the DLL file that includes the COM object
1. Exe Project (LazComDllApp): this project will create an EXE file which will use the registered COM object (in the DLL) and call a method on it

## System description
- Windows® 7 SP1 64 bit
- Lazarus IDE 32 bit: http://www.lazarus.freepascal.org/
 - Version #: 1.2.6
 - Date: 2014-10-11
 - FPC: Version 2.6.4
 - SVN Revision: 46529
 - i386-win32-win32/win64
- LazActiveX: http://wiki.lazarus.freepascal.org/LazActiveX/
 - required to import type libraries

## Dll Project
### Type Library
The first thing that we need is the type library. I could not find out how to build a type library in Lazarus, thus I have created one in Delphi (Does anyone know a simpler alternative or even a Lazarus extension?)

In Delphi it is easy to define the type library in a RIDL file and then generated the  <a href="LazComDll/LazComDll.ridl">type library file</a>

### Crate Lazarus Library Project
The next step is to build a Lazarus project which will finally create a DLL file: File - New - Project - Library

### Import the type library
Now we import the type library file: Tools - Import Type Library - select the *.tlb file.  
Lazarus will then create a new pascal file based on the definitions of the type library file.

### Include the type library as a resource in the DLL
We want that the created DLL file includes the type library file as a resource, so that other programs can read and use the type library. This is easy to do in free Pascal: In the Lazarus project file, include the type library file as a resource:
```pascal
{$R *.TLB}
```

### Export Functions
In the same file, we will now define the functions that the DLL exports, so that users of the DLL can use the regsvr32.exe utility to register the COM object.
- add ComServ to the uses clause
- export the following functions:
```pascal
exports
	DllGetClassObject,
	DllCanUnloadNow,
	DllRegisterServer,
	DllUnregisterServer;  
```
  
### Implement the ComObject
Now that the basic plumbing is done, we can implement the ComObject. In Lazarus: File - New - Unit: `LazComUnit`

We keep it as simple as possible. The class is called `TLazCom` and it inherits from `TAutoObject` (in the ComObj unit) and implements the COM interface `ILazCom` that is defined in the type library: The one and only method of this interface/class will print a message to stdout.

```pascal
uses
  ComObj, LazComLib_1_0_TLB;

type
  { TLazCom }
  TLazCom = class(TAutoObject, ILazCom)
  public
    procedure LazComMethod;safecall;
  end;

implementation

{ TLazCom }

procedure TLazCom.LazComMethod; safecall;
begin
  WriteLn('LazComMethod called');
end;                                         
```

### Create the Object Factory
In the initialization part of the file, we will create the Object Factory (note: you must add `ComServ` to the uses list):

```pascal
initialization
  TAutoObjectFactory.Create(ComServer, TLazCom, CLASS_LazComCoClass,
    ciMultiInstance, tmApartment);
```

### Build the DLL
In Lazarus: Run - Build  
That's it: now we have a DLL that includes the type library and the implentation of our COM object. The DLL also exports some functions that can be used by the regsvr32 utility to register the COM object in the Windows® Registry.

#### Register the COM object
In a Windows® command prompt go to the directory where the DLL file is located and run the regsvr32 utility like this:
```Batchfile
regsvr32 LazComDll.dll
```
You should see an information message box saying: `DllRegisterServer in LazComDll.dll succeeded.`

## Exe Project
The Exe project will be a simple console application.

### Create the console application
In Lazarus: File - New… - Console Application

### Import the type library
Now we import the type library file: Tools - Import Type Library - select our `LazComDll.dll` file (which includes the type library).  
Lazarus will then create a new pascal file based on the definitions of the type library file.

### Using the COM Object
Create a new unit that will instantiate the COM object: In Lazarus: File - New - Unit: `ComObjUnit`

```pascal
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
```

### Execute the application
In the console application project file, we call our function like this:
```pascal
UseComObj();
```

then build the project: Run - Build

And start the exe in a Winodws® command prompt. You should see this output:
```
creating the com object
calling the com method:
LazComMethod called
done
```

----
this document was created with the wunderfool haroo-pad markdown editor: http://pad.haroopress.com/
