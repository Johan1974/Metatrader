//+------------------------------------------------------------------+
//|                                                      Test_MA.mq4 |
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

int maPeriod = 20;
string ThisSymbol = "ETHEREUM";

void OnStart()
  {
//---


int digits = (int)MarketInfo(ThisSymbol,MODE_DIGITS);

double maValue = iMA(ThisSymbol, PERIOD_CURRENT, maPeriod, 0, MODE_SMA, PRICE_CLOSE, 0);
double ThisBB = iBands(ThisSymbol,PERIOD_CURRENT, maPeriod, 2, 0, PRICE_CLOSE, MODE_LOWER, 0);

Print("*****");
Print("Digits1    :  " + Digits );
Print("Digits2    :  " + digits );
Print("Normalize MA  :  " + NormalizeDouble( maValue, digits ));    
Print("Normalize BB :  " + NormalizeDouble( ThisBB , digits ));    

Print("*****");

//return NormalizeDouble(ThisIma, digits);

   
  }
//+------------------------------------------------------------------+
