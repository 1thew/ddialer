//---------------------------------------------------------------------------


#pragma hdrstop

#include "mainunit.h"
#include "ras.h"
#include "DD2b.h"


//---------------------------------------------------------------------------

#pragma package(smart_init)



void DisableEdit ()
{
	TButton *Button1;
	TEdit *Edit1;
	TEdit *Edit2;
	TComboBox *ComboBox1;

	if (IsActiveConnection)
	{
		Edit1->Enabled = false;
		Edit2->Enabled = false;
		ComboBox1->Enabled = false;
		Button1->Enabled = false;
	}
}