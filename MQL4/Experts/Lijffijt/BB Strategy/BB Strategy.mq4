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
double CurrentLotSize;
double CurrentLotMin;
double CurrentLotStep;
double CurrentLotMax;
double CurrentDigits;       


double StopLossPrice = 0;

double StopLevelPrice;

double TakeProfitPrice = 0;

int StopLevel;
string ThisError;


double RiskPerTrade = 0.02;



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Print("EA BB Strategy started!");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Print("EA BB Strategy stopped!");
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      //Only symbols in marketwatch = true
      for(int SymInt=0;SymInt<SymbolsTotal(false);SymInt++)
   {
      
      
      ThisSymbol = SymbolName(SymInt, true);
       
      if (IsTradingAllowed(ThisSymbol))
      {
      
        // Print("*** Checking : " + ThisSymbol + "***********************");
         
       CurrentDigits    = MarketInfo(ThisSymbol,MODE_DIGITS );   
       CurrentBid       = NormalizeDouble( MarketInfo(ThisSymbol,MODE_BID),CurrentDigits);
       CurrentAsk       = NormalizeDouble( MarketInfo(ThisSymbol,MODE_ASK),CurrentDigits);
       CurrentPoint     = NormalizeDouble( MarketInfo(ThisSymbol,MODE_POINT),CurrentDigits);
       CurrentLotSize   = NormalizeDouble( MarketInfo(ThisSymbol,MODE_LOTSIZE ),CurrentDigits);
       CurrentLotMin    = NormalizeDouble( MarketInfo(ThisSymbol,MODE_MINLOT ),CurrentDigits);
       CurrentLotStep   = NormalizeDouble( MarketInfo(ThisSymbol,MODE_LOTSTEP ),CurrentDigits);
       CurrentLotMax    = NormalizeDouble( MarketInfo(ThisSymbol,MODE_MAXLOT ),CurrentDigits);
  
      
      
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
       
       
       StopLossPrice = 0;
       TakeProfitPrice = 0;
       
       
       StopLevel =  (int)MarketInfo(ThisSymbol, MODE_STOPLEVEL);
       StopLevelPrice = (StopLevel * ThisPipValue);    // 20 * 0.0001 = 0.0002
       
       
       
       //if ((CurrentAsk < ThisBBLower && PrevRSI < 30 && ThisRSI > 30)) //Buy
       //if ((CurrentAsk < ThisBBLower && ThisRSI > 50)) //Buy
       if (CurrentAsk < ThisBBLower)  //Buy
       {
         Print("Price of " + ThisSymbol + " is below signalprice, Sending Buy\Long Order");
         
         StopLossPrice  = ThisBBLower2; 
         TakeProfitPrice = ThisBBMain;
   
         int OrderID = BuyOrder(ThisSymbol, CurrentAsk, StopLossPrice, TakeProfitPrice, RiskPerTrade); 
         
         if (OrderID < 0) 
         {
           
            Print("************************************");
            Print("Buy Order rejected for " + ThisSymbol + ". Order Error " + GetLastError());
            Print("MODE_LOTSIZE = ", MarketInfo(ThisSymbol, MODE_LOTSIZE));
            Print("MODE_MINLOT = ", MarketInfo(ThisSymbol, MODE_MINLOT));
            Print("MODE_LOTSTEP = ", MarketInfo(ThisSymbol, MODE_LOTSTEP));
            Print("MODE_MAXLOT = ", MarketInfo(ThisSymbol, MODE_MAXLOT));
            Print("************************************");
            
         }
         else
         {
            
            Alert("Buy Order placed for " + ThisSymbol + ". Order " + OrderID);
         }
         
       } 
       //else if (CurrentBid > ThisBBUpper  && PrevRSI > 70 && ThisRSI < 70)  //Short/Sell
       //else if (CurrentBid > ThisBBUpper  && ThisRSI < 50)  //Short/Sell
       else if (CurrentBid > ThisBBUpper )  //Short/Sell
       {
         Print("Price of " + ThisSymbol + " is above signalprice, Sending Sell\Short Order");
         
         
          
         StopLossPrice = ThisBBUpper2;
         TakeProfitPrice = ThisBBMain;
                 
        
         int OrderID = SellOrder(ThisSymbol, CurrentBid,StopLossPrice, TakeProfitPrice, RiskPerTrade);
         
         if (OrderID < 0) 
         {
            
            
            Print("************************************");
            Print("Sell Order rejected for " + ThisSymbol + ". Order Error " + GetLastError());
            Print("MODE_LOTSIZE = ", MarketInfo(ThisSymbol, MODE_LOTSIZE));
            Print("MODE_MINLOT = ", MarketInfo(ThisSymbol, MODE_MINLOT));
            Print("MODE_LOTSTEP = ", MarketInfo(ThisSymbol, MODE_LOTSTEP));
            Print("MODE_MAXLOT = ", MarketInfo(ThisSymbol, MODE_MAXLOT));
            Print("************************************");
         
         }
         else
         {
            
            Alert("Sell Order placed for " + ThisSymbol + ". Order " + OrderID);
         }
         
       }
       
         
       
       
              
      }
      
      
      
   }

   
  }
//+------------------------------------------------------------------+
