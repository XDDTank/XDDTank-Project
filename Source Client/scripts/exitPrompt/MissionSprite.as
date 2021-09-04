package exitPrompt
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleUpDownImage;
   import com.pickgliss.ui.image.TiledImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class MissionSprite extends Sprite implements Disposeable
   {
       
      
      public var oldHeight:int;
      
      private const BG_X:int = -1;
      
      public const BG_Y:int = -72;
      
      private const BG_WIDTH:int = 290;
      
      private var _arr:Array;
      
      private var _bg:ScaleUpDownImage;
      
      public function MissionSprite(param1:Array)
      {
         super();
         this._arr = param1;
         this._init(this._arr);
      }
      
      private function _init(param1:Array) : void
      {
         var _loc3_:FilterFrameText = null;
         var _loc4_:Bitmap = null;
         var _loc5_:FilterFrameText = null;
         var _loc6_:TiledImage = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.MissionText0");
            _loc4_ = ComponentFactory.Instance.creatBitmap("exit.ExitMission.Arrow");
            _loc3_.text = param1[_loc2_][0] as String;
            _loc3_.y = _loc3_.height * _loc2_ * 3 / 2 - 6;
            _loc4_.x = 16;
            _loc4_.y = _loc3_.y;
            addChild(_loc3_);
            addChild(_loc4_);
            _loc5_ = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.MissionText1");
            _loc5_.text = param1[_loc2_][1] as String;
            _loc5_.y = _loc5_.height * _loc2_ * 3 / 2 - 4;
            addChild(_loc5_);
            _loc6_ = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.item.line");
            _loc6_.y = _loc3_.height * _loc2_ * 3 / 2 + 16;
            addChild(_loc6_);
            _loc2_++;
         }
         this.oldHeight = height;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.BtInfoBG");
         this._bg.width = this.BG_WIDTH;
         this._bg.height = this.height - this.BG_Y;
         this._bg.x = this.BG_X;
         this._bg.y = this.BG_Y;
         addChild(this._bg);
         setChildIndex(this._bg,0);
      }
      
      public function get content() : Array
      {
         return this._arr;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
