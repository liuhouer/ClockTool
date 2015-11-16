unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, StdCtrls;

type
  TForm7 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    ComboBox1: TComboBox;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    XPManifest1: TXPManifest;
    Label2: TLabel;
    Label3: TLabel;
    Button3: TButton;
    Label4: TLabel;
    Label5: TLabel;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label1: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm7.Button1Click(Sender: TObject);
begin
 opendialog1.Execute;
 edit1.Text:=opendialog1.FileName;
end;

procedure TForm7.Button2Click(Sender: TObject);
begin
  if edit1.Text='' then
  messagebox(0,'请选择一个exe程序！','警告',mb_ok or mb_iconerror)
  else
  begin
    if radiobutton1.checked then
    begin
      unit1.s8:=edit1.Text;
      unit1.r:=strtoint((combobox1.Text))*60;
      unit1.s:=1;
      messagebox(0,'定时打开程序已开始！','注意',mb_ok or mb_iconasterisk);
      close;
    end;
    if radiobutton2.checked then
    begin
      unit1.s17:=edit1.Text;
      unit1.s15:=strtoint(combobox2.Text+combobox3.Text+combobox4.Text);
      unit1.s16:=1;
      messagebox(0,'定时打开程序已开始！','注意',mb_ok or mb_iconasterisk);
      close;
    end;
  end;
  if not(radiobutton1.Checked or radiobutton2.Checked) then
  begin
    messagebox(0,'请选择一种定时方式！','注意',mb_ok or mb_iconerror);
  end;    
end;

procedure TForm7.Button3Click(Sender: TObject);
begin
  close;
end;

end.
