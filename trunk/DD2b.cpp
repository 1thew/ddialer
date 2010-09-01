//---------------------------------------------------------------------------

#include <vcl.h>
#include "readconfig.h"
#pragma hdrstop

#include "DD2b.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
    // сформировать список компонента ComboBox1
	ComboBox1->Items->Add("VPN (default)");
	ComboBox1->Items->Add("VPN (сеть АлтГТУ)");
	ComboBox1->Items->Add("PPPoE");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
	  CheckConfig();
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Edit1Change(TObject *Sender)
{
	if ( (Edit1->Text.Length() == 0 ) || ((Edit1->Text.Length() < 4)))
		Button1->Enabled = false;
	else
		Button1->Enabled = true;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Edit2Change(TObject *Sender)
{
	if  ((Edit2->Text.Length() < 4))
		Button1->Enabled = false;
	else
		Button1->Enabled = true;
}
//---------------------------------------------------------------------------

