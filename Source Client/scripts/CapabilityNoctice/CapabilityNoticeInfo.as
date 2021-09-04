package CapabilityNoctice
{
   public class CapabilityNoticeInfo
   {
       
      
      private var _level:int;
      
      private var _name:String;
      
      private var _pic:String;
      
      public function CapabilityNoticeInfo()
      {
         super();
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get pic() : String
      {
         return this._pic;
      }
      
      public function set pic(param1:String) : void
      {
         this._pic = param1;
      }
   }
}
