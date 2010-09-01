//---------------------------------------------------------------------------

#ifndef DD2bH
#define DD2bH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
	TPageControl *PageControl1;
	TTabSheet *TabSheet1;
	TButton *Button1;
	TButton *Button2;
	TTabSheet *TabSheet2;
	TGroupBox *GroupBox1;
	TCheckBox *CheckBox1;
	TComboBox *ComboBox1;
	TLabel *Label1;
	TLabel *Label2;
	TLabel *Label3;
	TGroupBox *GroupBox2;
	TCheckBox *CheckBox2;
	TCheckBox *CheckBox3;
	TEdit *Edit1;
	TEdit *Edit2;
	void __fastcall Button1Click(TObject *Sender);
	void __fastcall Edit1Change(TObject *Sender);
	void __fastcall Edit2Change(TObject *Sender);
private:	// User declarations
public:		// User declarations
	__fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
