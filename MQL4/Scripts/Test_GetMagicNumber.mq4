//+------------------------------------------------------------------+
//|                                               GetMagicNumber.mq4 |
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
   
   
   string ThisSymbol = "CARDANO";
   bool x =  StringToUpper(ThisSymbol);
    
   Print("***************");
   Print("Org : " + ThisSymbol);
   
   //Remove all other characters  
   for(int i=0;i<255;i++)
   {
      if ((i < 65) || (i > 90))
      {
         StringReplace(ThisSymbol,CharToString(i),"");
      }     
   }
     
   for(int i=0;i<26;i++)
   {
      StringReplace(ThisSymbol,CharToString(i+65),i+1);   
   }
   
   ThisSymbol = StringSubstr(ThisSymbol,0,9);
   Print("Int " + StrToInteger(ThisSymbol));
   
   Print("***************");
   
   

  }
//+------------------------------------------------------------------+
