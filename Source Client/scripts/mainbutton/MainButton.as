package mainbutton
{
   public class MainButton
   {
       
      
      public var ID:String;
      
      private var _btnMark:int;
      
      private var _btnName:String;
      
      private var _btnServerVisable:int;
      
      private var _btnCompleteVisable:int;
      
      public var IsShow:Boolean;
      
      public function MainButton()
      {
         super();
      }
      
      public function get btnCompleteVisable() : int
      {
         return this._btnCompleteVisable;
      }
      
      public function set btnCompleteVisable(param1:int) : void
      {
         this._btnCompleteVisable = param1;
      }
      
      public function get btnServerVisable() : int
      {
         return this._btnServerVisable;
      }
      
      public function set btnServerVisable(param1:int) : void
      {
         this._btnServerVisable = param1;
      }
      
      public function get btnName() : String
      {
         return this._btnName;
      }
      
      public function set btnName(param1:String) : void
      {
         this._btnName = param1;
      }
      
      public function get btnMark() : int
      {
         return this._btnMark;
      }
      
      public function set btnMark(param1:int) : void
      {
         this._btnMark = param1;
      }
   }
}
