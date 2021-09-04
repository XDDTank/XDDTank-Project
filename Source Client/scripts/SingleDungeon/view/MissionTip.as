package SingleDungeon.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestInfo;
   import flash.display.Sprite;
   
   public class MissionTip extends BaseTip
   {
       
      
      private var _container:Sprite;
      
      private var _bg:ScaleBitmapImage;
      
      public function MissionTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._container = new Sprite();
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         super.init();
         this.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._container);
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         var _loc2_:Vector.<QuestInfo> = param1 as Vector.<QuestInfo>;
         if(_loc2_ == null)
         {
            return;
         }
         _tipData = _loc2_;
         this.removeContent();
         this.addContent();
         this.drawBG();
      }
      
      private function addContent() : void
      {
         var _loc2_:FilterFrameText = null;
         var _loc3_:Image = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.tipData.length)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("singledungeon.missionTip.description");
            _loc2_.text = this.tipData[_loc1_].Detail;
            _loc2_.y = 20 + _loc1_ * 45;
            this._container.addChild(_loc2_);
            if(_loc1_ != this.tipData.length - 1)
            {
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
               _loc3_.y = _loc2_.y + _loc2_.height + 10;
               _loc3_.x = 12;
               this._container.addChild(_loc3_);
            }
            _loc1_++;
         }
      }
      
      private function removeContent() : void
      {
         while(this._container.numChildren > 0)
         {
            this._container.removeChildAt(0);
         }
      }
      
      private function drawBG() : void
      {
         this._bg.width = this._container.width + 10;
         this._bg.height = this._container.height + 40;
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._container)
         {
            ObjectUtils.disposeObject(this._container);
         }
         this._container = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
