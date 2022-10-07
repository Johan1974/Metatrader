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
   
   string ThisSymbol = "DIS.N"; 

   double entryPrice = 6.968;
   double stopLoss = 6.96;
   double pip = 0.01;
   
   int maxLossInPips = MathAbs(entryPrice - stopLoss)/GetPipValue(ThisSymbol);
   
   
   
   
   
   //2022.10.06 02:35:17.887	BB Strategy BITCOIN,M1: GetPipValue 0.01
   //2022.10.06 02:35:17.887	BB Strategy BITCOIN,M1: stopLoss 6.96
   //2022.10.06 02:35:17.887	BB Strategy BITCOIN,M1: entryPrice 6.968



   
}
   
