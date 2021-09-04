package consortion
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   
   public class TransportCarTip extends BaseTip
   {
       
      
      private var _tempData:Vector.<String>;
      
      private var _bg:ScaleBitmapImage;
      
      private var _titleText:FilterFrameText;
      
      private var _costText:FilterFrameText;
      
      private var _bankrollText:FilterFrameText;
      
      private var _bankrollText2:FilterFrameText;
      
      private var _guarderReward:FilterFrameText;
      
      private var _rewardContribution:FilterFrameText;
      
      private var _rewardContribution1:FilterFrameText;
      
      private var _rewardMoney:FilterFrameText;
      
      private var _rewardMoney1:FilterFrameText;
      
      public function TransportCarTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.transportConfirm.carTip");
         this._titleText = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.tipStyle1");
         this._costText = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.tipStyle2");
         this._bankrollText = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.tipStyle3");
         this._bankrollText2 = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.tipStyle4");
         this._guarderReward = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.tipStyle2");
         this._rewardContribution = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.tipStyle3");
         this._rewardMoney = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.tipStyle3");
         this._rewardContribution1 = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.tipStyle4");
         this._rewardMoney1 = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.tipStyle4");
         this._guarderReward.text = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.guarderReward.text") + ":";
         this._rewardContribution.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.contribution.text") + ":";
         this._rewardMoney.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.money.text") + ":";
         this._costText.text = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.summomCost.txt") + ":";
         this.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         mouseChildren = false;
         mouseEnabled = false;
         addChild(this._titleText);
         addChild(this._guarderReward);
         addChild(this._rewardContribution);
         addChild(this._rewardContribution1);
         addChild(this._rewardMoney);
         addChild(this._rewardMoney1);
         addChild(this._costText);
         addChild(this._bankrollText);
         addChild(this._bankrollText2);
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         this._tempData = param1 as Vector.<String>;
         this._titleText.y = 5;
         this._titleText.text = param1[0] == null ? "" : param1[0];
         this._guarderReward.y = this._titleText.y + this._titleText.textHeight + 5;
         this._rewardContribution.y = this._rewardContribution1.y = this._guarderReward.y + this._guarderReward.textHeight + 5;
         this._rewardContribution1.x = this._rewardContribution.x + this._rewardContribution.textWidth + 10;
         this._rewardContribution1.text = param1[1] == null ? "" : param1[1];
         this._rewardMoney.y = this._rewardMoney1.y = this._rewardContribution1.y + this._rewardContribution1.textHeight + 5;
         this._rewardMoney1.x = this._rewardMoney.x + this._rewardMoney.textWidth + 10;
         this._rewardMoney1.text = param1[2] == null ? "" : param1[2];
         this._costText.y = this._rewardMoney1.y + this._rewardMoney1.textHeight + 5;
         this._bankrollText.text = param1[3] == null ? "" : param1[3];
         this._bankrollText.y = this._bankrollText2.y = this._costText.y + this._costText.textHeight + 5;
         this._bankrollText2.x = this._bankrollText.x + this._bankrollText.textWidth + 10;
         this._bankrollText2.htmlText = param1[4] == null ? "" : param1[4];
         this.drawBG();
      }
      
      private function reset() : void
      {
         this._bg.height = 0;
         this._bg.width = 0;
      }
      
      private function drawBG(param1:int = 0) : void
      {
         this.reset();
         this._bg.width = 115;
         this._bg.height = this._bankrollText2.y + this._bankrollText2.textHeight + 12;
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._tempData = null;
         this._bg = null;
         this._titleText = null;
         this._costText = null;
         this._bankrollText = null;
         this._bankrollText2 = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
