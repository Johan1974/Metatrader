//+------------------------------------------------------------------+
//|                                              MyExpertAdvisor.mq4 |
//|                                                   Johan Lijffijt |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Johan Lijffijt"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <CustomFunctions.mqh>


double ThisPipValue;
string ThisSymbol;
//int ThisMagicNumber;

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
double PrevRSI;
int ThisPeriodRSI = 14;

//
double CurrentBid;
double CurrentAsk;
double CurrentPoint;
double StopLossprice = 0;
double TakeProfitprice = 0;

int StopLevel;



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Print("EA RSI Strategy started!");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Print("EA RSI Strategy stopped!");
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      //Print("***ONTICK EVENT***************************");
      for(int SymInt=0;SymInt<SymbolsTotal(false);SymInt++)
   {
      
      
      ThisSymbol = SymbolName(SymInt, true);
      //Print("***" + ThisSymbol + "**********" + SymInt + "**************");
       
      if (IsTradingAllowed(ThisSymbol))
      {
       
       //Collect Data
       ThisPipValue     = GetPipValue(ThisSymbol);
       //ThisMagicNumber  = GetMagicNumber(ThisSymbol);
       
       //Moving Average
       ThisMA           = GetMovingAverage(ThisSymbol, ThisPeriodMA);
       
       //Bollinger Band 1
       ThisBBUpper      = GetBollingerBand(ThisSymbol, ThisPeriodBB , ThisDeviation2, MODE_UPPER);
       ThisBBMain       = GetBollingerBand(ThisSymbol, ThisPeriodBB, ThisDeviation2, MODE_MAIN);
       ThisBBLower      = GetBollingerBand(ThisSymbol, ThisPeriodBB, ThisDeviation2, MODE_LOWER);
       
       //Bollinger Band 2
       ThisBBUpper2      = GetBollingerBand(ThisSymbol, ThisPeriodBB , ThisDeviation4, MODE_UPPER);
       ThisBBLower2      = GetBollingerBand(ThisSymbol, ThisPeriodBB, ThisDeviation4, MODE_LOWER);
       
       ThisRSI          = GetRSI(ThisSymbol, ThisPeriodRSI, 0);
       PrevRSI          = GetRSI(ThisSymbol, ThisPeriodRSI, 1);
       
       CurrentBid    = MarketInfo(ThisSymbol,MODE_BID);
       CurrentAsk    = MarketInfo(ThisSymbol,MODE_ASK);
       CurrentPoint  = MarketInfo(ThisSymbol,MODE_POINT);

       
       StopLossprice = 0;
       TakeProfitprice = 0;
       
       StopLevel =  (int)MarketInfo(ThisSymbol, MODE_STOPLEVEL);
       
       
       if (ThisSymbol == "GBPUSD")
       {
         Print("***ThisSymbol " + ThisSymbol + "*** PrevRSI " + PrevRSI + "*** ThisRSI " + ThisRSI );
       }
       //Print("***ThisSymbol " + ThisSymbol + "*** PrevRSI " + PrevRSI + "*** ThisRSI " + ThisRSI ); 
       if ((PrevRSI < 30) && (ThisRSI > 30)) //Buy
       //if ((CurrentAsk < ThisBBLower) && (ThisRSI < 30)  ) //Buy
       {
         //Print("Price of " + ThisSymbol + " is below signalprice, Sending Buy\Long Order");
         StopLossprice = ThisBBLower2;
         TakeProfitprice = ThisBBMain;
         
                  
         //Take StopLevel in Calculations
         if (CurrentBid - StopLossprice < StopLevel * CurrentPoint) StopLossprice = CurrentBid - StopLevel * CurrentPoint;
         if (TakeProfitprice - CurrentBid < StopLevel * CurrentPoint) TakeProfitprice = CurrentBid + StopLevel * CurrentPoint;
         
                 
         
         int OrderID = BuyOrder(ThisSymbol, CurrentAsk, StopLossprice, TakeProfitprice); 
         if (OrderID < 0) 
         {
            Print("Order rejected for " + ThisSymbol + ". Order Error " + GetLastError());
         }
         else
         {
            
            Alert("Order placed for " + ThisSymbol + ". Order " + OrderID);
         }
         
       } 
       else if ((PrevRSI > 70) && (ThisRSI < 70))  //Short
       //else if ((CurrentBid > ThisBBUpper))  //Short
       {
         //Print("Price of " + ThisSymbol + " is above signalprice, Sending Sell\Short Order");
         StopLossprice = ThisBBUpper2;
         TakeProfitprice = ThisBBMain;
         
         if (StopLossprice - CurrentAsk < StopLevel * CurrentPoint) StopLossprice = CurrentAsk + StopLevel * CurrentPoint;
         if (CurrentAsk - TakeProfitprice < StopLevel * CurrentPoint) TakeProfitprice = CurrentAsk - StopLevel * CurrentPoint;
         
         
         int OrderID = SellOrder(ThisSymbol, CurrentBid, StopLossprice, TakeProfitprice);
         if (OrderID < 0) 
         {
            Print("Order rejected for " + ThisSymbol + ". Order Error " + GetLastError());
         }
         else
         {
            
            Alert("Order placed for " + ThisSymbol + ". Order " + OrderID);
         }
         
       }
       
         
       
       
              
      }
      
      //Print("************" + ThisSymbol + "*********2*");
      
      
   }

   
  }
//+------------------------------------------------------------------+
