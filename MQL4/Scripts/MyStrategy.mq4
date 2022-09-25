#include <CustomFunctions.mqh>

//+------------------------------------------------------------------+
//|                                                         Test.mq4 |
//|                                                   Johan Lijffijt |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Johan Lijffijt"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

double ThisPipValue;
string ThisSymbol;
int ThisMagicNumber;

//Indicators
double ThisMA;


void OnStart()
  {
//---

   for(int SymInt=0;SymInt<SymbolsTotal(true);SymInt++)
   {
      
      
      ThisSymbol = SymbolName(SymInt, true);
       
      if (IsTradingAllowed(ThisSymbol))
      {
       
       //Collect Data
       ThisPipValue = GetPipValue(ThisSymbol);
       ThisMagicNumber = GetMagicNumber(ThisSymbol);
       ThisMA = GetMovingAverage(ThisSymbol);
       Print("***************************");
       Print("ThisPipValue    :  "  + ThisPipValue); 
       Print("MagicNumber     :  "  + ThisMagicNumber);
       Print("MovingAverage   :  "  + ThisMA);
       Print("****" + ThisSymbol + "*****");  
       
              
      }
      
      
      //Is Trade Allowed
      
      
   }
   
   
  }
//+------------------------------------------------------------------+
