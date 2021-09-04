package SingleDungeon.expedition.view
{
   import SingleDungeon.expedition.ExpeditionInfo;
   import SingleDungeon.hardMode.HardModeManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class HardModeExpeditionInfoBefore extends Sprite implements Disposeable
   {
       
      
      private var _needPowerText:FilterFrameText;
      
      private var _needTimeText:FilterFrameText;
      
      private var _needTimeNum:int;
      
      private var _needPowerNum:int;
      
      private var _expeditionInfo:ExpeditionInfo;
      
      private var _infoFontBmp:Bitmap;
      
      public function HardModeExpeditionInfoBefore()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function checkFatigue() : Boolean
      {
         if(PlayerManager.Instance.Self.Fatigue < this._needPowerNum)
         {
            return false;
         }
         return true;
      }
      
      public function update() : void
      {
         this._needPowerNum = HardModeManager.instance.getChooseNeedFatigue();
         this._needTimeNum = HardModeManager.instance.getChooseNeedTime();
         this._needPowerText.text = this._needPowerNum + "/" + PlayerManager.Instance.Self.Fatigue;
         this._needTimeText.text = TimeManager.Instance.formatTimeToString1(this._needTimeNum);
      }
      
      private function initView() : void
      {
         this._infoFontBmp = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.hardMode.beforeInfo");
         addChild(this._infoFontBmp);
         this._needPowerText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.hardModeExpeditionInfoBefore.needEnergy.text");
         addChild(this._needPowerText);
         this._needTimeText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.hardModeExpeditionInfoBefore.needTime.text");
         addChild(this._needTimeText);
      }
      
      private function __updateFatigue(param1:PlayerPropertyEvent) : void
      {
         this.update();
      }
      
      private function removeView() : void
      {
         ObjectUtils.disposeObject(this._needPowerText);
         this._needPowerText = null;
         ObjectUtils.disposeObject(this._needTimeText);
         this._needTimeText = null;
         ObjectUtils.disposeObject(this._infoFontBmp);
         this._infoFontBmp = null;
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updateFatigue);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updateFatigue);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}
