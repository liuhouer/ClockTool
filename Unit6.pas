unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, ExtCtrls;

type
  TForm6 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    XPManifest1: TXPManifest;
    Label1: TLabel;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm6.Button1Click(Sender: TObject);
begin
  close;
end;
end.
