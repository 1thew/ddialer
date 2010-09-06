//---------------------------------------------------------------------------

#ifndef configH
#define configH
#include "DD2b.h"

void CheckConfig();

class ConfigData
{

	int *type;
	bool *savedata;
//**************************************************************************
	bool *autoconnect;
	bool *autoload;
};

//---------------------------------------------------------------------------
#endif
