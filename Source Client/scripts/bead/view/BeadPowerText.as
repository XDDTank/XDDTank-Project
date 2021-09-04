package bead.view
{
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.DisplayObject;
   
   public class BeadPowerText extends FilterFrameText implements ITipedDisplay
   {
       
      
      private var _tipData:Object;
      
      private var _tipDirection:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      public function BeadPowerText()
      {
         super();
         this.mouseEnabled = true;
         this.selectable = false;
         ShowTipManager.Instance.addTip(this);
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1;
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
      
      override public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         super.dispose();
      }
   }
}
