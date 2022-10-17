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

//
double CurrentBid;
double CurrentAsk;
double CurrentPoint;
double CurrentLotSize;
double CurrentLotMin;
double CurrentLotStep;
double CurrentLotMax;
double CurrentDigits;       
int CurrentStopLevel;

   
   string ThisSymbol = "EURUSD"; 

   
   CurrentDigits    = MarketInfo(ThisSymbol,MODE_DIGITS );   
   CurrentBid       = NormalizeDouble( MarketInfo(ThisSymbol,MODE_BID),CurrentDigits);
   CurrentAsk       = NormalizeDouble( MarketInfo(ThisSymbol,MODE_ASK),CurrentDigits);
   CurrentPoint     = NormalizeDouble( MarketInfo(ThisSymbol,MODE_POINT),CurrentDigits);
   CurrentLotSize   = NormalizeDouble( MarketInfo(ThisSymbol,MODE_LOTSIZE ),CurrentDigits);
   CurrentLotMin    = NormalizeDouble( MarketInfo(ThisSymbol,MODE_MINLOT ),CurrentDigits);
   CurrentLotStep   = NormalizeDouble( MarketInfo(ThisSymbol,MODE_LOTSTEP ),CurrentDigits);
   CurrentLotMax    = NormalizeDouble( MarketInfo(ThisSymbol,MODE_MAXLOT ),CurrentDigits);
   CurrentStopLevel =  (int)MarketInfo(ThisSymbol, MODE_STOPLEVEL);
  
  Alert("**********");
  Alert("_Point " + _Point);
  Alert("CurrentPoint " + CurrentPoint);
  Alert("CurrentStopLevel " + CurrentStopLevel);
  Alert("StopLevel * _Point" + CurrentStopLevel * CurrentPoint);
  
  //if (CurrentAsk - Entry < StopLevel * _Point) Entry = Ask - StopLevel * _Point;
         
  
  
  
  Alert("Ask " + Ask);
  Alert("CurrentBid" + CurrentBid);
  Alert("CurrentAsk" + CurrentAsk);
  Alert("**********");
  
   
   
   
   
   //2022.10.06 02:35:17.887	BB Strategy BITCOIN,M1: GetPipValue 0.01
   //2022.10.06 02:35:17.887	BB Strategy BITCOIN,M1: stopLoss 6.96
   //2022.10.06 02:35:17.887	BB Strategy BITCOIN,M1: entryPrice 6.968



   
}
   
