package room.view
{
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class RoomPlayerArea extends Sprite implements Disposeable, ITipedDisplay
   {
       
      
      protected var _tipData:Object;
      
      protected var _tipDirection:String;
      
      protected var _tipGapH:int;
      
      protected var _tipGapV:int;
      
      protected var _tipStyle:String;
      
      public function RoomPlayerArea()
      {
         super();
         this.addTip();
      }
      
      private function addTip() : void
      {
         this.tipDirctions = "2,7";
         this.tipGapV = 0;
         this.tipStyle = "ddtroom.RoomPlayerItemIip";
         ShowTipManager.Instance.addTip(this);
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirection;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirection = param1;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
