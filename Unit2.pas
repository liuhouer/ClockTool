unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan;

type
  TForm2 = class(TForm)
    ComboBox1: TComboBox;
    Button1: TButton;
    Label2: TLabel;
    XPManifest1: TXPManifest;
    Button2: TButton;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  if radiobutton1.Checked then
  begin
    unit1.s1:=(strtoint(combobox1.Text))*60;
    unit1.s3:=1;
    messagebox(0,'闹钟定时已开始！','注意',mb_ok or mb_iconasterisk);
    close;
  end;
  if radiobutton2.Checked then
  begin
    unit1.s9:=strtoint(combobox2.Text+combobox3.Text+combobox4.Text);
    s10:=1;
    messagebox(0,'闹钟定时已开始！','注意',mb_ok or mb_iconasterisk);
    close;
  end;
  if not(radiobutton1.Checked or radiobutton2.Checked) then
  begin
    messagebox(0,'请选择一种定时方式！','注意',mb_ok or mb_iconerror);
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  close;
end;

end.
