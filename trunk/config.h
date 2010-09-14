//---------------------------------------------------------------------------

#ifndef configH
#define configH
#include "DD2b.h"
#include <fstream>
#include <iostream>
#include <vcl.h>
class config
{
	private:
		std::string c_login;
		std::string c_pass;
		int c_type;
		int c_autoconnect;
		int c_autoload;
		int c_savedata;
	public:
		config()
		{
			c_login = "login";
			c_pass = "pass";
			c_type = 1;
			c_autoconnect = 0;
			c_autoload = 0;
			c_savedata = 0;
		}
		void CheckConfig();
		void ReadConfig ();
		std::string GetLogin()
		{
			return c_login;
		}
		std::string GetPass()
		{
			return c_pass;
		}
};


//---------------------------------------------------------------------------
#endif
