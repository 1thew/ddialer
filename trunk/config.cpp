// ---------------------------------------------------------------------------

#pragma hdrstop

#include "config.h"
//#include "DD2b.h"




using namespace std;
//TForm1 *Form1;
// ---------------------------------------------------------------------------

#pragma package(smart_init)

// ������� ��������� ����������� conf.ini � � ������ ������������� ��� �������
void config::CheckConfig()
{
  //ShowMessage("������ ������� �� �������");
  AnsiString st;



	/* ���� ����� ������� � ������ fmCreate, �����, ����
	   ���� ����������, �� ����� ������ ��� ������,
	   ���� ����� ���, �� �� ����� ������ */


	/* ������� ��� ������ ��� ������� ���� config.ini */

	int f;
	// ������ ��� ������������ ��������� ����� � �������
	st = "login=\npass=\ntype=1\nautoconnect=0\nautoload=0\nsavedata=0\n";

	if ( FileExists("config.ini") )
	{
		return;
	}
	else
	{
	   f = FileCreate("config.ini");
	   f = FileOpen("config.ini",fmOpenWrite);
		FileWrite(f,st.c_str(),st.Length());
		FileClose(f);
	}
};

void config::ReadConfig ()
{

	ifstream f("config.ini", ios::in);

	CheckConfig();
	if(!f)
	{
		ShowMessage("�������� � ������ ������������. ���� ��������� �����������, �������������� ���������");
		return;
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

	if (name == "login")
	{
	  c_login = p_value;
	}

	if (name == "pass")
	{
		c_pass = p_value;
	}

	if (name == "type")
	{
		c_type = atoi(p_value.c_str());
	}

	if (name == "autoconnect")
	{
		c_autoconnect = atoi(p_value.c_str());
	}

	if (name == "autoload")
	{
		c_autoload = atoi(p_value.c_str());
	}

	if (name == "savedata")
	{
		c_savedata = atoi(p_value.c_str());
	}

	}
};


