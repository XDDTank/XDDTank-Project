package ddt.loader
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class TempleteObject
   {
       
      
      public var filename:String;
      
      public var analyzer:DataAnalyzer;
      
      public function TempleteObject(param1:String, param2:DataAnalyzer)
      {
         super();
         this.filename = param1;
         this.analyzer = param2;
      }
   }
}
