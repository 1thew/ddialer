// ---------------------------------------------------------------------------

#pragma hdrstop

#include "config.h"
#include "DD2b.h"



#include <fstream>
#include <iostream>
#include <vcl.h>
using namespace std;
TForm1 *Form1;
// ---------------------------------------------------------------------------

#pragma package(smart_init)

// ������� ��������� ����������� conf.ini � � ������ ������������� ��� �������
void CheckConfig()
{
  //ShowMessage("������ ������� �� �������");
  AnsiString st;



	/* ���� ����� ������� � ������ fmCreate, �����, ����
	   ���� ����������, �� ����� ������ ��� ������,
	   ���� ����� ���, �� �� ����� ������ */


	/* ������� ��� ������ ��� ������� ���� meteo.txt */

	int f;
	// ������ ��� ������������ ��������� ����� � �������
	st = "login=\npass=\nautoconnect=0\nautoload=0\nsavedata=0\n";

	if ( FileExists("config.ini") )
	{
		f = FileOpen("config.ini",fmOpenWrite);
		FileClose(f);
	}
	else
	{
	   f = FileCreate("config.ini");
	   FileClose(f);
	   f = FileOpen("config.ini",fmOpenWrite);
		FileWrite(f,st.c_str(),st.Length());
		FileClose(f);
	}
	return;
};

void ReadConfig ()
{

	ifstream f("config.ini", ios::in);
	if(!f)
	{
		ShowMessage("�������� � ������ ������������. �������������� ���������");
	}

	TEdit *Edit1;
	TEdit *Edit2;
	TCheckBox *CheckBox1;

	while(!f.eof())
	{
		char buf[255];
		f.getline(buf,255);

		string line(buf);

		if(line.length() == 0)
			continue;

		// ����� �������, ��� ���� ������ ���������� �� # ��� ; ��� ����������, ����������
		if(line[0] == '#' || line[0] == ';')
			continue;

		//������� ������� �� ������
		for(int i=0; i != line.length(); ++i)
		{
			if(line[i] == ' ')
			{
				line.erase(i,1);
				i = 0;
			}
		}

		int e = line.find("=");

		//���� ���� = �����������
		if(e == line.npos)
			continue;

		string p_name,p_value;
		p_name.append(line,0,e);
		p_value.append(line,e+1,line.length()-e-1);

		// ����� ����������� ���

	AnsiString name = p_name.c_str();
	AnsiString value = p_value.c_str();

	if (name == "login")
	{
	  ShowMessage(name);
	  ShowMessage(value);
	  Edit1->Text = value;
	}
/*
	if (name == "pass")
	{
		ShowMessage(name);
		ShowMessage(value);
		Edit2->Text = p_value.c_str();
	}

	if ((p_name.c_str() == "savedata") &&   (p_value.c_str() == "1"))
	{
		CheckBox1->Checked;
	}
*/
	}
};


