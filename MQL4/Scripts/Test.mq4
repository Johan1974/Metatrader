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
void OnStart()
  {
//---

   for(int SymInt=0;SymInt<SymbolsTotal(true);SymInt++)
   {
      Print(SymbolName(SymInt, true) + " Trading allowed: " + IsTradeAllowed(SymbolName(SymInt, true),TimeCurrent() ));
      
      
      
   }
   
   //Print(SymbolName());
 
   //Alert(SymbolInfoDouble(NULL, SYMBOL_TRADE_CONTRACT_SIZE));
   
  }
//+------------------------------------------------------------------+
