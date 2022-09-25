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

//Indicators
double ThisMA;
double ThisBBUpper;
double ThisBBMain;
double ThisBBLower;


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
       ThisMA           = GetMovingAverage(ThisSymbol, 20);
       ThisBBUpper      = GetBollingerBand(ThisSymbol, 20, 2, MODE_UPPER);
       ThisBBMain       = GetBollingerBand(ThisSymbol, 20, 2, MODE_MAIN);
       ThisBBLower      = GetBollingerBand(ThisSymbol, 20, 2, MODE_LOWER);
         
       Print("***************************");
       Print("ThisPipValue    :  "  + ThisPipValue); 
       Print("MagicNumber     :  "  + ThisMagicNumber);
       Print("MovingAverage   :  "  + ThisMA);
       Print("BollingerUpper  :  "  + ThisBBUpper);
       Print("BollingerMain   :  "  + ThisBBMain);
       Print("BollingerLower  :  "  + ThisBBLower);
       Print("****" + ThisSymbol + "*****");  
       
              
      }
      
      
      //Is Trade Allowed
      
      
   }
   
   
  }
//+------------------------------------------------------------------+
