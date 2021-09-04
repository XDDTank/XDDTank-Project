package platformapi.tencent.view.closeFriend
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.DaylyGiveInfo;
   import ddt.view.bossbox.BoxAwardsCell;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   
   public class LevelUpAwardFrameLevelGift extends BoxAwardsCell
   {
       
      
      private var _takenTip:Bitmap;
      
      public var giveInfo:DaylyGiveInfo;
      
      public var step:int;
      
      public function LevelUpAwardFrameLevelGift()
      {
         super();
         this._takenTip = ComponentFactory.Instance.creatBitmap("asset.IM.levelUpFrame.levelGift.GOT");
         this._takenTip.visible = false;
         addChild(this._takenTip);
         addEventListener(MouseEvent.ROLL_OVER,this.__onRollOver);
         addEventListener(MouseEvent.ROLL_OUT,this.__onRollOut);
      }
      
      override protected function initII() : void
      {
         super.initII();
         _itemName.textFormatStyle = "core.textformat.AwardTitleff9";
         removeChild(_count_txt);
      }
      
      public function set taken(param1:Boolean) : void
      {
         this._takenTip.visible = param1;
      }
      
      public function get taken() : Boolean
      {
         return this._takenTip.visible;
      }
      
      protected function __onRollOver(param1:MouseEvent) : void
      {
         Mouse.cursor = MouseCursor.BUTTON;
      }
      
      protected function __onRollOut(param1:MouseEvent) : void
      {
         Mouse.cursor = MouseCursor.AUTO;
      }
      
      override protected function initTip() : void
      {
         super.initTip();
         tipDirctions = "7,6,5,4,2,1,0,3,6";
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.__onRollOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.__onRollOut);
         super.dispose();
      }
   }
}
