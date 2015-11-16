unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, StdCtrls;

type
  TForm5 = class(TForm)
    Memo1: TMemo;
    ComboBox1: TComboBox;
    Button1: TButton;
    XPManifest1: TXPManifest;
    Label2: TLabel;
    Label3: TLabel;
    Button2: TButton;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
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
  Form5: TForm5;

implementation

uses Unit1, Unit6;

{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
begin
  if radiobutton1.Checked then
  begin
    unit1.s5:=(strtoint(combobox1.Text))*60;
    form6.Memo1.Text:=memo1.Text;
    unit1.s6:=1;
    memo1.Text:='';
    messagebox(0,'定时消息提醒已开始！','注意',mb_ok or mb_iconasterisk);
    close;
  end;
  if radiobutton2.Checked then
  begin
    unit1.s13:=strtoint(combobox2.Text+combobox3.Text+combobox4.Text);
    form6.Memo1.Text:=memo1.Text;
    unit1.s14:=1;
    memo1.Text:='';
    messagebox(0,'定时消息提醒已开始！','注意',mb_ok or mb_iconasterisk);
    close;
  end;
  if not(radiobutton1.Checked or radiobutton2.Checked) then
  begin
    messagebox(0,'请选择一种定时方式！','注意',mb_ok or mb_iconerror);
  end;
end;    


procedure TForm5.Button2Click(Sender: TObject);
begin
  close;
end;

end.
