//+------------------------------------------------------------------+
//|                                                    BBReEntry.mq4 |
//|                                                   Johan Lijffijt |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Johan Lijffijt"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


int                  InpBandsPeriods         =  20;            //Bands Period
double               InpBandsDeviations      =  2.0;           //Bands Deviation
ENUM_APPLIED_PRICE   InpBandsAppliedPrice    =  PRICE_CLOSE;   //Bands Price

int                  RSIPeriods              =  14;
int                  RSIUpper                =  50;
int                  RSILower                =  50;

ENUM_APPLIED_PRICE   RSIAppliedPrice         =  PRICE_CLOSE;   //RSI Price
                    


double               InpTPDeviations         =  1.0;           //Take profit deviations
double               InpSLDeviations         =  1.0;           //Take loss deviations

double               InpVolume               =  0.01;          //Lot Size
int                  MagicNumber             =  202020;        //Magic Number
string               InpTradeComment         =  __FILE__;      //Trade comment





//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

      if (!IsNewBar()) return;
   
   
      double close1  = iClose(Symbol(), Period(), 1);
      double high1   = iHigh(Symbol(), Period(), 1);
      double low1    = iLow(Symbol(), Period(), 1);
      
      double upper1  = iBands(Symbol(), Period(), InpBandsPeriods, InpBandsDeviations, 0 , InpBandsAppliedPrice, MODE_UPPER, 1);
      double lower1  = iBands(Symbol(), Period(), InpBandsPeriods, InpBandsDeviations, 0 , InpBandsAppliedPrice, MODE_LOWER, 1);
      
      double close2  = iClose(Symbol(), Period(), 2);

      double upper2  = iBands(Symbol(), Period(), InpBandsPeriods, InpBandsDeviations, 0 , InpBandsAppliedPrice, MODE_UPPER, 2);
      double lower2  = iBands(Symbol(), Period(), InpBandsPeriods, InpBandsDeviations, 0 , InpBandsAppliedPrice, MODE_LOWER, 2);
   
      double thisRSI =  iRSI(Symbol(), Period(), RSIPeriods , PRICE_CLOSE, 0);
      double prevRSI =  iRSI(Symbol(), Period(), RSIPeriods , PRICE_CLOSE, 1);
      
      Print ("thisRSI" + thisRSI);
      Print ("prevRSI" + prevRSI);
      
       
   
      if (close2 > upper2 && close1 < upper1     )
      {
         Print ("*****************************");
         Print ("SELL_STOP");
         Print ("thisRSI" + thisRSI);
         Print ("prevRSI" + prevRSI);
         OpenOrder(ORDER_TYPE_SELL_STOP, low1, (upper1-lower1));
         Print ("*****************************");
         
      }
      
      if (close2 < lower2 && close1 > lower1    )
      {
         Print ("*****************************");
         Print ("BUY_STOP");   
         Print ("thisRSI" + thisRSI);
         Print ("prevRSI" + prevRSI);
         OpenOrder(ORDER_TYPE_BUY_STOP, high1, (upper1-lower1));
         Print ("*****************************");

      }
      
      return;
      
   
  }
  
int OpenOrder(ENUM_ORDER_TYPE orderType, double entryPrice, double channelWidth)
{
   //Size of one deviation
   double deviation     =  channelWidth/(2*InpBandsDeviations);
   double tp            =  deviation * InpTPDeviations;
   double sl            =  deviation * InpSLDeviations;
   datetime expiration  =  iTime(Symbol(), Period(), 0) + PeriodSeconds()-1;
   
   entryPrice           =  NormalizeDouble(entryPrice, Digits());
   double   tpPrice     =  0.0;
   double   slPrice     =  0.0;
   double   price       =  0.0;
   
   double stopslevel    = Point()*SymbolInfoInteger(Symbol(), SYMBOL_TRADE_STOPS_LEVEL);

   if (orderType%2==ORDER_TYPE_BUY) 
   {
      price    =  Ask;
      if (price>=(entryPrice-stopslevel))
      {
         entryPrice = price;
         orderType = ORDER_TYPE_BUY;
      }
      tpPrice = NormalizeDouble(entryPrice+tp, Digits());
      slPrice = NormalizeDouble(entryPrice-sl, Digits());
      
   } else
   if (orderType%2==ORDER_TYPE_SELL) 
   {
      price    =  Bid;
      if (price<=(entryPrice+stopslevel))
      {
         entryPrice = price;
         orderType = ORDER_TYPE_SELL;
      }
      tpPrice = NormalizeDouble(entryPrice-tp, Digits());
      slPrice = NormalizeDouble(entryPrice+sl, Digits());
      
   }else {
   return(0);
   }
   
   return(OrderSend(Symbol(), orderType, InpVolume, entryPrice, 0 , slPrice, tpPrice,
                     InpTradeComment, MagicNumber, expiration));
   
   
}  
  
bool IsNewBar()
{
   //Open time for the current bar
   datetime currentBarTime = iTime(Symbol(), Period(), 0);
   
   //Initialise on first use
   static datetime prevBarTime = currentBarTime;
   
   if (prevBarTime  < currentBarTime) //New Bar Opened
   {
      prevBarTime = currentBarTime;  //Update prev time before exit
      return(true);
   }
   
   return(false);
   
}  
//+------------------------------------------------------------------+
