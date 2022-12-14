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

//Moving Average
double ThisMA;
int ThisPeriodMA  = 20;

//Bollinger Band
int ThisPeriodBB  = 20;
int ThisDeviation2  = 2;
int ThisDeviation4  = 4;

double ThisBBUpper;
double ThisBBMain;
double ThisBBLower;

double ThisBBUpper2;
double ThisBBLower2;

//RSI
double ThisRSI;
int ThisPeriodRSI = 14;

//
double CurrentBid;
double CurrentAsk;
double CurrentPoint;
double StopLossprice = 0;
double TakeProfitprice = 0;

int StopLevel;
   

void OnStart()
  {
//---

   for(int SymInt=0;SymInt<SymbolsTotal(true);SymInt++)
   {
      
      
      ThisSymbol = SymbolName(SymInt, true);
       
      if (IsTradingAllowed(ThisSymbol))
      {
       
       //Collect Data
       ThisPipValue     = GetPipValue(ThisSymbol);
       ThisMagicNumber  = GetMagicNumber(ThisSymbol);
       
       //Moving Average
       ThisMA           = GetMovingAverage(ThisSymbol, ThisPeriodMA);
       
       //Bollinger Band 1
       ThisBBUpper      = GetBollingerBand(ThisSymbol, ThisPeriodBB , ThisDeviation2, MODE_UPPER);
       ThisBBMain       = GetBollingerBand(ThisSymbol, ThisPeriodBB, ThisDeviation2, MODE_MAIN);
       ThisBBLower      = GetBollingerBand(ThisSymbol, ThisPeriodBB, ThisDeviation2, MODE_LOWER);
       
       //Bollinger Band 2
       ThisBBUpper2      = GetBollingerBand(ThisSymbol, ThisPeriodBB , ThisDeviation4, MODE_UPPER);
       ThisBBLower2      = GetBollingerBand(ThisSymbol, ThisPeriodBB, ThisDeviation4, MODE_LOWER);
       
       ThisRSI          = GetRSI(ThisSymbol, ThisPeriodRSI);
       
       CurrentBid    = MarketInfo(ThisSymbol,MODE_BID);
       CurrentAsk    = MarketInfo(ThisSymbol,MODE_ASK);
       CurrentPoint  = MarketInfo(ThisSymbol,MODE_POINT);
   
   
       StopLossprice = 0;
       TakeProfitprice = 0;
       
       StopLevel =  (int)MarketInfo(ThisSymbol, MODE_STOPLEVEL);
        
       
       if (CurrentAsk < ThisBBLower) //Buy
       {
         Print("Price of " + ThisSymbol + " is below signalprice, Sending Buy\Long Order");
         StopLossprice = ThisBBLower2;
         TakeProfitprice = ThisBBMain;
         
         Print ("StopLossprice1   " + StopLossprice);
         Print ("TakeProfitprice1 " + TakeProfitprice);
         
         
         //Take StopLevel in Calculations
         if (CurrentBid - StopLossprice < StopLevel * CurrentPoint) StopLossprice = CurrentBid - StopLevel * CurrentPoint;
         if (TakeProfitprice - CurrentBid < StopLevel * CurrentPoint) TakeProfitprice = CurrentBid + StopLevel * CurrentPoint;
         
         Print ("StopLossprice2   " + StopLossprice);
         Print ("TakeProfitprice2 " + TakeProfitprice);
         
                  
         int OrderID = BuyOrder(ThisSymbol, CurrentAsk, StopLossprice, TakeProfitprice); 
         if (OrderID < 0) Print(ThisSymbol + " Order rejected. Order Error " + GetLastError());
         
       } 
       else if (CurrentBid > ThisBBUpper)  //Sell
       {
         Print("Price of " + ThisSymbol + " is above signalprice, Sending Sell\Short Order");
         StopLossprice = ThisBBUpper2;
         TakeProfitprice = ThisBBMain;
         
         //Take StopLevel in Calculations
         Print ("StopLossprice1   " + StopLossprice);
         Print ("TakeProfitprice1 " + TakeProfitprice);
         
         if (StopLossprice - CurrentAsk < StopLevel * CurrentPoint) StopLossprice = CurrentAsk + StopLevel * CurrentPoint;
         if (CurrentAsk - TakeProfitprice < StopLevel * CurrentPoint) TakeProfitprice = CurrentAsk - StopLevel * CurrentPoint;
         
         Print ("StopLossprice2   " + StopLossprice);
         Print ("TakeProfitprice2 " + TakeProfitprice);
         
         
         int OrderID = SellOrder(ThisSymbol, CurrentBid, StopLossprice, TakeProfitprice);
         if (OrderID < 0) Print(ThisSymbol + " Order rejected. Order Error " + GetLastError());
         
       }
       
         
       
         Print("****" + ThisSymbol + "***1**");
       
       
              
      }
      
      
      
      
   }
   
   
  }
//+------------------------------------------------------------------+
