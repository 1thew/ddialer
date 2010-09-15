// ---------------------------------------------------------------------------

#pragma hdrstop

#include "config.h"
//#include "DD2b.h"




using namespace std;
//TForm1 *Form1;
// ---------------------------------------------------------------------------

#pragma package(smart_init)

// функция проверяет доступность conf.ini и в случае необходимости его создаст
void config::CheckConfig()
{
  //ShowMessage("Создаём конфиги по дефолту");
  AnsiString st;



	/* файл можно открыть в режиме fmCreate, тогда, если
	   файл существует, он будет открыт для записи,
	   если файла нет, то он будет создан */


	/* открыть для записи или создать файл config.ini */

	int f;
	// строка для формирования дефолтных опций в конфиге
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
		ShowMessage("Проблема с файлом конфигурации. Если сообщение повторяется, переустановите программу");
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


