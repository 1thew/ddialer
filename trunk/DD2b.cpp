//---------------------------------------------------------------------------

#include <vcl.h>
#include "config.h"
#pragma hdrstop

#include "DD2b.h"
#include <Dialogs.hpp>
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"

#include "mainunit.h"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
    // сформировать список компонента ComboBox1
	ComboBox1->Items->Add("VPN (default)");
	ComboBox1->Items->Add("VPN (сеть АлтГТУ)");
	ComboBox1->Items->Add("PPPoE");

	//	config* conf = new config();
	//	conf->ReadConfig ();
	//	Edit1->Text = conf->GetLogin().c_str();

	SendConfigToForm ();
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Edit1Change(TObject *Sender)
{
	if (Edit1->Text.Length() < 3)
		Button1->Enabled = false;
	else
		Button1->Enabled = true;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Edit2Change(TObject *Sender)
{
	if  ((Edit2->Text.Length() < 3))
		Button1->Enabled = false;
	else
		Button1->Enabled = true;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::CheckBox1Click(TObject *Sender)
{
  if(CheckBox1->Checked)
  {
	Edit1->Enabled = false;
	Edit2->Enabled = false;
	ComboBox1->Enabled = false;
  }
  else
  {
	Edit1->Enabled = true;
	Edit2->Enabled = true;
	ComboBox1->Enabled = true;
  }

}
//---------------------------------------------------------------------------




