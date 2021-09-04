package consortion
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   
   public class ConsortiaTaskLevelTip extends BaseTip
   {
       
      
      private var _tempData:Vector.<String>;
      
      private var _bg:ScaleBitmapImage;
      
      private var _explainText:FilterFrameText;
      
      private var _contributionText:FilterFrameText;
      
      private var _contributionText2:FilterFrameText;
      
      private var _bankrollText:FilterFrameText;
      
      private var _bankrollText2:FilterFrameText;
      
      private var _openLevelText:FilterFrameText;
      
      private var _rule1:ScaleBitmapImage;
      
      private var _publishLevel:int;
      
      public function ConsortiaTaskLevelTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._explainText = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionTask.titleTips.text");
         this._contributionText = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionTask.rewardTips1.text");
         this._contributionText2 = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionTask.rewardTips2.text");
         this._bankrollText = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionTask.rewardTips1.text");
         this._bankrollText2 = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionTask.rewardTips2.text");
         this._openLevelText = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionTask.openLevel.text");
         this._explainText.text = LanguageMgr.GetTranslation("ddt.consortion.taskLevelTip.explain");
         this._contributionText.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.contribution.text");
         this._bankrollText.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.Exp.text");
         this._rule1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._rule1.x = 3;
         this.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         mouseChildren = false;
         mouseEnabled = false;
         addChild(this._explainText);
         addChild(this._contributionText);
         addChild(this._contributionText2);
         addChild(this._bankrollText);
         addChild(this._bankrollText2);
         addChild(this._rule1);
         addChild(this._openLevelText);
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         this._tempData = param1 as Vector.<String>;
         this._contributionText.y = this._contributionText2.y = this._explainText.y + this._explainText.textHeight + 8;
         this._contributionText2.text = param1[0] == null ? "" : param1[0];
         this._contributionText2.x = this._contributionText.x + this._contributionText.textWidth + 20;
         this._bankrollText.y = this._bankrollText2.y = this._contributionText2.y + this._contributionText2.textHeight + 8;
         this._bankrollText2.htmlText = param1[1] == null ? "" : param1[1];
         this._bankrollText2.x = this._bankrollText.x + this._bankrollText.textWidth + 20;
         this._publishLevel = param1[2] == null ? int(1) : int(int(param1[2]));
         if(PlayerManager.Instance.Self.consortiaInfo.Level < this._publishLevel)
         {
            this._rule1.y = this._bankrollText2.textHeight + this._bankrollText2.y + 8;
            this._openLevelText.y = this._rule1.y + 5;
            this._openLevelText.text = LanguageMgr.GetTranslation("consortion.ConsortionTask.taskOpenLevel.text",param1[2] == null ? "" : param1[2]);
            this._rule1.visible = true;
            this._openLevelText.visible = true;
         }
         else
         {
            this._rule1.visible = false;
            this._openLevelText.visible = false;
         }
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
         this._bg.width = 151;
         if(PlayerManager.Instance.Self.consortiaInfo.Level < this._publishLevel)
         {
            this._bg.height = this._openLevelText.y + this._openLevelText.textHeight + 15;
         }
         else
         {
            this._bg.height = this._bankrollText2.y + this._bankrollText2.textHeight + 15;
         }
         this._rule1.width = 120;
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._tempData = null;
         this._bg = null;
         this._explainText = null;
         this._contributionText = null;
         this._contributionText2 = null;
         this._bankrollText = null;
         this._bankrollText2 = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
