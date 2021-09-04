package bagAndInfo.fightPower
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   
   public class PowerUpSystemButtonTips extends BaseTip
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _tempData:Vector.<String>;
      
      private var _titleTxt:FilterFrameText;
      
      private var _recommendEquip:FilterFrameText;
      
      private var _scoreDesc:FilterFrameText;
      
      public function PowerUpSystemButtonTips()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("hall.fightPowerUpButtonTips.bg");
         this._titleTxt = ComponentFactory.Instance.creat("hall.powerUpTipsTitle.text");
         this._recommendEquip = ComponentFactory.Instance.creat("hall.powerUpTipsRecommendEquip.text");
         this._scoreDesc = ComponentFactory.Instance.creat("hall.powerUpTipsScoreDesc.text");
         this.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         mouseChildren = false;
         mouseEnabled = false;
         addChild(this._titleTxt);
         addChild(this._recommendEquip);
         addChild(this._scoreDesc);
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         this._tempData = param1 as Vector.<String>;
         this._titleTxt.text = param1[0] == null ? "" : param1[0];
         this._recommendEquip.htmlText = param1[1] == null ? "" : param1[1];
         this._scoreDesc.text = param1[2] == null ? "" : param1[2];
         this.drawBG();
      }
      
      private function drawBG() : void
      {
         this._bg.height = this._scoreDesc.y + this._scoreDesc.textHeight + 18;
         if(this._bg.width < this._recommendEquip.x + this._recommendEquip.textWidth + 20)
         {
            this._bg.width = this._recommendEquip.x + this._recommendEquip.textWidth + 20;
         }
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
