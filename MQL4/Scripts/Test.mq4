//+------------------------------------------------------------------+
//|                                                         Test.mq4 |
//|                                                   Johan Lijffijt |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Johan Lijffijt"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <CustomFunctions.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   
   
   

   string ThisSymbol = "ZCASH";
   
   
   Print ("StopLevel" + StopLevel);    
       
   if (IsTradingAllowed(ThisSymbol))
   {
   
   Print("******" + ThisSymbol + "******");
   Print("LotSize " + MarketInfo(ThisSymbol,MODE_MINLOT));
   Print("TradeContract " + SymbolInfoDouble(ThisSymbol, SYMBOL_TRADE_CONTRACT_SIZE));
   Print("******" + ThisSymbol + "******");
   
   Print("****" + ThisSymbol  + "1*****");
   Print("LotSize " + GetMinimumLot(ThisSymbol));
   Print("TradeContract " + GetTradeContractSize(ThisSymbol));  
   Print("****" + ThisSymbol + "1*****");  
   
   }
        
  }
//+------------------------------------------------------------------+
