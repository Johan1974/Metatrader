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

void OnStart()
  {
//---

   for(int SymInt=0;SymInt<SymbolsTotal(true);SymInt++)
   {
      ThisSymbol = SymbolName(SymInt, true);
      ThisMagicNumber = GetMagicNumber(ThisSymbol); 
      if (IsTradingAllowed(ThisSymbol))
      {
       
       //Collect Data
       ThisPipValue = GetPipValue(ThisSymbol);
         
      
       
       Print("");  
       Print("Symbol       :  "  + ThisSymbol);
       Print("ThisPipValue :  "  + ThisPipValue); 
       Print("MagicNumber  :  "  + ThisMagicNumber);
              
      }
      
      
      //Is Trade Allowed
      
      
   }
   
   
   
   
   ThisMagicNumber = GetMagicNumber("EURUSD");
   Print("******");
   Print("Magic " + ThisMagicNumber);
   Print("******");
   
   //Print(SymbolName());
 
   //Alert(SymbolInfoDouble(NULL, SYMBOL_TRADE_CONTRACT_SIZE));
   
  }
//+------------------------------------------------------------------+
