// ---------------------------------------------------------------------------

#pragma hdrstop

#include "config.h"



#include <fstream>
#include <iostream>
#include <vcl.h>
using namespace std;
// ---------------------------------------------------------------------------

#pragma package(smart_init)

// функция проверяет доступность conf.ini и в случае необходимости его создаст
void CheckConfig()
{
  //ShowMessage("Создаём конфиги по дефолту");
  AnsiString st;



	/* файл можно открыть в режиме fmCreate, тогда, если
	   файл существует, он будет открыт для записи,
	   если файла нет, то он будет создан */


	/* открыть для записи или создать файл meteo.txt */

	int f;
	// строка для формирования дефолтных опций в конфиге
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
		ShowMessage("Проблема с файлом конфигурации. Переустановите программу");
	}

	while(!f.eof())
	{
		char buf[255];
		f.getline(buf,255);

		string line(buf);

		if(line.length() == 0)
			continue;

		// будем считать, что если строка начинается на # или ; это коментарий, пропускаем
		if(line[0] == '#' || line[0] == ';')
			continue;

		//удаляем пробелы из строки
		for(int i=0; i != line.length(); ++i)
		{
			if(line[i] == ' ')
			{
				line.erase(i,1);
				i = 0;
			}
		}

		int e = line.find("=");

		//если знак = отсутствует
		if(e == line.npos)
			continue;

		string p_name,p_value;
		p_name.append(line,0,e);
		p_value.append(line,e+1,line.length()-e-1);

		// после Артуровский код
	TEdit *Edit1;
	TEdit *Edit2;
	TCheckBox *CheckBox1;
	TForm1 *Form1;


	if (p_name.c_str() == "login")
	{
		Edit1->Text = 123123;
		ShowMessage("загружаем логин");
	}

	Edit1->Text = "123123";

	if (p_name.c_str() == "pass")
	{
		Edit2->Text = p_value.c_str();
	}

	if ((p_name.c_str() == "savedata") &&   (p_value.c_str() == "1"))
	{
		CheckBox1->Checked;
	}

// конец кода


	//	cout << "p_name = " << p_name.c_str() << ", p_value = " << p_value.c_str() << endl;
	}
};


